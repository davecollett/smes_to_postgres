create table smes.creation_dates_full as(
select mp.mark_id, mn.nine_fig, cd.earliest_date, cd.installed_by, mp.display_name, mp.symbol_type_mga, mp.geom
from smes.map_point mp, 
	smes.creation_dates cd, 
	smes.mark_name mn
where mp.mark_id = cd.mark_id AND
	mp.mark_id = mn.mark_id AND
	mn.best_name = 'X');
ALTER TABLE smes.creation_dates_full 
	ADD PRIMARY KEY (mark_id);
ALTER TABLE smes.creation_dates_full
 	OWNER TO dave; 


CREATE OR REPLACE VIEW scn.vw_isolated_gnss AS 
 SELECT DISTINCT un.nine_fig,
    un.pos_uncertainty,
    un.v_uncertainty,
    un.adjustment,
    cd.symbol_type_mga,
    cd.geom
   FROM scn.uncert un,
    smes.creation_dates_full cd
  WHERE un.nine_fig = cd.nine_fig AND un.v_uncertainty::text > '1'::text;

ALTER TABLE scn.vw_isolated_gnss
  OWNER TO dave;

