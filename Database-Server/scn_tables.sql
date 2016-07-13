
  
  
CREATE TABLE scn.mark_status
(
  status CHAR(2) NOT NULL,
  status_txt character varying NOT NULL,
   CONSTRAINT pk_mark_status PRIMARY KEY (status)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.mark_status
  OWNER TO dave; 
  
  CREATE TABLE scn.adjustment_type
(
  adj_type CHAR(5) NOT NULL,
  adj_type_txt VARCHAR(50) NOT NULL,
   CONSTRAINT pk_adjustment_type PRIMARY KEY (adj_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.adjustment_type
  OWNER TO dave; 
  
  
    CREATE TABLE scn.datum
(
  D_CODE CHAR(5) NOT NULL 
, D_TYPE CHAR(1) NOT NULL 
, D_DESCRIPTION VARCHAR(50) NOT NULL 
,   CONSTRAINT pk_datum PRIMARY KEY (d_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.datum
  OWNER TO dave; 
  
  
    CREATE TABLE scn.h_class
(
  h_class CHAR(2) NOT NULL,
  h_class_txt character varying NOT NULL,
   CONSTRAINT pk_h_class PRIMARY KEY (h_class)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.h_class
  OWNER TO dave; 


    CREATE TABLE scn.h_order
(
  h_order CHAR(2) NOT NULL,
  h_order_txt character varying NOT NULL,
   CONSTRAINT pk_h_order PRIMARY KEY (h_order)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.h_order
  OWNER TO dave;     
  
      CREATE TABLE scn.h_tech
(
  h_tech CHAR(3) NOT NULL,
  h_tech_txt character varying NOT NULL,
   CONSTRAINT pk_h_tech PRIMARY KEY (h_tech)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.h_tech
  OWNER TO dave;     
  
    CREATE TABLE scn.v_class
(
  v_class CHAR(2) NOT NULL,
  v_class_txt character varying NOT NULL,
   CONSTRAINT pk_v_class PRIMARY KEY (v_class)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.v_class
  OWNER TO dave; 


    CREATE TABLE scn.v_order
(
  v_order CHAR(2) NOT NULL,
  v_order_txt character varying NOT NULL,
   CONSTRAINT pk_v_order PRIMARY KEY (v_order)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.v_order
  OWNER TO dave;     
  
      CREATE TABLE scn.v_tech
(
  v_tech CHAR(3) NOT NULL,
  v_tech_txt character varying NOT NULL,
   CONSTRAINT pk_v_tech PRIMARY KEY (v_tech)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.v_tech
  OWNER TO dave;       
  
  
      CREATE TABLE scn.msr_type
(
  m_type CHAR(2) NOT NULL,
  m_description character varying NOT NULL,
   CONSTRAINT pk_m_type PRIMARY KEY (m_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.msr_type
  OWNER TO dave;   
  
   CREATE TABLE scn.name_type
(
  name_type character varying NOT NULL,
  name_type_txt character varying NOT NULL,
   CONSTRAINT pk_name_type PRIMARY KEY (name_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.name_type
  OWNER TO dave;     
  
  
    CREATE TABLE scn.parish
(
  psh_code numeric(4) NOT NULL,
  psh_name character varying NOT NULL,
   CONSTRAINT pk_psh_code PRIMARY KEY (psh_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.parish
  OWNER TO dave;     
  
  
    
    CREATE TABLE scn.msr_category
(
  MSR_CAT CHAR(5) NOT NULL 
, MSR_CAT_TXT VARCHAR(50) 
   ,CONSTRAINT pk_msr_category PRIMARY KEY (msr_cat)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.msr_category
  OWNER TO dave;    

CREATE TABLE scn.msr_geodetic
(
  msr_id numeric(15,0) NOT NULL,
  msr_type character(2),
  msr_stations character varying(1),
  seq_id numeric(15,0),
  cluster_id numeric(15,0),
  adj_id numeric(15,0),
  ignore character varying(1),
  msr_category character(5),
  msr_comment_id numeric(10,0),
  msr_edit_comments character varying(512),
  CONSTRAINT pk_msr_geodetic PRIMARY KEY (msr_id),
  CONSTRAINT msr_geodetic_adj_id_fkey FOREIGN KEY (adj_id)
      REFERENCES scn.adjustment (adj_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT msr_geodetic_msr_category_fkey FOREIGN KEY (msr_category)
      REFERENCES scn.msr_category (msr_cat) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT msr_geodetic_msr_comment_id_fkey FOREIGN KEY (msr_comment_id)
      REFERENCES scn.msr_comments (msr_comment_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT msr_geodetic_msr_type_fkey FOREIGN KEY (msr_type)
      REFERENCES scn.msr_type (m_type) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scn.msr_geodetic
  OWNER TO dave;