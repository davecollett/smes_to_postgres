CREATE TABLE smes.mark_description
(
  MARK_ID NUMERIC(15, 0) NOT NULL 
, STATUS CHAR(2)
, BLOCK_NO CHAR(5) 
, LAST_SURVEYOR VARCHAR(30) 
, USED_DATE DATE 
, BEACON CHAR(1) 
, MAP_NUMBER CHAR(8) 
, SC_MAP CHAR(6) 
, TRIG CHAR(1) 
, PLAN_REF VARCHAR(500) 
, DATE_AMG_AVAIL DATE 
, DATE_MGA_AVAIL DATE 
,  CONSTRAINT pk_mark_description PRIMARY KEY (mark_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE smes.mark_description
  OWNER TO dave;
  
  
CREATE TABLE smes.adjustment 
(
  adj_id NUMERIC(15, 0) NOT NULL 
, adj_date DATE 
, ADJ_D_CODE character varying 
, ADJ_EPOCH DATE 
, ADJ_RUNBY character varying 
, BEST_ADJ CHAR(1) 
, DOF NUMERIC(15, 0) 
, MEASUREMENT_COUNT NUMERIC(15, 0) 
, UNKNOWNS_COUNT NUMERIC(15, 0) 
, CHI_SQUARE NUMERIC(15, 4) 
, SIGMA_ZERO NUMERIC(15, 4) 
, LOWER_LIMIT NUMERIC(15, 4) 
, UPPER_LIMIT NUMERIC(15, 4) 
, CONFIDENCE_INTERVAL NUMERIC(5, 2) 
, ADJ_TYPE CHAR(5) REFERENCES smes.adjustment_type  (adj_type)
, CONSTRAINT pk_adjustment PRIMARY KEY  ( ADJ_ID  ) )  
WITH( 
  OIDS=FALSE
);
ALTER TABLE smes.adjustment
  OWNER TO dave;
  
  
  CREATE TABLE smes.comments 
(
  COMMENTS_ID NUMERIC(15, 0) NOT NULL 
, MARK_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.mark_description (mark_id)
, USER_ID VARCHAR(30) NOT NULL 
, COM_DATE DATE 
, COMMENTS VARCHAR(1000) NOT NULL 
, CONSTRAINT pk_comments PRIMARY KEY  ( comments_id  ) )  
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.comments
  OWNER TO dave;
  
 
 CREATE TABLE smes.creation_dates 
(
  MARK_ID NUMERIC(15, 0) NOT NULL
, EARLIEST_DATE DATE 
, INSTALLED_BY VARCHAR(60) 
);
  ALTER TABLE smes.creation_dates
  OWNER TO dave;
  
  
  CREATE TABLE smes.mark_coordinates 
(
  MARK_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.mark_description (mark_id)
, MARK_COORD_ID NUMERIC(15, 0) NOT NULL 
, ADJ_ID NUMERIC(15, 0) 
, LATITUDE NUMERIC(15, 12) 
, LONGITUDE NUMERIC(15, 12) 
, EASTING NUMERIC(15, 5) 
, NORTHING NUMERIC(15, 5) 
, ZONE NUMERIC(2, 0) 
, DATUM_CODE CHAR(5) REFERENCES smes.datum (d_code)
, TECHNIQUE CHAR(3) 
, ORGANISATION VARCHAR(30) 
, DATE_SURV DATE 
, DATE_EDIT DATE 
, H_ORDER CHAR(2) 
, BEST_COORDS CHAR(1) 
, EASTING_PRECISION NUMERIC(1, 0) 
, NORTHING_PRECISION NUMERIC(1, 0) 
, LATITUDE_PRECISION NUMERIC(1, 0) 
, LONGITUDE_PRECISION NUMERIC(1, 0) 
, ELLIPSOID_HEIGHT VARCHAR(10) 
, POS_UNCERTAINTY VARCHAR(6) 
, CONSTRAINT pk_mark_coordinates PRIMARY KEY  ( MARK_COORD_ID  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_coordinates
  OWNER TO dave;
  
    CREATE TABLE smes.mark_horizontal 
(
 MARK_H_ID NUMERIC(15, 0) NOT NULL 
, MARK_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.mark_description (mark_id)
, H_D_CODE CHAR(5) REFERENCES smes.datum (d_code)
, H_CLASS CHAR(2) 
, H_ORDER CHAR(2) REFERENCES smes.h_order (h_order)
, H_TECHNIQUE CHAR(3) REFERENCES smes.h_tech (h_tech)
, H_ORGAN VARCHAR(30) 
, X_COORD VARCHAR(10) 
, Y_COORD VARCHAR(11) 
, ZONE CHAR(2) 
, H_DATE_SURV DATE 
, H_DATE_ADJ DATE 
, H_DATE_EDIT DATE 
, H_UNCERT VARCHAR(6) 
, CONSTRAINT pk_mark_horizontal_mark_h_id PRIMARY KEY  ( mark_h_id  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_horizontal
  OWNER TO dave;
  
  
  
    CREATE TABLE smes.mark_measurements 
(
MARK_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.mark_description (mark_id) 
, MSR_TYPES VARCHAR(200) 
, CONSTRAINT pk_mark_measurements_mark_id PRIMARY KEY  ( mark_id  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_measurements
  OWNER TO dave;  
  
  
     CREATE TABLE smes.mark_name 
(
  MARK_NAME_ID NUMERIC(15, 0) NOT NULL 
, MARK_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.mark_description (mark_id) 
, NINE_FIG CHAR(9) NOT NULL 
, MARK_NAME VARCHAR(30) NOT NULL 
, NAME_TYPE CHAR(1) NOT NULL REFERENCES smes.name_type (name_type)
, BEST_NAME CHAR(1)
, CONSTRAINT pk_mark_name_mark_name_id PRIMARY KEY  ( mark_name_id  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_name
  OWNER TO dave;   
  
  
  
       CREATE TABLE smes.mark_uncertainty 
(
  MARK_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.mark_description (mark_id) 
, ADJ_ID NUMERIC(9, 0) 
, XX NUMERIC(23, 20) 
, XY NUMERIC(23, 20) 
, XZ NUMERIC(23, 20) 
, YY NUMERIC(23, 20) 
, YZ NUMERIC(23, 20) 
, ZZ NUMERIC(23, 20) 
, CONSTRAINT pk_mark_uncertainty_mark_id PRIMARY KEY  ( mark_id  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_uncertainty
  OWNER TO dave;  
  
  
         CREATE TABLE smes.mark_vertical 
(
  MARK_V_ID NUMERIC(15, 0) NOT NULL 
, MARK_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.mark_description (mark_id) 
, V_D_CODE CHAR(5) NOT NULL REFERENCES smes.datum (d_code) 
, V_CLASS CHAR(2)  
, V_ORDER CHAR(2) REFERENCES smes.v_order (v_order) 
, Z_COORD VARCHAR(8) NOT NULL 
, V_TECHNIQUE CHAR(3) REFERENCES smes.v_tech (v_tech) 
, V_DATE_SURV DATE 
, V_DATE_ADJ DATE 
, V_DATE_EDIT DATE 
, V_ORGAN VARCHAR(30) 
, SEC CHAR(4) 
, BEST_VERT CHAR(1) 
, ADJ_ID NUMERIC(15, 0) 
, V_UNCERT VARCHAR(6)  
, CONSTRAINT pk_mark_vertical_mark_v_id PRIMARY KEY  ( mark_v_id  )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.mark_vertical
  OWNER TO dave;  
  
  
           CREATE TABLE smes.measurement_adj 
(
  MEASUREMENT_ADJ_ID NUMERIC(15, 0) NOT NULL 
, NETWORK_NAME VARCHAR(30) NOT NULL 
, DATUM VARCHAR(8) 
, REFTRAN VARCHAR(1) 
, SEGMENT VARCHAR(1) 
, GEOID VARCHAR(1) 
, MEASUREMENT_CATEGORY VARCHAR(80) NOT NULL 
, ADJUSTMENT_TYPE VARCHAR(10) NOT NULL 
, COMMENTS VARCHAR(1000) 
, STATUS VARCHAR(10) NOT NULL 
, USER_ID VARCHAR(50) NOT NULL 
, LAST_MODIFIED_DATE DATE NOT NULL 
, SOURCE VARCHAR(50) NOT NULL 
, PROJECT_NAME VARCHAR(100) 
, ADJUSTMENT_ID VARCHAR(15) 
, ADJUSTMENT_CATEGORY VARCHAR(20) 
, EPOCH DATE 
, FIRST_NAME VARCHAR(30) 
, LAST_NAME VARCHAR(30) 
, CONSTRAINT pk_measurement_adj_id PRIMARY KEY  ( measurement_adj_id )
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.measurement_adj
  OWNER TO dave;  
  
             CREATE TABLE smes.measurement_adj_files
(
  MEASUREMENT_ADJ_ID NUMERIC(15, 0) NOT NULL 
, NETWORK_NAME VARCHAR(30) NOT NULL 
, FILE_LOCATION VARCHAR(1000) NOT NULL
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.measurement_adj_files
  OWNER TO dave;  


CREATE TABLE smes.msr_comments
(
  MSR_COMMENT_ID NUMERIC(10, 0) NOT NULL 
, MSR_COMMENTS VARCHAR(512) 
, CONSTRAINT pk_msr_comment_id PRIMARY KEY  ( msr_comment_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_comments
  OWNER TO dave;     

 CREATE TABLE smes.msr_geodetic
(
  MSR_ID NUMERIC(15, 0) NOT NULL 
, MSR_TYPE CHAR(2)   REFERENCES smes.msr_type (m_type)
, MSR_STATIONS VARCHAR(1) 
, SEQ_ID NUMERIC(15, 0) 
, CLUSTER_ID NUMERIC(15, 0) 
, ADJ_ID NUMERIC(15, 0)   REFERENCES smes.adjustment (adj_id)
, IGNORE VARCHAR(1) 
, MSR_CATEGORY CHAR(5)  REFERENCES smes.msr_category (msr_cat)
, MSR_COMMENT_ID NUMERIC(10, 0)   REFERENCES smes.msr_comments (msr_comment_id)
, MSR_EDIT_COMMENTS VARCHAR(512) 
, CONSTRAINT pk_msr_geodetic PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_geodetic
  OWNER TO dave;    
  
CREATE TABLE smes.proj_comments
(
  PROJECT_ID NUMERIC(15, 0) NOT NULL 
, PROJECT_NAME VARCHAR(100) 
, PROJECT_COMMENTS VARCHAR(1000) 
, PROJECT_SOURCE VARCHAR(50) 
, CONSTRAINT pk_proj_comments PRIMARY KEY  ( project_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.proj_comments
  OWNER TO dave;  
  
  
CREATE TABLE smes.msr_project
(
  MSR_PROJECT_ID NUMERIC(15, 0) NOT NULL 
, PROJECT_ID NUMERIC(15, 0) REFERENCES smes.proj_comments (project_id)
, MSR_ID NUMERIC(15, 0) REFERENCES smes.msr_geodetic (msr_id)
, CONSTRAINT pk_msr_project PRIMARY KEY  ( msr_project_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_project
  OWNER TO dave;  
  
  
  
CREATE TABLE smes.msr_angle
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID_INSTR NUMERIC(15, 0) 
, MARK_ID_TARGET1 NUMERIC(15, 0) 
, MARK_ID_TARGET2 NUMERIC(15, 0) 
, ANGLE NUMERIC(15, 12) 
, STD_DEV NUMERIC(9, 6) 
, CONSTRAINT pk_msr_angle PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_angle
  OWNER TO dave;    
  
  
 
  
  
 CREATE TABLE smes.msr_coordinate
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id) 
, COORDINATE NUMERIC(15, 12) 
, STD_DEV NUMERIC(9, 6) 
, CONSTRAINT pk_msr_coordinate_id PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_coordinate
  OWNER TO dave;      


 CREATE TABLE smes.msr_direction
(
  MSR_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID_FROM NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id) 
, MARK_ID_TO NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id) 
, DIRECTION NUMERIC(15, 12) 
, STD_DEV NUMERIC(9, 6) 
, INSTRUMENT_HT NUMERIC(6, 3) 
, TARGET_HT NUMERIC(6, 3) 
, CONSTRAINT pk_msr_direction_id PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_direction
  OWNER TO dave;      
      
      
 CREATE TABLE smes.msr_direction_set
(
  MSR_ID NUMERIC(15, 0) NOT NULL  REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID_FROM NUMERIC(15, 0)  REFERENCES smes.mark_description (mark_id) 
, MARK_ID_TO NUMERIC(15, 0)  REFERENCES smes.mark_description (mark_id) 
, DIRECTION NUMERIC(15, 12) 
, STD_DEV NUMERIC(9, 6) 
, SET_COUNT NUMERIC(3, 0)  
, CONSTRAINT pk_msr_direction_set_id PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_direction_set
  OWNER TO dave;          



 CREATE TABLE smes.msr_distance
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID_FROM NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, MARK_ID_TO NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, DISTANCE NUMERIC(13, 5) 
, STD_DEV NUMERIC(8, 5) 
, INSTRUMENT_HT NUMERIC(5, 3) 
, TARGET_HT NUMERIC(5, 3) 
, CONSTRAINT pk_msr_distance_id PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_distance
  OWNER TO dave;          


 CREATE TABLE smes.msr_gnss_baseline
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID_FROM NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, MARK_ID_TO NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, VAR_COUNT NUMERIC(12, 0) 
, COVAR_COUNT NUMERIC(12, 0) 
, X NUMERIC(13, 5) 
, Y NUMERIC(13, 5) 
, Z NUMERIC(13, 5) 
, XX NUMERIC(23, 20) 
, XY NUMERIC(23, 20) 
, XZ NUMERIC(23, 20) 
, YY NUMERIC(23, 20) 
, YZ NUMERIC(23, 20) 
, ZZ NUMERIC(23, 20)
, CONSTRAINT pk_msr_gnss_baseline_id PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_gnss_baseline
  OWNER TO dave; 
      
 CREATE TABLE smes.msr_gnss_covariance
(
  GNSS_COV_ID NUMERIC(15, 0) NOT NULL 
, COV_ID NUMERIC(15, 0) 
, MSR_ID NUMERIC(15, 0) REFERENCES smes.msr_geodetic (msr_id)
, COV_1 NUMERIC(15, 0) 
, COV_2 NUMERIC(15, 0) 
, XX NUMERIC(23, 20) 
, XY NUMERIC(23, 20) 
, XZ NUMERIC(23, 20) 
, YX NUMERIC(23, 20) 
, YY NUMERIC(23, 20) 
, YZ NUMERIC(23, 20) 
, ZX NUMERIC(23, 20) 
, ZY NUMERIC(23, 20) 
, ZZ NUMERIC(23, 20) 
, CONSTRAINT pk_msr_gnss_cov_id PRIMARY KEY  ( gnss_cov_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_gnss_covariance
  OWNER TO dave; 
  
 CREATE TABLE smes.msr_gnss_datum
(
  CLUSTER_ID NUMERIC(15, 0) NOT NULL 
, D_CODE VARCHAR(8) 
, EPOCH DATE 
, CONSTRAINT pk_msr_gnss_datum PRIMARY KEY  ( cluster_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_gnss_datum
  OWNER TO dave;   
  
  
 CREATE TABLE smes.msr_gnss_point
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id)
, MARK_ID NUMERIC(15, 0)  REFERENCES smes.mark_description (mark_id)
, VAR_COUNT NUMERIC(12, 0) 
, COVAR_COUNT NUMERIC(12, 0) 
, X NUMERIC(13, 5) 
, Y NUMERIC(13, 5) 
, Z NUMERIC(13, 5) 
, XX NUMERIC(23, 20) 
, XY NUMERIC(23, 20) 
, XZ NUMERIC(23, 20) 
, YY NUMERIC(23, 20) 
, YZ NUMERIC(23, 20) 
, ZZ NUMERIC(23, 20) 
, CONSTRAINT pk_msr_gnss_point PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_gnss_point
  OWNER TO dave;     
  
  
   CREATE TABLE smes.msr_gnss_scaling
(
  CLUSTER_ID NUMERIC(15, 0) NOT NULL 
, VSCALE NUMERIC(12, 2) 
, PSCALE NUMERIC(12, 2) 
, LSCALE NUMERIC(12, 2) 
, HSCALE NUMERIC(12, 2)  
, CONSTRAINT pk_msr_gnss_scaling PRIMARY KEY  ( cluster_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_gnss_scaling
  OWNER TO dave; 
  
  
  
   CREATE TABLE smes.msr_height
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id) 
, MARK_ID NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, HEIGHT NUMERIC(10, 4) 
, STD_DEV NUMERIC(8, 5) 
, CONSTRAINT pk_msr_height PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_height
  OWNER TO dave;   
  
   CREATE TABLE smes.msr_height_difference
(
  MSR_ID NUMERIC(15, 0) NOT NULL REFERENCES smes.msr_geodetic (msr_id) 
, MARK_ID_FROM NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, MARK_ID_TO NUMERIC(15, 0) REFERENCES smes.mark_description (mark_id)
, HEIGHT_DIFFERENCE NUMERIC(10, 4) 
, STD_DEV NUMERIC(8, 5) 
, CONSTRAINT pk_msr_height_difference PRIMARY KEY  ( msr_id)
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.msr_height_difference
  OWNER TO dave;     
  
     CREATE TABLE smes.map_point
(
  MARK_ID NUMERIC(15, 0)  REFERENCES smes.mark_description (mark_id)
, MARK_H_ID NUMERIC(15, 0) 
, SYMBOL_TYPE_AMG VARCHAR(3) 
, SYMBOL_TYPE_MGA VARCHAR(3) 
, DISPLAY_NAME VARCHAR(30) 
, STATUS CHAR(2) 
) 
WITH( 
  OIDS=FALSE
);
  ALTER TABLE smes.map_point
  OWNER TO dave;     