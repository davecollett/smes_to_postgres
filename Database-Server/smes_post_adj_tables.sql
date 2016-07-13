UPDATE scn.uncert
SET nine_fig=subquery.nine_fig
FROM	(select 	mn.nine_fig , un.nine_fig as code
		from 	smes.mark_name mn,
			scn.uncert un
		where 	un.nine_fig = mn.mark_name AND
			un.nine_fig ~'[A-Z]'
		order by mark_name) as subquery
WHERE uncert.nine_fig=subquery.code;

UPDATE scn.measurements
SET nine_fig=subquery.nine_fig
FROM	(select 	mn.nine_fig , un.nine_fig as code
		from 	smes.mark_name mn,
			scn.measurements un
		where 	un.nine_fig = mn.mark_name AND
			un.nine_fig ~'[A-Z]'
		order by mark_name) as subquery
WHERE measurements.nine_fig=subquery.code;


DROP TABLE scn.isolated_gnss_adj_current;
CREATE TABLE scn.isolated_gnss_adj_current as
(
  select un.nine_fig, un.v_uncertainty, un.adjustment, cd.geom
  from scn.uncert un,
  (select max(adjustment) as adj from scn.uncert where adjustment ilike '%GNSS') mx,
  smes.creation_dates_full cd
  where v_uncertainty > '1' and 
  adjustment = mx.adj and
  un.nine_fig = cd.nine_fig
);
ALTER TABLE scn.isolated_gnss_adj_current
  OWNER TO dave;
ALTER TABLE scn.isolated_gnss_adj_current 
	ADD PRIMARY KEY (nine_fig); 


DROP TABLE scn.isolated_gnss_adj_fixed;

CREATE TABLE scn.isolated_gnss_adj_fixed as
(
select old.nine_fig , cd.geom
FROM
smes.creation_dates_full cd,
  (select distinct un.nine_fig
  from scn.uncert un,
  (select max(adjustment) as adj from scn.uncert where adjustment ilike '%GNSS') mx
  where v_uncertainty > '1' and 
  adjustment <> mx.adj and
  adjustment ilike '%GNSS') old
LEFT JOIN
  (select un.nine_fig
  from scn.uncert un,
  (select max(adjustment) as adj from scn.uncert where adjustment ilike '%GNSS') mx
  where v_uncertainty > '1' and 
  adjustment = mx.adj ) latest
ON latest.nine_fig = old.nine_fig
WHERE latest.nine_fig IS NULL AND cd.nine_fig = old.nine_fig
ORDER BY nine_fig
);
ALTER TABLE scn.isolated_gnss_adj_fixed
  OWNER TO dave;
ALTER TABLE scn.isolated_gnss_adj_fixed 
	ADD PRIMARY KEY (nine_fig);  



drop table scn.isolated_gnss_adj_made_worse;

CREATE TABLE scn.isolated_gnss_adj_made_worse as
(
select latest.nine_fig , cd.geom
FROM
smes.creation_dates_full cd,
  (select un.nine_fig
  from scn.uncert un,
  (select max(adjustment) as adj from scn.uncert where adjustment ilike '%GNSS') mx
  where v_uncertainty > '1' and 
  adjustment = mx.adj ) latest
LEFT JOIN
    (select distinct un.nine_fig
  from scn.uncert un,
  (select max(adjustment) as adj from scn.uncert where adjustment ilike '%GNSS') mx
  where v_uncertainty > '1' and 
  adjustment <> mx.adj and
  adjustment ilike '%GNSS') old
ON old.nine_fig = latest.nine_fig 
WHERE old.nine_fig IS NULL AND cd.nine_fig = latest.nine_fig
ORDER BY nine_fig
);
ALTER TABLE scn.isolated_gnss_adj_made_worse
  OWNER TO dave;
ALTER TABLE scn.isolated_gnss_adj_made_worse 
	ADD PRIMARY KEY (nine_fig);  

create view scn.vw_scn_pos_uncert_over_40cm as (
select uc.nine_fig, uc.pos_uncertainty as pu, uc.v_uncertainty as vu, uc.adjustment as adj, cd.geom
FROM scn.uncert uc,
(select max(adjustment) as adj from scn.uncert where adjustment ilike '%FULL') adj,
smes.creation_dates_full cd
where uc.adjustment = adj.adj AND
uc.nine_fig = cd.nine_fig AND
uc.pos_uncertainty > '0.4');

create view scn.vw_scn_pos_uncert_over_20cm as (
select uc.nine_fig, uc.pos_uncertainty as pu, uc.v_uncertainty as vu, uc.adjustment as adj, cd.geom
FROM scn.uncert uc,
(select max(adjustment) as adj from scn.uncert where adjustment ilike '%FULL') adj,
smes.creation_dates_full cd
where uc.adjustment = adj.adj AND
uc.nine_fig = cd.nine_fig AND
uc.pos_uncertainty > '0.2');

create view scn.vw_scn_pos_uncert_over_10cm as (
select uc.nine_fig, uc.pos_uncertainty as pu, uc.v_uncertainty as vu, uc.adjustment as adj, cd.geom
FROM scn.uncert uc,
(select max(adjustment) as adj from scn.uncert where adjustment ilike '%FULL') adj,
smes.creation_dates_full cd
where uc.adjustment = adj.adj AND
uc.nine_fig = cd.nine_fig AND
uc.pos_uncertainty > '0.1');


--Orphaned 3rd Order (Fixed in Adjustment)
DROP VIEW scn.vw_orphaned_third_order_fixed;
CREATE VIEW scn.vw_orphaned_third_order_fixed as (
SELECT 	t1.nine_fig
	,ht.h_tech_txt as technique
	,t1.organisation
	, t1.date_edit
	, t1.date_surv
	,t1.h_order
	, t1.pos_uncertainty,
	mp.geom
FROM 	smes.h_tech ht,
	(select mn.nine_fig
		,mc.technique
		, mc.organisation
		, mc.date_edit
		, mc.date_surv
		, mc.h_order
		, mc.pos_uncertainty 
	FROM 	smes.mark_coordinates mc ,
		smes.mark_name mn
	WHERE (mc.h_order = '3' OR mc.h_order = '2') 
		AND mc.best_coords = 'X' 
		AND mc.adj_id IS NULL
		AND mc.mark_id = mn.mark_id
		AND mn.best_name = 'X'	) t1,
	(SELECT nine_fig
	FROM 	scn.uncert uc,
		(select max(adjustment) as adj 
		from 	scn.uncert 
		WHERE adjustment ilike '%FULL') adj
	WHERE uc.adjustment = adj.adj) t2 ,
	(select mn.nine_fig , mp.geom
		from smes.map_point mp, smes.mark_name mn
		where mp.mark_id = mn.mark_id
		AND mn.best_name = 'X') mp
WHERE 	t1.nine_fig = t2.nine_fig AND
	t1.nine_fig = mp.nine_fig AND
	t1.technique = ht.h_tech);




-- Orphaned 3rd Order (Unfixed in Adjustment)
DROP VIEW scn.vw_orphaned_third_order_current;	
CREATE VIEW scn.vw_orphaned_third_order_current as (
SELECT t1.nine_fig
	,ht.h_tech_txt as technique
	,t1.organisation
	, t1.date_edit
	, t1.date_surv
	,t1.h_order
	, t1.pos_uncertainty,
	mp.geom 
FROM 	smes.h_tech ht,
	(select mn.nine_fig , mp.geom
		from smes.map_point mp, smes.mark_name mn
		where mp.mark_id = mn.mark_id
		AND mn.best_name = 'X') mp,
	(select mn.nine_fig
		,mc.technique
		, mc.organisation
		, mc.date_edit
		, mc.date_surv
		, mc.h_order
		, mc.pos_uncertainty 
	from 	smes.mark_coordinates mc ,
		smes.mark_name mn
	where (mc.h_order = '3' OR mc.h_order = '2') 
		AND mc.best_coords = 'X' 
		AND mc.adj_id IS NULL
		AND mc.mark_id = mn.mark_id
		AND mn.best_name = 'X'	) t1
LEFT JOIN (select nine_fig
		FROM scn.uncert uc,
		(select max(adjustment) as adj from scn.uncert where adjustment ilike '%FULL') adj
		where uc.adjustment = adj.adj) t2 
ON t2.nine_fig = t1.nine_fig
WHERE t2.nine_fig IS NULL AND
	t1.nine_fig = mp.nine_fig AND
	t1.technique = ht.h_tech
ORDER BY nine_fig);

drop view scn.vw_CORS cascade;
create or replace view scn.vw_CORS AS
(select mn.nine_fig,  symbol_type_mga, display_name, geom
from 		smes.mark_name mn,
		smes.map_point mp
where 	mn.name_type='Y' AND
	mn.mark_id=mp.mark_id AND
	mp.status='OK' AND
	mn.best_name='X');

drop view scn.vw_CORS_not_sinex;
create or replace view scn.vw_CORS_not_sinex AS(
select ms.nine_fig, 
vc.symbol_type_mga ,
vc.display_name,
ms.msr_types,
ms.adjustment,
vc.geom
from scn.vw_cors vc, 
	scn.measurements ms
where ms.nine_fig = vc.nine_fig AND
	ms.adjustment = (SELECT max(measurements.adjustment::text) AS adj
                   FROM scn.measurements
                  WHERE measurements.adjustment ilike '%FULL')
AND ms.msr_types not ilike '%Y%');

drop view scn.vw_CORS_sinex;
create or replace view scn.vw_CORS_sinex AS(
select ms.nine_fig, 
vc.symbol_type_mga ,
vc.display_name,
ms.msr_types,
ms.adjustment,
vc.geom
from scn.vw_cors vc, 
	scn.measurements ms
where ms.nine_fig = vc.nine_fig AND
	ms.adjustment = (SELECT max(measurements.adjustment::text) AS adj
                   FROM scn.measurements
                  WHERE measurements.adjustment ilike '%FULL')
AND ms.msr_types ilike '%Y%');

drop view scn.vw_CORS_not_connected;
create or replace view scn.vw_CORS_not_connected AS(
select ms.nine_fig, 
vc.symbol_type_mga ,
vc.display_name,
ms.msr_types,
ms.adjustment,
vc.geom
from scn.vw_cors vc, 
	scn.measurements ms
where ms.nine_fig = vc.nine_fig AND
	ms.adjustment = (SELECT max(measurements.adjustment::text) AS adj
                   FROM scn.measurements
                  WHERE measurements.adjustment ilike '%FULL')
AND ms.msr_types not ilike '%G%');


drop view scn.vw_CORS_connected;
create or replace view scn.vw_CORS_connected AS(
select ms.nine_fig, 
vc.symbol_type_mga ,
vc.display_name,
ms.msr_types,
ms.adjustment,
vc.geom
from scn.vw_cors vc, 
	scn.measurements ms
where ms.nine_fig = vc.nine_fig AND
	ms.adjustment = (SELECT max(measurements.adjustment::text) AS adj
                   FROM scn.measurements
                  WHERE measurements.adjustment ilike '%FULL')
AND ms.msr_types ilike '%G%');

CREATE VIEW smes.vw_hsm_marks_gnss as (

select 	distinct mp.mark_id, 
	mn.nine_fig, 
	mn.mark_name,
	mp.display_name, 
	mp.status, 
	mp.symbol_type_mga, 
	mp.geom
from 	smes.map_point mp,
	smes.mark_name mn,
	scn.measurements ms
where 	mp.mark_id = mn.mark_id
	AND mn.name_type = 'H'
	AND ms.nine_fig = mn.nine_fig
	AND ms.msr_types ilike '%G%'
	)	;

	
CREATE VIEW smes.vw_hsm_marks as (
select 	mp.mark_id, 
	mn.nine_fig, 
	mn.mark_name,
	mp.display_name, 
	mp.status, 
	mp.symbol_type_mga, 
	mp.geom
from 	smes.map_point mp,
	smes.mark_name mn
where 	mp.mark_id = mn.mark_id
	AND mn.name_type = 'H'
)
