set linesize 9999
set pagesize 50000
set colsep , 
set headers off
set heading off
set sqlformat csv
set feedback off
SET TERM OFF
spool adjustment_type.csv
select * from adjustment_type;

spool datum.csv
select * from datum;

spool h_class.csv
select * from h_class;

spool h_order.csv
select * from h_order;

spool h_tech.csv
select * from h_tech;

spool v_class.csv
select * from v_class;

spool v_order.csv
select * from v_order;

spool v_tech.csv
select * from v_tech;

spool msr_type.csv
select * from msr_type;

spool name_type.csv
select * from name_type;

spool parish.csv
select * from parish;

spool mark_status.csv
select * from mark_status;

spool msr_category.csv
select * from msr_category;





spool adjustment.csv
select * from adjustment;

spool comments.csv
select * from comments;

spool creation_dates.csv
select * from creation_dates;

spool mark_coordinates.csv
select * from mark_coordinates;

spool mark_description.csv
select * from mark_description;

spool mark_horizontal.csv
select * from mark_horizontal;

spool mark_measurements.csv
select * from mark_measurements;

spool mark_name.csv
select * from mark_name;



spool mark_uncertainty.csv
select * from mark_uncertainty;

spool mark_vertical.csv
select * from mark_vertical;

spool measurement_adj.csv
select * from measurement_adj;

spool measurement_adj_files.csv
select * from measurement_adj_files;

spool msr_angle.csv
select * from msr_angle;

spool msr_comments.csv
select * from msr_comments;

spool msr_coordinate.csv
select * from msr_coordinate;

spool msr_direction.csv
select * from msr_direction;

spool msr_direction_set.csv
select * from msr_direction_set;

spool msr_distance.csv
select * from msr_distance;

spool msr_geodetic.csv
select * from msr_geodetic;

spool msr_gnss_baseline.csv
select * from msr_gnss_baseline;

spool msr_gnss_covariance.csv
select * from msr_gnss_covariance;

spool msr_gnss_datum.csv
select * from msr_gnss_datum;

spool msr_gnss_point.csv
select * from msr_gnss_point;

spool msr_gnss_scaling.csv
select * from msr_gnss_scaling;

spool msr_height.csv
select * from msr_height;

spool msr_height_difference.csv
select * from msr_height_difference;

spool msr_project.csv
select * from msr_project;

spool proj_comments.csv
select * from proj_comments;

spool map_point.csv
select mark_id, mark_h_id, symbol_type_AMG, symbol_type_mga, display_name, status from map_point;


SET TERM ON
exit