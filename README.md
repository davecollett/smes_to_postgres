# smes_to_postgres
This repository undertakes regular processing of Dynanet adjustment files and loads them into a postgres database, based around the SMES schema for the Office of Surveyor General, Victoria.

msr_parse_all.pl will check a PSQL database for the max id's for certain columns, then read through the DynaNet output, and transform the "E", "M", "H","D","G" measurements into CSV files for loading into the database (as DB access can't always be granted to users).
