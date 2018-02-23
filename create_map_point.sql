drop table nadj.temp_geom;

create  table nadj.map_point as (
select --*,
    mark_id, mark_h_id,
--ST_MakePoint(x_coord::double precision, y_coord::double precision) as no_crs ,
st_transform(ST_SetSRID(ST_MakePoint(x_coord::double precision, y_coord::double precision), (concat('283',zone))::integer) ,4283 ) as shape
--,concat('78',zone)::double precision as shape
from nadj.mark_horizontal
)
;
ALTER TABLE nadj.map_point ADD COLUMN geom geometry(POINT,4283);
insert into  nadj.map_point (mark_id, mark_h_id, geom)  (
select --*,
    mark_id, mark_h_id,
--ST_MakePoint(x_coord::double precision, y_coord::double precision) as no_crs ,
st_transform(ST_SetSRID(ST_MakePoint(x_coord::double precision, y_coord::double precision), (concat('283',zone))::integer) ,4283 ) as geom
--,concat('78',zone)::double precision as shape
from nadj.mark_horizontal
);
CREATE INDEX map_point_gix ON nadj.map_point USING GIST (geom);

--select distinct  zone, concat('78',zone) as epsg from nadj.mark_horizontal order by zone;

SELECT PostGIS_Full_Version();

update

INSERT INTO "spatial_ref_sys" ("srid","auth_name","auth_srid","srtext","proj4text") VALUES (28347,'EPSG',28347,'PROJCS["GDA94 / MGA zone 47",GEOGCS["GDA94",DATUM["Geocentric_Datum_of_Australia_1994",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6283"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4283"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",99],PARAMETER["scale_factor",0.9996],PARAMETER["false_easting",500000],PARAMETER["false_northing",10000000],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AXIS["Easting",EAST],AXIS["Northing",NORTH],AUTHORITY["EPSG","6737"]]','+proj=utm +zone=47 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ');

