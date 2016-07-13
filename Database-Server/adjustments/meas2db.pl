use strict;
#use warnings;
use IO::Handle;
use DBI;


#Connect to Database		
my $driver   = "Pg"; 
my $database = "geo";
my $dsn = "DBI:$driver:dbname=$database;host=localhost;port=5433";
my $userid = "dave";
my $password = "dave";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 ,AutoCommit => 0}) 
                      or die $DBI::errstr;
					  
print "Opened database successfully\n";

my $fh;
my $adjustment = $ARGV[0];
my $source = $ARGV[0].".phased-mt.adj";
my $measure_count;
my $ADJ; my $OUT;
my $measure_count_format = "A20, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A8, A*"; 
my $line;


#open(ADJ, "<$source") || die "Cannot open log file $ADJ\n";
open(OUTTEMP, ">meas_out.txt") || die "Can't open output script for writing$!\n";
print "$source\n";
#Open SNX file and pull out estimates
{
local $/ = undef;
open my $fh, '<', $source or die;
while (<$fh> =~ m/Measurements to Station \n-+\n\n([\s\S]*?)-+\nTotals/sm) {
#print "$1";
$measure_count = $1;
}
}
print OUTTEMP $measure_count;
close OUTTEMP;

open(INTEMP, "<meas_out.txt") || die "Can't open output script for writing$!\n";
open(OUTPROC, ">meas_out2.txt") || die "Can't open output script for writing$!\n";
while ( <INTEMP> ) {
 #my $line = chomp $_ ;
next if $_ =~ /Station|-+/;
    my @measurement_fields = unpack( 'A20A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A*', $_ );

print OUTPROC $measurement_fields[0],",";

	
	if ( $measurement_fields[1] =~ /\S/) {	print OUTPROC "A";	}
	if ( $measurement_fields[2] =~ /\S/) {	print OUTPROC "B";	}	
	if ( $measurement_fields[3] =~ /\S/) {	print OUTPROC "C";	}	
	if ( $measurement_fields[4] =~ /\S/) {	print OUTPROC "D";	}	
	if ( $measurement_fields[5] =~ /\S/) {	print OUTPROC "E";	}	
	if ( $measurement_fields[6] =~ /\S/) {	print OUTPROC "G";	}	
	if ( $measurement_fields[7] =~ /\S/) {	print OUTPROC "H";	}	
	if ( $measurement_fields[8] =~ /\S/) {	print OUTPROC "I";	}	
	if ( $measurement_fields[9] =~ /\S/) {	print OUTPROC "J";	}	
	if ( $measurement_fields[10] =~ /\S/) {	print OUTPROC "K";	}	
	if ( $measurement_fields[11] =~ /\S/) {	print OUTPROC "L";	}	
	if ( $measurement_fields[12] =~ /\S/) {	print OUTPROC "M";	}	
	if ( $measurement_fields[13] =~ /\S/) {	print OUTPROC "P";	}	
	if ( $measurement_fields[14] =~ /\S/) {	print OUTPROC "Q";	}	
	if ( $measurement_fields[15] =~ /\S/) {	print OUTPROC "R";	}	
	if ( $measurement_fields[16] =~ /\S/) {	print OUTPROC "S";	}	
	if ( $measurement_fields[17] =~ /\S/) {	print OUTPROC "V";	}	
	if ( $measurement_fields[18] =~ /\S/) {	print OUTPROC "X";	}	
	if ( $measurement_fields[19] =~ /\S/) {	print OUTPROC "Y";	}	
	if ( $measurement_fields[20] =~ /\S/) {	print OUTPROC "Z";	}	
	
	print OUTPROC "\n";
	
}
close OUTPROC;
close INTEMP;
open(OUTPROC2, "<meas_out2.txt") || die "Can't open output script for writing$!\n";
my $nine_fig, my $msr_types;

while (<OUTPROC2>) {
($nine_fig, $msr_types) = split (/,/,$_);
chomp $msr_types;
$dbh->do('INSERT INTO "scn"."measurements" (nine_fig, msr_types, adjustment) VALUES (?,?,?)',
			undef,
			($nine_fig,$msr_types,$adjustment));
 };
 close OUTPROC2;
 $dbh->commit();
  print "Measurements written to database successfully\n";



