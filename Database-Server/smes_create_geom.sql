ALTER TABLE smes.map_point ADD COLUMN geom geometry(POINT,4283);

With new_values as ( select mp.mark_id, ST_Transform(ST_GeomFromText('POINT(' || easting || ' ' || northing || ')',28354),4283) geom
from 	smes.map_point mp , 
	smes.mark_coordinates mc 
where mp.mark_id = mc.mark_id AND best_coords = 'X'  AND mc.zone = '54')
update smes.map_point as mp
set geom = nv.geom
from new_values nv
where nv.mark_id = mp.mark_id;


With new_values as ( select mp.mark_id, ST_Transform(ST_GeomFromText('POINT(' || easting || ' ' || northing || ')',28355),4283) geom
from 	smes.map_point mp , 
	smes.mark_coordinates mc 
where mp.mark_id = mc.mark_id AND best_coords = 'X'  AND mc.zone = '55')
update smes.map_point as mp
set geom = nv.geom
from new_values nv
where nv.mark_id = mp.mark_id;

CREATE INDEX map_point_gix ON smes.map_point USING GIST (geom);