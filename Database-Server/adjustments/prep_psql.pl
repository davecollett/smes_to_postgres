#!/usr/bin/perl
use strict;
use Time::Local;
use DBI;


#Connect to Database
my $driver   = "Pg";
my $database = "geo";
my $dsn = "DBI:$driver:dbname=$database;host=localhost;port=5433";
my $userid = "dave";
my $password = "xxxxxxx";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 ,AutoCommit => 0})
                      or die $DBI::errstr;

print "Opened database successfully\n";
my $stmt = qq(CREATE TABLE IF NOT EXISTS "SCN".uncert
			(nine_fig CHAR(9) NOT NULL,
			pos_uncertainty TEXT,
			xx NUMERIC(23, 20),
			xy NUMERIC(23, 20),
			xz NUMERIC(23, 20),
			yy NUMERIC(23, 20),
			yz NUMERIC(23, 20),
			zz NUMERIC(23, 20),
			v_uncertainty VARCHAR(6));
			);

my $stmt_coord = qq(CREATE TABLE IF NOT EXISTS "SCN".coord
			(nine_fig CHAR(9) NOT NULL,
			latitude NUMERIC(15, 12),
			longitude NUMERIC(15, 12),
			ellipsoid_height VARCHAR(10),
			ahd_height VARCHAR(8),
			easting NUMERIC(15, 5),
			northing NUMERIC(15, 5),
			zone NUMERIC(2, 0));
			);

my $stmt_meas = qq(CREATE TABLE IF NOT EXISTS "SCN".measurements
			(nine_fig CHAR(9) NOT NULL,
			msr_types	VARCHAR(200));
			);

my $rv = $dbh->do($stmt);
if($rv < 0){
   print $DBI::errstr;
} else {
   print "uncert Table created successfully\n";
}
my $rv2 = $dbh->do($stmt_coord);
if($rv2 < 0){
   print $DBI::errstr;
} else {
   print "coords Table created successfully\n";
}
my $rv3 = $dbh->do($stmt_meas);
if($rv3 < 0){
   print $DBI::errstr;
} else {
   print "meas Table created successfully\n";
}

 $dbh->commit();


