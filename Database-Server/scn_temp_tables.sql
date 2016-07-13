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


CREATE TABLE scn.msr_comments_temp
(
  MSR_COMMENT_ID VARCHAR 
, MSR_COMMENTS VARCHAR ) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_comments_temp
  OWNER TO dave;     

 CREATE TABLE scn.msr_geodetic_temp
(
  MSR_ID VARCHAR 
, MSR_TYPE VARCHAR
, MSR_STATIONS VARCHAR 
, SEQ_ID VARCHAR
, CLUSTER_ID VARCHAR 
, ADJ_ID VARCHAR
, IGNORE VARCHAR 
, MSR_CATEGORY VARCHAR
, MSR_COMMENT_ID VARCHAR
, MSR_EDIT_COMMENTS VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_geodetic_temp
  OWNER TO dave;    
  
CREATE TABLE scn.proj_comments_temp
(
  PROJECT_ID VARCHAR 
, PROJECT_NAME VARCHAR 
, PROJECT_COMMENTS VARCHAR
, PROJECT_SOURCE VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.proj_comments_temp
  OWNER TO dave;  
  
  
CREATE TABLE scn.msr_project_temp
(
  MSR_PROJECT_ID VARCHAR
, PROJECT_ID VARCHAR
, MSR_ID VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_project_temp
  OWNER TO dave;  
  
  
  
 
 
 CREATE TABLE scn.msr_direction_temp
(
  MSR_ID VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, DIRECTION VARCHAR
, STD_DEV VARCHAR
, INSTRUMENT_HT VARCHAR
, TARGET_HT VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_direction_temp
  OWNER TO dave;      
      
      
 CREATE TABLE scn.msr_direction_set_temp
(
  MSR_ID VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, DIRECTION VARCHAR
, STD_DEV VARCHAR
, SET_COUNT VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_direction_set_temp
  OWNER TO dave;          



 CREATE TABLE scn.msr_distance_temp
(
  MSR_ID VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, DISTANCE VARCHAR
, STD_DEV VARCHAR
, INSTRUMENT_HT VARCHAR
, TARGET_HT VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_distance_temp
  OWNER TO dave;          


 CREATE TABLE scn.msr_gnss_baseline_temp
(
  MSR_ID VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, VAR_COUNT VARCHAR
, COVAR_COUNT VARCHAR
, X VARCHAR
, Y VARCHAR
, Z VARCHAR
, XX VARCHAR 
, XY VARCHAR 
, XZ VARCHAR
, YY VARCHAR 
, YZ VARCHAR
, ZZ VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_gnss_baseline_temp
  OWNER TO dave; 
      
 CREATE TABLE scn.msr_gnss_covariance_temp
(
  GNSS_COV_ID VARCHAR 
, COV_ID VARCHAR 
, MSR_ID VARCHAR
, COV_1 VARCHAR
, COV_2 VARCHAR
, XX VARCHAR 
, XY VARCHAR
, XZ VARCHAR 
, YX VARCHAR
, YY VARCHAR
, YZ VARCHAR 
, ZX VARCHAR
, ZY VARCHAR 
, ZZ VARCHAR 
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_gnss_covariance_temp
  OWNER TO dave; 
  
 CREATE TABLE scn.msr_gnss_datum_temp
(
  CLUSTER_ID VARCHAR
, D_CODE VARCHAR 
, EPOCH VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_gnss_datum_temp
  OWNER TO dave;   
  
  
 CREATE TABLE scn.msr_gnss_point_temp
(
  MSR_ID VARCHAR
, MARK_ID VARCHAR
, VAR_COUNT VARCHAR
, COVAR_COUNT VARCHAR
, X VARCHAR
, Y VARCHAR 
, Z VARCHAR 
, XX VARCHAR 
, XY VARCHAR 
, XZ VARCHAR 
, YY VARCHAR
, YZ VARCHAR 
, ZZ VARCHAR 
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_gnss_point_temp
  OWNER TO dave;     
  
  
   CREATE TABLE scn.msr_gnss_scaling_temp
(
  CLUSTER_ID VARCHAR
, VSCALE VARCHAR
, PSCALE VARCHAR
, LSCALE VARCHAR
, HSCALE VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_gnss_scaling_temp
  OWNER TO dave; 
  
  
  
   CREATE TABLE scn.msr_height_temp
(
  MSR_ID VARCHAR
, MARK_ID VARCHAR
, HEIGHT VARCHAR
, STD_DEV VARCHAR 
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_height_temp
  OWNER TO dave;   
  
   CREATE TABLE scn.msr_height_difference_temp
(
  MSR_ID VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, HEIGHT_DIFFERENCE VARCHAR
, STD_DEV VARCHAR
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE scn.msr_height_difference_temp
  OWNER TO dave;     
  
  
  CREATE TABLE scn.adj_msr_gnss_temp
(
  MSR_ID VARCHAR
, ADJ_ID VARCHAR 
, X_CORR VARCHAR 
, Y_CORR VARCHAR
, Z_CORR VARCHAR
, ADJ_X_STD_DEV VARCHAR
, ADJ_Y_STD_DEV VARCHAR
, ADJ_Z_STD_DEV VARCHAR
, X_NSTAT VARCHAR 
, Y_NSTAT VARCHAR 
, Z_NSTAT VARCHAR
)
WITH( 
  OIDS=FALSE
);
ALTER TABLE scn.adj_msr_gnss_temp
  OWNER TO dave;
  
 
  
    CREATE TABLE scn.adj_msr_conventional_temp
(
  MSR_ID VARCHAR
, ADJ_ID VARCHAR
, NSTAT VARCHAR
, CORRECTION VARCHAR 
, ADJ_STD_DEV VARCHAR
 )
WITH( 
  OIDS=FALSE
);
ALTER TABLE scn.adj_msr_conventional_temp
  OWNER TO dave;





    CREATE TABLE scn.adj_msr_conv_results_temp
(   ADJ_ID VARCHAR
, TYPE VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, MEASURED VARCHAR
, CORRECTION VARCHAR 
, ADJ_STD_DEV VARCHAR
, NSTAT VARCHAR
 )
WITH( 
  OIDS=FALSE
);
ALTER TABLE scn.adj_msr_conv_results_temp
  OWNER TO dave;

    CREATE TABLE scn.adj_msr_gnss_results_temp
(   ADJ_ID VARCHAR
, TYPE VARCHAR
, MARK_ID_FROM VARCHAR
, MARK_ID_TO VARCHAR
, VECTOR_NUMBER VARCHAR
, MEASURED VARCHAR
, CORRECTION VARCHAR 
, ADJ_STD_DEV VARCHAR
, NSTAT VARCHAR
 )
WITH( 
  OIDS=FALSE
);
ALTER TABLE scn.adj_msr_gnss_results_temp
  OWNER TO dave;

    CREATE TABLE scn.adjustment_temp
(   ADJ_ID VARCHAR
,  ADJ_DATE VARCHAR
,  ADJ_D_CODE VARCHAR
,  ADJ_EPOCH VARCHAR
,  ADJ_RUNBY VARCHAR
, BEST_ADJ VARCHAR
, DOF VARCHAR
, MEASUREMENT_COUNT VARCHAR
, UNKNOWNS_COUNT VARCHAR 
, CHI_SQUARE VARCHAR
, SIGMA_ZERO VARCHAR
, LOWER_LIMIT VARCHAR
,  UPPER_LIMIT VARCHAR
,  CONFIDENCE_INTERVAL VARCHAR
,  ADJ_TYPE VARCHAR
 )
WITH( 
  OIDS=FALSE
);
ALTER TABLE scn.adjustment_temp
  OWNER TO dave;