#!/usr/bin/python
import psycopg2
from config import config

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        # create a cursor
        cur = conn.cursor()

 # execute a statement
        print('PostgreSQL database version:')
        cur.execute('SELECT version()')

        # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print(db_version)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')

def insert_mark_description(mark_desc_values):
    """ insert multiple vendors into the vendors table  """
    sql = "INSERT INTO nadj.mark_description( mark_id) VALUES(%s)"
    conn = None
    #print(mark_name_values)
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.executemany(sql,mark_desc_values)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()



def insert_mark_name(mark_name_values):
    """ insert multiple vendors into the vendors table  """
    sql = "INSERT INTO nadj.mark_name(mark_name_id, mark_id, mark_name, name_type) VALUES(%s, %s, %s, %s)"
    conn = None
    #print(mark_name_values)
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.executemany(sql,mark_name_values)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def insert_mark_horiz(mark_horiz_values):
    """ insert multiple vendors into the vendors table  """

    sql_insert = "INSERT INTO nadj.mark_horizontal(MARK_H_ID,MARK_ID,H_D_CODE,H_ORDER,H_TECHNIQUE,H_ORGAN,X_COORD,Y_COORD,ZONE,H_DATE_EDIT,H_DATE_ADJ,H_UNCERT) VALUES(%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s)"
    conn = None
    #print(mark_name_values)
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.executemany(sql_insert,mark_horiz_values)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()


def insert_mark_coord(mark_coord_values):
    """ insert multiple vendors into the vendors table  """

    sql_insert = "INSERT INTO nadj.mark_coordinates(MARK_COORD_ID,MARK_ID,LATITUDE,LONGITUDE,ELLIPSOID_HEIGHT,EASTING,NORTHING,ZONE,TECHNIQUE,ORGANISATION,DATE_EDIT,H_ORDER,BEST_COORDS,DATUM_CODE,ADJ_ID,POS_UNCERTAINTY) VALUES(%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s,%s, %s, %s, %s)"
    conn = None
    #print(mark_name_values)
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.executemany(sql_insert,mark_coord_values)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()



def create_db():
    """ insert multiple vendors into the vendors table  """

    sql_insert = "insert into nadj.name_type(NAME_TYPE,NAME_TYPE_TXT) VALUES ('P','Permanent Mark')"
    conn = None
    #print(mark_name_values)
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.execute(open("nadj_db_ddl.sql", "r").read())

        with open("DB Tables/Static/datum.csv", 'r') as f:
            # Notice that we don't need the `csv` module.
            next(f)  # Skip the header row.
            cur.copy_from(f, 'nadj.datum', sep=',', columns= ('D_TYPE','D_DESCRIPTION','D_CODE','VISIBLE','DEFAULT_DATUM'))

        with open("DB Tables/Static/name_type.csv", 'r') as f:
            # Notice that we don't need the `csv` module.
            next(f)  # Skip the header row.
            cur.copy_from(f, 'nadj.name_type', sep=',')

        with open("DB Tables/Static/h_order.csv", 'r') as f:
            # Notice that we don't need the `csv` module.
            next(f)  # Skip the header row.
            cur.copy_from(f, 'nadj.h_order', sep=',', columns=('H_ORDER','H_ORDER_TXT'))

        with open("DB Tables/Static/h_tech.csv", 'r') as f:
            # Notice that we don't need the `csv` module.
            next(f)  # Skip the header row.
            cur.copy_from(f, 'nadj.h_tech', sep=',', columns=('H_TECH','H_TECH_TXT'))


        cur.execute(sql_insert)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

