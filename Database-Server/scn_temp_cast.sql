\echo 'insert adjustment'
insert into scn.adjustment 
	select  
  cast(adj_id  AS numeric(15,0)),
  cast(adj_date  AS date),
  cast(adj_d_code AS  character varying),
  cast(adj_epoch AS  date),
  cast(adj_runby  AS character varying),
  cast(best_adj AS  character(1)),
  cast(dof  AS numeric(15,0)),
  cast(measurement_count AS  numeric(15,0)),
  cast(unknowns_count AS  numeric(15,0)),
  cast(chi_square AS  numeric(15,4)),
  cast(sigma_zero  AS numeric(15,4)),
  cast(lower_limit AS  numeric(15,4)),
  cast(upper_limit AS  numeric(15,4)),
  cast(confidence_interval  AS numeric(5,2)),
  cast(adj_type  AS character(5))
	from scn.adjustment_temp ;

\echo 'insert msr_geodetic'
insert into scn.msr_geodetic 
	select  
		CAST(msr_id  AS numeric(15,0)),
		cast(msr_type  as character(2)),
		cast(msr_stations  as character varying(1)),
		cast( seq_id  as numeric(15,0)),
		cast( cluster_id  as numeric(15,0)),
		cast( adj_id  as numeric(15,0)),
 		cast( ignore  as character varying(1)),
		cast( msr_category  as character(5)),
 		cast( msr_comment_id  as numeric(10,0)),
		cast( msr_edit_comments  as character varying(512))
	from scn.msr_geodetic_temp;


\echo 'insert project'
insert into scn.msr_project
	select  
	  CAST(msr_project_id  AS numeric(15,0)),
  	CAST(project_id  AS numeric(15,0)),
  	CAST(msr_id  AS numeric(15,0))
	from scn.msr_project_temp;
	
	
	
\echo 'update msr_direction_temp names'	
update scn.msr_direction_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.msr_direction_temp
where mark_name.mark_name = msr_direction_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where msr_direction_temp.mark_id_from = a.mark_id_from;

update scn.msr_direction_temp
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.msr_direction_temp
where mark_name.mark_name = msr_direction_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where msr_direction_temp.mark_id_to = a.mark_id_to;

update scn.msr_direction_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.msr_direction_temp
where mark_name.nine_fig= msr_direction_temp.mark_id_to) a
where msr_direction_temp.mark_id_to = a.mark_id_to;

update scn.msr_direction_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.msr_direction_temp
where mark_name.nine_fig= msr_direction_temp.mark_id_from) a
where msr_direction_temp.mark_id_from = a.mark_id_from;	
	
	
\echo 'insert msr_direction_temp'	
insert into scn.msr_direction
	select  
  	cast(msr_id AS  numeric(15,0)),
  	cast(mark_id_from AS  numeric(15,0)),
  	cast(mark_id_to AS  numeric(15,0)),
  	cast(direction AS  numeric(15,12)),
  	cast(std_dev AS  numeric(9,6)),
  	cast(instrument_ht AS  numeric(6,3)),
  	cast(target_ht AS  numeric(6,3))
	from scn.msr_direction_temp;
	
	
\echo 'update msr_direction_set_temp names'	
update scn.msr_direction_set_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.msr_direction_set_temp
where mark_name.mark_name = msr_direction_set_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where msr_direction_set_temp.mark_id_from = a.mark_id_from;

update scn.msr_direction_set_temp 
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.msr_direction_set_temp
where mark_name.mark_name = msr_direction_set_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where msr_direction_set_temp.mark_id_to = a.mark_id_to;

update scn.msr_direction_set_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.msr_direction_set_temp
where mark_name.nine_fig= msr_direction_set_temp.mark_id_to) a
where msr_direction_set_temp.mark_id_to = a.mark_id_to;

update scn.msr_direction_set_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.msr_direction_set_temp
where mark_name.nine_fig= msr_direction_set_temp.mark_id_from) a
where msr_direction_set_temp.mark_id_from = a.mark_id_from;
	
	
\echo 'insert into msr_direction_set'
insert into scn.msr_direction_set
	select 	
  	cast(msr_id AS  numeric(15,0)),
  	cast(mark_id_from  AS numeric(15,0)),
  	cast(mark_id_to AS  numeric(15,0)),
  	cast(direction AS  numeric(15,12)),
  	cast(std_dev AS  numeric(9,6)),
  	cast(set_count AS  numeric(3,0))
	from scn.msr_direction_set_temp;
	
\echo 'update msr_gnss_baseline_temp names'
update scn.msr_gnss_baseline_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.msr_gnss_baseline_temp
where mark_name.mark_name = msr_gnss_baseline_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where msr_gnss_baseline_temp.mark_id_from = a.mark_id_from;

update scn.msr_gnss_baseline_temp 
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.msr_gnss_baseline_temp
where mark_name.mark_name = msr_gnss_baseline_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where msr_gnss_baseline_temp.mark_id_to = a.mark_id_to;

update scn.msr_gnss_baseline_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.msr_gnss_baseline_temp
where mark_name.nine_fig= msr_gnss_baseline_temp.mark_id_to) a
where msr_gnss_baseline_temp.mark_id_to = a.mark_id_to;

update scn.msr_gnss_baseline_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.msr_gnss_baseline_temp
where mark_name.nine_fig= msr_gnss_baseline_temp.mark_id_from) a
where msr_gnss_baseline_temp.mark_id_from = a.mark_id_from;


\echo 'insert into msr_gnss_baseline'
insert into scn.msr_gnss_baseline
	select 	
  	cast(msr_id AS  numeric(15,0)),
  	cast(mark_id_from AS  numeric(15,0)),
  	cast(mark_id_to  AS numeric(15,0)),
  	cast(var_count AS  numeric(12,0)),
  	cast(covar_count AS  numeric(12,0)),
  	cast(x AS  numeric(13,5)),
  	cast(y  AS numeric(13,5)),
  	cast(z AS  numeric(13,5)),
  	cast(xx AS  numeric(23,20)),
  	cast(xy  AS numeric(23,20)),
  	cast(xz  AS numeric(23,20)),
  	cast(yy  AS numeric(23,20)),
  	cast(yz AS  numeric(23,20)),
  	cast(zz AS  numeric(23,20))
	from scn.msr_gnss_baseline_temp;
	
\echo 'update msr_distance_temp names'
update scn.msr_distance_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.msr_distance_temp
where mark_name.mark_name = msr_distance_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where msr_distance_temp.mark_id_from = a.mark_id_from;

update scn.msr_distance_temp 
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.msr_distance_temp
where mark_name.mark_name = msr_distance_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where msr_distance_temp.mark_id_to = a.mark_id_to;

update scn.msr_distance_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.msr_distance_temp
where mark_name.nine_fig= msr_distance_temp.mark_id_to) a
where msr_distance_temp.mark_id_to = a.mark_id_to;


update scn.msr_distance_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.msr_distance_temp
where mark_name.nine_fig= msr_distance_temp.mark_id_from) a
where msr_distance_temp.mark_id_from = a.mark_id_from;

\echo 'insert into msr_distance'
  insert into scn.msr_distance
	select 	
	  	cast(msr_id  AS numeric(15,0)),
  		cast(mark_id_from AS  numeric(15,0)),
  		cast(mark_id_to AS  numeric(15,0)),
 		 	cast(distance AS  numeric(13,5)),
  		cast(std_dev AS  numeric(8,5)),
  		cast(instrument_ht AS  numeric(5,3)),
  		cast(target_ht AS  numeric(5,3))
	from scn.msr_distance_temp;
	
\echo 'Update height_temp numbers	'
	update scn.msr_height_temp 
set mark_id  = nine_fig
from 
(select nine_fig, msr_height_temp.mark_id
from smes.mark_name, scn.msr_height_temp
where mark_name.mark_name = msr_height_temp.mark_id
AND mark_name.name_type = 'Y'
AND char_length(msr_height_temp.mark_id) = 4) a
where msr_height_temp.mark_id = a.mark_id;

update scn.msr_height_temp 
set mark_id  = a.mark_id
from 
(select mark_name.mark_id, msr_height_temp.mark_id as nine_fig
from smes.mark_name, scn.msr_height_temp
where mark_name.nine_fig= msr_height_temp.mark_id) a
where msr_height_temp.mark_id = a.nine_fig;

\echo 'insert to msr_height'
  insert into scn.msr_height
	select 	
	  	cast(msr_id  AS numeric(15,0)),
    	cast(mark_id  AS numeric(15,0)),
    	cast(height  AS numeric(10,4)),
    	cast(std_dev  AS numeric(8,5))
	from scn.msr_height_temp;	

\echo 'insert to msr_gnss_scaling'
  insert into scn.msr_gnss_scaling
	select 	
  cast(cluster_id  AS numeric(15,0)),
  cast(vscale AS  numeric(12,2)),
  cast(pscale AS  numeric(12,2)),
  cast(lscale AS  numeric(12,2)),
  cast(hscale  AS numeric(12,2))
  	from scn.msr_gnss_scaling_temp;	

\echo 'insert to adj_msr_conventional'  	
  insert into scn.adj_msr_conventional
	select 	
    cast(msr_id AS  numeric(15,0)),
    cast(adj_id AS  numeric(15,0)),
    cast(nstat AS  numeric(6,3)),
    cast(correction AS  numeric(10,5)),
    cast(adj_std_dev AS  numeric(9,5))
  	from scn.adj_msr_conventional_temp;	

\echo 'insert to adj_msr_gnss ' 	
  insert into scn.adj_msr_gnss
	select 	
    cast(msr_id  AS numeric(15,0)),
    cast(adj_id AS  numeric(15,0)),
    cast(x_corr AS  numeric(13,5)),
    cast(y_corr AS  numeric(13,5)),
    cast(z_corr  AS numeric(13,5)),
    cast(adj_x_std_dev AS  numeric(10,5)),
    cast(adj_y_std_dev  AS numeric(10,5)),
    cast(adj_z_std_dev AS  numeric(10,5)),
    cast(x_nstat AS  numeric(6,3)),
    cast(y_nstat AS  numeric(6,3)),
    cast(z_nstat AS  numeric(6,3))
  	from scn.adj_msr_gnss_temp;	


\echo 'Change names for Conv'
update scn.adj_msr_conv_results_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.adj_msr_conv_results_temp
where mark_name.mark_name = adj_msr_conv_results_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where adj_msr_conv_results_temp.mark_id_from = a.mark_id_from;

update scn.adj_msr_conv_results_temp
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.adj_msr_conv_results_temp
where mark_name.mark_name = adj_msr_conv_results_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where adj_msr_conv_results_temp.mark_id_to = a.mark_id_to;

update scn.adj_msr_conv_results_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.adj_msr_conv_results_temp
where mark_name.nine_fig= adj_msr_conv_results_temp.mark_id_to) a
where adj_msr_conv_results_temp.mark_id_to = a.mark_id_to;

update scn.adj_msr_conv_results_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.adj_msr_conv_results_temp
where mark_name.nine_fig= adj_msr_conv_results_temp.mark_id_from) a
where adj_msr_conv_results_temp.mark_id_from = a.mark_id_from;


\echo 'Change names for GNSS'
update scn.adj_msr_gnss_results_temp 
set mark_id_from  = nine_fig
from 
(select nine_fig, mark_id_from
from smes.mark_name, scn.adj_msr_gnss_results_temp
where mark_name.mark_name = adj_msr_gnss_results_temp.mark_id_from
AND mark_name.name_type = 'Y'
AND char_length(mark_id_from) = 4) a
where adj_msr_gnss_results_temp.mark_id_from = a.mark_id_from;

update scn.adj_msr_gnss_results_temp
set mark_id_to  = nine_fig
from 
(select nine_fig, mark_id_to
from smes.mark_name, scn.adj_msr_gnss_results_temp
where mark_name.mark_name = adj_msr_gnss_results_temp.mark_id_to
AND mark_name.name_type = 'Y'
AND char_length(mark_id_to) = 4) a
where adj_msr_gnss_results_temp.mark_id_to = a.mark_id_to;

update scn.adj_msr_gnss_results_temp 
set mark_id_to  = mark_id
from 
(select mark_id, mark_id_to
from smes.mark_name, scn.adj_msr_gnss_results_temp
where mark_name.nine_fig= adj_msr_gnss_results_temp.mark_id_to) a
where adj_msr_gnss_results_temp.mark_id_to = a.mark_id_to;

update scn.adj_msr_gnss_results_temp 
set mark_id_from  = mark_id
from 
(select mark_id, mark_id_from
from smes.mark_name, scn.adj_msr_gnss_results_temp
where mark_name.nine_fig= adj_msr_gnss_results_temp.mark_id_from) a
where adj_msr_gnss_results_temp.mark_id_from = a.mark_id_from;

\echo 'PUSH THE RESULTS TO THE TABLES'
\echo 'H Values'
update scn.adj_msr_conventional amc
SET 	msr_id = subquery.msr_id,
	adj_id = subquery.adj_id,
	nstat = subquery.nstat,
	correction = subquery.correction,
	adj_std_dev = subquery.adj_std_dev
FROM (select 	mr.msr_id, 
	cast( results.adj_id  as numeric(15,0)),
	cast(results.nstat AS  numeric(6,3)), 
    cast(results.correction AS  numeric(10,5)),
    cast(results.adj_std_dev AS  numeric(9,5))
from 	scn.msr_height mr, scn.adj_msr_conv_results_temp results 
where 	results.type = 'H' 
	AND mr.mark_id = cast(results.mark_id_from AS  numeric(15,0))
	AND mr.height = cast(results.measured AS  numeric(10,4))) as subquery
WHERE amc.msr_id = subquery.msr_id;

\echo 'Ellipsoidal Distances'
update scn.adj_msr_conventional amc
SET 	msr_id = subquery.msr_id,
	adj_id = subquery.adj_id,
	nstat = subquery.nstat,
	correction = subquery.correction,
	adj_std_dev = subquery.adj_std_dev
FROM (
select 	md.msr_id, 
	cast( results.adj_id  as numeric(15,0)),
	cast(results.nstat AS  numeric(6,3)), 
    cast(results.correction AS  numeric(10,5)),
    cast(results.adj_std_dev AS  numeric(9,5))
from 	scn.msr_distance md, scn.adj_msr_conv_results_temp results 
where 	results.type = 'E' 
	AND md.mark_id_from = cast(results.mark_id_from AS  numeric(15,0))
	AND md.mark_id_to = cast(results.mark_id_to AS  numeric(15,0))
	AND md.distance = cast(results.measured AS  numeric(13,5))) subquery
Where amc.msr_id = subquery.msr_id;

\echo 'MSL Arcs '
update scn.adj_msr_conventional amc
SET 	msr_id = subquery.msr_id,
	adj_id = subquery.adj_id,
	nstat = subquery.nstat,
	correction = subquery.correction,
	adj_std_dev = subquery.adj_std_dev
FROM (
	select 	md.msr_id, 
	cast( results.adj_id  as numeric(15,0)),
	cast(results.nstat AS  numeric(6,3)), 
    cast(results.correction AS  numeric(10,5)),
    cast(results.adj_std_dev AS  numeric(9,5))
from 	scn.msr_distance md, scn.adj_msr_conv_results_temp results 
where 	results.type = 'M' 
	AND md.mark_id_from = cast(results.mark_id_from AS  numeric(15,0))
	AND md.mark_id_to = cast(results.mark_id_to AS  numeric(15,0))
	AND md.distance = cast(results.measured AS  numeric(13,5))) subquery
Where amc.msr_id = subquery.msr_id;


\echo 'Directions'
update scn.adj_msr_conventional amc
SET 	msr_id = subquery.msr_id,
	adj_id = subquery.adj_id,
	nstat = subquery.nstat,
	correction = subquery.correction,
	adj_std_dev = subquery.adj_std_dev
FROM (
	select 	md.msr_id, 
	cast( results.adj_id  as numeric(15,0)),
	cast(results.nstat AS  numeric(6,3)), 
    cast(results.correction AS  numeric(10,5)),
    cast(results.adj_std_dev AS  numeric(9,5))
from 	scn.msr_direction md, 
	scn.adj_msr_conv_results_temp results 
where 	results.type = 'D' 
	AND md.mark_id_from = cast(results.mark_id_from AS  numeric(15,0))
	AND md.mark_id_to = cast(results.mark_id_to AS  numeric(15,0))
	AND md.direction = cast(results.measured AS  numeric(13,9)) )subquery
Where amc.msr_id = subquery.msr_id
AND subquery.adj_id = amc.adj_id;

\echo 'GNSS'
UPDATE 	scn.adj_msr_gnss amg
SET 	msr_id = subquery.msr_id,
	adj_id = subquery.adj_id,
	x_corr = subquery.x_corr,
	y_corr = subquery.y_corr,
	z_corr = subquery.z_corr,
	adj_x_std_dev = subquery.adj_x_std_dev,
	adj_y_std_dev = subquery.adj_y_std_dev,
	adj_z_std_dev = subquery.adj_z_std_dev,
	x_nstat = subquery.x_nstat,
	y_nstat = subquery.y_nstat,
	z_nstat = subquery.z_nstat
 FROM (select 	mgb.msr_id, 
	cast( results.adj_id  as numeric(15,0)),
	cast(results.x_corr AS  numeric(13,5)), 
	cast(results.y_corr AS  numeric(13,5)), 
	cast(results.z_corr AS  numeric(13,5)), 
	cast(results.adj_x_std_dev AS  numeric(10,5)), 
	cast(results.adj_y_std_dev AS  numeric(10,5)), 
	cast(results.adj_z_std_dev AS  numeric(10,5)), 
	cast(results.x_nstat AS  numeric(10,5)), 
	cast(results.y_nstat AS  numeric(10,5)), 
	cast(results.z_nstat AS  numeric(10,5))
	FROM scn.msr_gnss_baseline mgb,
				(select gx.adj_id, 
					gx.mark_id_from, 
					gx.mark_id_to, 
					gx.vector_number, 
					gx.measured as x_meas, 
					gy.measured as y_meas, 
					gz.measured as z_meas, 
					gx.correction as x_corr, 
					gy.correction as y_corr, 
					gz.correction as z_corr, 
					gx.adj_std_dev as adj_x_std_dev, 
					gy.adj_std_dev as adj_y_std_dev, 
					gz.adj_std_dev as adj_z_std_dev, 
					gx.nstat as x_nstat, 
					gy.nstat as y_nstat, 
					gz.nstat as z_nstat   
				   from 	(select * from scn.adj_msr_gnss_results_temp where type = 'GX') gx,
						(select * from scn.adj_msr_gnss_results_temp where type = 'GY') gy,
						(select * from scn.adj_msr_gnss_results_temp where type = 'GZ') gz
				    where gx.vector_number = gy.vector_number AND gy.vector_number = gz.vector_number ) results
	where  mgb.mark_id_from = cast(results.mark_id_from AS  numeric(15,0))
	AND  mgb.mark_id_to = cast(results.mark_id_to AS  numeric(15,0))
	AND  mgb.x = cast(results.x_meas AS  numeric(13,5))
	AND mgb.y = cast(results.y_meas AS  numeric(13,5))
	AND mgb.z = cast(results.z_meas AS  numeric(13,5))
				    ) subquery
Where amg.msr_id = subquery.msr_id
AND subquery.adj_id = amg.adj_id;



drop table scn.msr_comments_temp;
drop table scn.msr_geodetic_temp;
drop table scn.proj_comments_temp;
drop table scn.msr_project_temp;
drop table scn.msr_direction_temp;
drop table scn.msr_direction_set_temp;
drop table scn.msr_distance_temp;
drop table scn.msr_gnss_baseline_temp;
drop table scn.msr_gnss_covariance_temp;
drop table scn.msr_gnss_datum_temp;
drop table scn.msr_gnss_point_temp;
drop table scn.msr_gnss_scaling_temp;
drop table scn.msr_height_temp;
drop table scn.msr_height_difference_temp;
drop table scn.adj_msr_gnss_temp;
drop table scn.adj_msr_conventional_temp;
drop table scn.adj_msr_conv_results_temp;
drop table scn.adj_msr_gnss_results_temp;
drop table scn.adjustment_temp;