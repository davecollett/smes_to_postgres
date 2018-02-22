import csv
import pandas as pd
from australian_ntv2_grid_conversion import australian_ntv2_grid_conversion
from math import *
from collections import namedtuple
import datetime

print(datetime.datetime.now())

#DMS = namedtuple('DMS', 'degrees minutes seconds')
def decdeg2dms(dd):
    """ Converts a decimal degree value of the for -37.4568 into a DMS namedtuple type with degrees, minutes, seconds.
    :param dd: float
    :return: namedtuple DMS
    """
    negative = dd < 0
    dd = abs(dd)
    minutes, seconds = divmod(dd*3600, 60)
    degrees, minutes = divmod(minutes, 60)
    if negative:
        if degrees > 0:
            degrees = -degrees
        elif minutes > 0:
            minutes = -minutes
        else:
            seconds = -seconds
    #degrees
    #hp = str(trunc(degrees))+'.'+ str("{0:.0f}".format(minutes).zfill(2))+ str(trunc(seconds*1000000000))
    hp = str(trunc(degrees))+'.'+ str("{0:.0f}".format(minutes).zfill(2))+ str("{0:.0f}".format(trunc(seconds*1000000000)).zfill(11))
    hp_final = "{0:.9f}".format(float(hp))
    #print(hp_final)
    return hp_final


#Set the grid
ntv2 = australian_ntv2_grid_conversion.Ntv2()
ntv2.set_ntv2_file('National_DC_V5.gsb')

# Define the input files
file_xyz = r"gda2020v1.3_2017.208/gda2020_2017.208.phased-stage.xyz"
file_apu = r"gda2020v1.3_2017.208/gda2020_2017.208.phased-stage.apu"
df_nf=pd.read_csv('nf_mark_id_cors.csv', sep=',',header=0,dtype={'"MARK_ID"':'S10'}, converters={'NINE_FIG':str})

#SQL: select mark_id, latitude, longitude, easting,northing,zone, h_order from mark_coordinates where best_coords = 'X' AND datum_code = 'GDA94' order by mark_id asc;
df_smes=pd.read_csv('mark_coords_llenz_gda94_prod_171129.csv', sep=',',header=0,dtype={'"MARK_ID"':'S10'}, converters={'EASTING':str})

#print(df_smes)

#Define the columns
fieldwidths_xyz = (20,8,14,14,6,14,15,11,11,45,12,10,10,30)
fieldwidths_apu = (20,16,16,10,11,100)

#Define the inputs
df_xyz = pd.read_fwf(file_xyz, widths = fieldwidths_xyz, names = ['mark_name', 'const','easting','northing', 'zone','latitude', 'longitude', 'ahd','ellip', 'cartesian', 'sde','sdn','sdu', 'col2'], header =19 )
df_apu = pd.read_fwf(file_apu, widths = fieldwidths_apu, names = ['mark_name', 'latitude', 'longitude', 'hz_posu', 'v_posu', 'col2'], header =20 )

#Set the starting values - the first two could be grabbed from SMES
mrk_crd_id = 303006
mrk_h_id = 426562
h_date_edit = "01/12/2017"
h_date_adj = "27/08/2017"
h_d_code = "GDA2020"
adj_id = "26"

#Remove the lines with just the variances
df_apu = df_apu[df_apu.mark_name.notnull()]


df_new = pd.merge(df_xyz, df_apu, on='mark_name')

#Bring in the mark_id's via nine_dig
df_full = pd.merge(df_new, df_nf, how='inner', left_on='mark_name', right_on='NINE_FIG')

#with open('mark_horizontal_names.csv', 'w') as csv_gda2020_mh:
#with open('mark_coordinates_gda2020_id.csv', 'w') as csv_mrk_crd, open('mark_horizontal_gda2020_id.csv', 'w') as csv_mrk_hz:
with open('mark_coordinates_gda2020_prod_180220.csv', 'w') as csv_mrk_crd, open('mark_horizontal_gda2020_prod_180220.csv', 'w') as csv_mrk_hz:
	  #here are the headers:
    mrk_horiz_fieldnames = ['MARK_H_ID','MARK_ID','H_D_CODE','H_ORDER','H_TECHNIQUE','H_ORGAN','X_COORD','Y_COORD','ZONE','H_DATE_EDIT','H_DATE_ADJ','H_UNCERT']
    mrk_crd_fieldnames = ['MARK_COORD_ID','MARK_ID', 'LATITUDE', 'LONGITUDE', 'ELLIPSOID_HEIGHT', 'EASTING', 'NORTHING', 'ZONE', 'TECHNIQUE', 'ORGANISATION', 'DATE_EDIT', 'H_ORDER', 'BEST_COORDS', 'DATUM_CODE', 'ADJ_ID', 'POS_UNCERTAINTY']


    #mrk_horiz_fieldnames = ['MARK_H_ID','MARK_ID', 'H_ORDER', 'H_TECHNIQUE', 'H_ORGAN', 'X_COORD', 'Y_COORD', 'ZONE',  'H_DATE_EDIT', 'H_DATUM_CODE']

    #here we set up the csv
    #writer_mrk_hz1 = csv.writer(csv_gda2020_mh,  delimiter=',')
    writer_mrk_crd = csv.writer(csv_mrk_crd,  delimiter=',')
    writer_mrk_hz = csv.writer(csv_mrk_hz,  delimiter=',')
    #write the headers to the file
    writer_mrk_crd.writerow(mrk_crd_fieldnames)
    writer_mrk_hz.writerow(mrk_horiz_fieldnames)

    #writer_mrk_hz1.writerow(mrk_adj_horiz_fieldnames)


    #now do things with each row of the input
    for  row in df_full.itertuples():
     #mark_id = row[1]
     #z_coord = row[3]
     #v_uncert = round(1.96*row[5],3)
     #print(row)
     zone_rnd = "{0:.0f}".format(row.zone)

     #This is where we prepare what to write out
     towrite_mrk_hz = [mrk_h_id, row.MARK_ID,  h_d_code,'3', 'ADJ','OSGV', "{0:.3f}".format(row.easting), "{0:.3f}".format(row.northing),zone_rnd, h_date_edit, h_date_adj,"{0:.3f}".format(row.hz_posu)]
     towrite_mrk_crd = [mrk_crd_id, row.MARK_ID, "{0:.9f}".format(row.latitude_x) , "{0:.9f}".format(row.longitude_x), "{0:.3f}".format(row.ellip), "{0:.3f}".format(row.easting) , "{0:.3f}".format(row.northing) , zone_rnd, 'ADJ', 'OSGV', h_date_edit, '3', 'X', 'GDA2020', adj_id,"{0:.3f}".format(row.hz_posu) ]
     #print(towrite_mrk_crd)

     writer_mrk_hz.writerow(towrite_mrk_hz)
     writer_mrk_crd.writerow(towrite_mrk_crd)
     mrk_crd_id += 1
     mrk_h_id += 1

    for row in df_smes.itertuples():
        ## IGNORE gda/agd references - basically telling it to do a forward transformation
        #convert the MGA94 values to GDA94 dd

        test1 = ((df_full['MARK_ID']==row.MARK_ID)).any()

        if not test1:
            #print('TRUE!')

        #else:
        #    either_true = False

            #print(row.MARK_ID)
            gda94_dd = ntv2.grid_to_latlon(float(row.EASTING) ,row.NORTHING, row.ZONE, 'gda94', 'gda94')
            gda2020_grid = ntv2.latlon_to_grid(gda94_dd['latitude'],gda94_dd['longitude'], 'agd66', 'gda94' )
            gda2020_dd = ntv2.latlon_to_latlon(gda94_dd['latitude'],gda94_dd['longitude'], 'agd66', 'gda94' )
            gda2020_hp_lat = decdeg2dms(gda2020_dd['latitude'])
            gda2020_hp_lon = decdeg2dms(gda2020_dd['longitude'])

            #print(row.EASTING)
            input_dp = len(row.EASTING.partition('.')[2])

            if input_dp > 3:
                input_dp = 3

            #print(len(east_dp))
            formatting = "{0:."+str(input_dp)+"f}"
            #print(formatting)

            if row.H_ORDER == 99:
                tf_tech = 99
            elif row.H_ORDER == 5:
                tf_tech = 5
            elif row.H_ORDER == 4:
                tf_tech = 4
            elif row.H_ORDER == 3:
                tf_tech = 4
            elif row.H_ORDER == 2:
                tf_tech = 4
            elif row.H_ORDER == 1:
                tf_tech = 4
            else:
                tf_tech = 99

            #form the row to write to the files
            towrite_mrk_crd = [mrk_crd_id, row.MARK_ID, gda2020_hp_lat,gda2020_hp_lon,'',  formatting.format(gda2020_grid['easting']) , formatting.format(gda2020_grid['northing']) , gda2020_grid['zone'], 'TF', 'OSG', h_date_edit, tf_tech, 'X', 'GDA2020', '', '']
            #print(towrite_mrk_crd)
            towrite_mrk_hz = [mrk_h_id, row.MARK_ID, 'GDA2020', tf_tech, 'TF', 'OSGV', formatting.format(gda2020_grid['easting']) , formatting.format(gda2020_grid['northing']) , gda2020_grid['zone'], h_date_edit, '', '']
            #print(towrite_mrk_hz)


            #print(test1)
            #write it out
            writer_mrk_crd.writerow(towrite_mrk_crd)
            writer_mrk_hz.writerow(towrite_mrk_hz)
            #print(decdeg2dms(gda94_dd['latitude']))
            mrk_crd_id += 1
            mrk_h_id += 1

print(datetime.datetime.now())
