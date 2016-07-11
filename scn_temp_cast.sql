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



insert into scn.msr_project
	select  
	  CAST(msr_project_id  AS numeric(15,0)),
  	CAST(project_id  AS numeric(15,0)),
  	CAST(msr_id  AS numeric(15,0))
	from scn.msr_project_temp;
	
	
	
	
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
	
	
	
insert into scn.msr_direction_set
	select 	
  	cast(msr_id AS  numeric(15,0)),
  	cast(mark_id_from  AS numeric(15,0)),
  	cast(mark_id_to AS  numeric(15,0)),
  	cast(direction AS  numeric(15,12)),
  	cast(std_dev AS  numeric(9,6)),
  	cast(set_count AS  numeric(3,0))
	from scn.msr_direction_set_temp;
	
	
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

  insert into scn.msr_height
	select 	
	  	cast(msr_id  AS numeric(15,0)),
    	cast(mark_id  AS numeric(15,0)),
    	cast(height  AS numeric(10,4)),
    	cast(std_dev  AS numeric(8,5))
	from scn.msr_height_temp;	


  insert into scn.msr_gnss_scaling
	select 	
  cast(cluster_id  AS numeric(15,0)),
  cast(vscale AS  numeric(12,2)),
  cast(pscale AS  numeric(12,2)),
  cast(lscale AS  numeric(12,2)),
  cast(hscale  AS numeric(12,2))
  	from scn.msr_gnss_scaling_temp;	
  	
  insert into scn.adj_msr_conventional
	select 	
    cast(msr_id AS  numeric(15,0)),
    cast(adj_id AS  numeric(15,0)),
    cast(nstat AS  numeric(6,3)),
    cast(correction AS  numeric(10,5)),
    cast(adj_std_dev AS  numeric(9,5))
  	from scn.adj_msr_conventional_temp;	
  	
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