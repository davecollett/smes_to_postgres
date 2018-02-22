# smes_to_postgres
This repository undertakes regular processing of Dynanet adjustment files and loads them into a postgres database, based around the SMES schema for the Office of Surveyor General, Victoria.

msr_parse_all.pl will check a PSQL database for the max id's for certain columns, then read through the DynaNet output, and transform the "E", "M", "H","D","G" measurements into CSV files for loading into the database (as DB access can't always be granted to users).

nadj2smes.py takes the output of a GDA2020 national adjustment, and converts to the data format for loading into mark_coordinates and mark_horizontal table. It requires some files to be extracted from SMES (such as the nine figure number to mark_id mapping, and an extract of the GDA94 coordinates). Where a mark is in the national adjustment it uses that coordinate, otherwise it uses a transformed coordinate via the distrtion grids.

Connection to a PostGIS database requires a database.ini file to be included in the base directory, this should be in the form:
...
[postgresql]
host=geodetic01
port=5433
database=geo
user=dave
password=dave
...

