import csv
import pandas as pd
#from australian_ntv2_grid_conversion import australian_ntv2_grid_conversion
from math import *
from collections import namedtuple
import datetime
import psycopg2
from config import config
import db_connect

print(datetime.datetime.now())

# Define the input files
file_xyz = r"gda2020v1.3_2017.208/gda2020_2017.208.phased-stage.xyz"
file_apu = r"gda2020v1.3_2017.208/gda2020_2017.208.phased-stage.apu"

#Define the columns
fieldwidths_xyz = (20,8,14,14,6,14,15,11,11,45,12,10,10,30)
fieldwidths_apu = (20,16,16,10,11,100)

#Define the inputs
df_xyz = pd.read_fwf(file_xyz, widths = fieldwidths_xyz, names = ['mark_name', 'const','easting','northing', 'zone','latitude', 'longitude', 'ahd','ellip', 'cartesian', 'sde','sdn','sdu', 'col2'], header =19 )
df_apu = pd.read_fwf(file_apu, widths = fieldwidths_apu, names = ['mark_name', 'latitude', 'longitude', 'hz_posu', 'v_posu', 'col2'], header =20 )

#Set the starting values - the first two could be grabbed from SMES
mrk_crd_id = 1
mrk_h_id = 1
mark_name_id = 1
mark_id = 1
h_date_edit = "01/12/2017"
h_date_adj = "27/08/2017"
h_d_code = "GDA2020"
adj_id = "17208"

#Remove the lines with just the variances
df_apu = df_apu[df_apu.mark_name.notnull()]


df_new = pd.merge(df_xyz, df_apu, on='mark_name')
#print(df_new)

db_connect.create_db()

#Bring in the mark_id's via nine_fig
#df_full = pd.merge(df_new, df_nf, how='inner', left_on='mark_name', right_on='NINE_FIG')
todb_mrk_desc2 = []
todb_mrk_name2 = []
todb_mrk_horiz2 = []
todb_mrk_coord2 = []
#with open('mark_horizontal_names.csv', 'w') as csv_gda2020_mh:
#with open('mark_coordinates_gda2020_id.csv', 'w') as csv_mrk_crd, open('mark_horizontal_gda2020_id.csv', 'w') as csv_mrk_hz:
with open('mark_coordinates_gda2020.csv', 'w' , newline='') as csv_mrk_crd, open('mark_horizontal_gda2020.csv', 'w' , newline='') as csv_mrk_hz, open('mark_name.csv', 'w' , newline='') as csv_mrk_name, open('mark_description.csv', 'w' , newline='') as csv_mrk_desc:
	  #here are the headers:
    mrk_horiz_fieldnames = ['MARK_H_ID','MARK_ID','H_D_CODE','H_ORDER','H_TECHNIQUE','H_ORGAN','X_COORD','Y_COORD','ZONE','H_DATE_EDIT','H_DATE_ADJ','H_UNCERT']
    mrk_crd_fieldnames = ['MARK_COORD_ID','MARK_ID', 'LATITUDE', 'LONGITUDE', 'ELLIPSOID_HEIGHT', 'EASTING', 'NORTHING', 'ZONE', 'TECHNIQUE', 'ORGANISATION', 'DATE_EDIT', 'H_ORDER', 'BEST_COORDS', 'DATUM_CODE', 'ADJ_ID', 'POS_UNCERTAINTY']
    mrk_name_fieldnames = ['MARK_NAME_ID', 'MARK_ID', 'MARK_NAME', 'NAME_TYPE']
    mrk_desc_fieldnames = ['MARK_ID']

    #mrk_horiz_fieldnames = ['MARK_H_ID','MARK_ID', 'H_ORDER', 'H_TECHNIQUE', 'H_ORGAN', 'X_COORD', 'Y_COORD', 'ZONE',  'H_DATE_EDIT', 'H_DATUM_CODE']

    #here we set up the csv
    #writer_mrk_hz1 = csv.writer(csv_gda2020_mh,  delimiter=',')
    writer_mrk_crd = csv.writer(csv_mrk_crd,  delimiter=',')
    writer_mrk_hz = csv.writer(csv_mrk_hz,  delimiter=',')
    writer_mrk_name = csv.writer(csv_mrk_name,  delimiter=',')
    writer_mrk_desc = csv.writer(csv_mrk_desc,  delimiter=',')


    #write the headers to the file
    #writer_mrk_crd.writerow(mrk_crd_fieldnames)
    #writer_mrk_hz.writerow(mrk_horiz_fieldnames)
    #writer_mrk_name.writerow(mrk_name_fieldnames)
    #writer_mrk_desc.writerow(mrk_desc_fieldnames)

    #writer_mrk_hz1.writerow(mrk_adj_horiz_fieldnames)


    #now do things with each row of the input
    for  row in df_new.itertuples():
     zone_rnd = "{0:.0f}".format(row.zone)

     #This is where we prepare what to write out
     #towrite_mrk_hz = [mrk_h_id, mark_id,  h_d_code,'3', 'ADJ','ORG', "{0:.3f}".format(row.easting), "{0:.3f}".format(row.northing),zone_rnd, h_date_edit, h_date_adj,"{0:.3f}".format(row.hz_posu)]
     #towrite_mrk_crd = [mrk_crd_id, mark_id, "{0:.9f}".format(row.latitude_x) , "{0:.9f}".format(row.longitude_x), "{0:.3f}".format(row.ellip), "{0:.3f}".format(row.easting) , "{0:.3f}".format(row.northing) , zone_rnd, 'ADJ', 'OSGV', h_date_edit, '3', 'X', 'GDA2020', adj_id,"{0:.3f}".format(row.hz_posu) ]
     #towrite_mrk_name = [mark_name_id, mark_id, row.mark_name,'P']
     #towrite_mrk_desc = [mark_id]

     todb_mrk_desc = (mark_id,)
     todb_mrk_name = (str(mark_name_id), str(mark_id), str(row.mark_name),'P',)
     todb_mrk_horiz = (mrk_h_id, mark_id,  h_d_code,'3', 'ADJ','ORG', "{0:.3f}".format(row.easting), "{0:.3f}".format(row.northing),zone_rnd, h_date_edit, h_date_adj,"{0:.3f}".format(row.hz_posu),)
     todb_mrk_coord = (mrk_crd_id, mark_id, "{0:.9f}".format(row.latitude_x) , "{0:.9f}".format(row.longitude_x), "{0:.3f}".format(row.ellip), "{0:.3f}".format(row.easting) , "{0:.3f}".format(row.northing) , zone_rnd, 'ADJ', 'OSGV', h_date_edit, '3', 'X', 'GDA2020', adj_id,"{0:.3f}".format(row.hz_posu))

     todb_mrk_desc2.append(todb_mrk_desc,)
     todb_mrk_name2.append(todb_mrk_name,)
     todb_mrk_horiz2.append(todb_mrk_horiz,)
     todb_mrk_coord2.append(todb_mrk_coord,)
     #print(todb_mrk_name)
     #db_connect.insert_mark_name(todb_mrk_name)

     #print(towrite_mrk_crd)

     #writer_mrk_hz.writerow(towrite_mrk_hz)
     #writer_mrk_crd.writerow(towrite_mrk_crd)
     #writer_mrk_name.writerow(towrite_mrk_name)
     #writer_mrk_desc.writerow(towrite_mrk_desc)


     mrk_crd_id += 1
     mrk_h_id += 1
     mark_id += 1
     mark_name_id += 1
#print(todb_mrk_name2)
db_connect.insert_mark_description(todb_mrk_desc2)
db_connect.insert_mark_name(todb_mrk_name2)
db_connect.insert_mark_horiz(todb_mrk_horiz2)
db_connect.insert_mark_coord(todb_mrk_coord2)

#db_connect.commit()
print(datetime.datetime.now())
