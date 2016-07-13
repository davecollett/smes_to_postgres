#use strict;
#use warnings;
use IO::Handle;
use DBI;
use XML::Simple;
use Data::Dumper;







my $cluster_id = 12;
my $msr_id = 111;
my $comment_id = 3;
my $msr_proj_id = 111;
my $proj_id = 5;
my $adj_id = 5;


#my $file = $ARGV[0];
#my $filetype = $ARGV[1];
#Parse and prepare filenames
my $adjustment = $ARGV[0];
my $file = $ARGV[0]."msr.xml";
my $adj_output = $ARGV[0]."-FULL.phased-mt.adj";

# create object
$xml = new XML::Simple;
my $close = "</DnaMeasurement>";
 
my $MEAS;
 
 
#Connect to Database		
my $driver   = "Pg"; 
my $database = "geo";
my $dsn = "DBI:$driver:dbname=$database;host=10.192.241.33;port=5433";
my $userid = "dave";
my $password = "dave";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 ,AutoCommit => 0}) 
                      or die $DBI::errstr; 
print "Opened database successfully\n";
 
my $sql = qq/select max(cluster_id) as cluster_id, max(msr_id) as msr_id , max(msr_comment_id) as comment_id, max(adj_id) as adj_id from scn.msr_geodetic/;      # the query to execute
my $sth = $dbh->prepare($sql);          # prepare the query
$sth->execute();                        # execute the query
 $dbh->commit();
my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row
      $cluster_id = @row[0]+1;
     $msr_id = @row[1]+1;
  $comment_id = @row[2]+1;
  $adj_id = @row[3]+1;
  $proj_id = $adj_id;
  $msr_proj_id = $msr_id;
}
 print "MSR_ID : $msr_id\n";
  print "Cluster ID : $cluster_id \n";
  print "Comment : $comment_id\n";
  print "ADJ ID : $adj_id \n"; 
  print "Project ID : $proj_id \n";
 
 
#open(OUTTEMP, ">$filetype-$file") || die "Can't open output script for writing$!\n";
#open(OUTCSV, ">$filetype.csv") || die "Can't open output script for writing$!\n";
#print OUTTEMP "test";

open(ADJUSTMENT, ">>adjustment.csv") || die "Can't open adjustment for writing!\n";

open(ADJ_MSR_CONV, ">adj_msr_conv.csv") || die "Can't open input $adj_output!\n";

open(ADJ_MSR_GNSS, ">adj_msr_gnss.csv") || die "Can't open input $adj_output!\n";


#print ADJUSTMENT "adj_id, adj_date,adj_d_code, adj_epoch, adj_runby, best_adj, dof, measurement_count, unknowns_count, chi_square, sigma_zero, lower_limit, upper_limit, confidence_interval, adj_type\n";

#Process ADJ FILE
{		local $/ = undef;
open(ADJ, "<$adj_output") || die "Can't open input $adj_output!\n";
	while (<ADJ>) {
	my @adj_d_code = $_ =~  m/Reference frame:                   (.*)/ ;
#my @adj_date = $_ =~ m/File created                       (.*)/;
	my @dof = $_ =~  m/Degrees of freedom                 (\d*)/ ;
	my @measurement_count = $_ =~  m/Number of measurements             (\d*)/ ;
	my @unknowns_count = $_ =~  m/Number of unknown parameters       (\d*)/ ;
	my @chi_square = $_ =~  m/Chi squared                        (.*)/ ;
	my @sigma_limits = $_ =~  m/Chi-Square test \((\d*\.\d*)%\)\s*(\d*\.\d*)\s*<\s*(\d*\.\d*)\s*<\s*(\d*\.\d*)/ ;	
	my @adj_date =$_ =~ m/File created                       \w*,\s*(\d*)\s*(\w*)\w\s*\d\d(\d*),/;
print ADJUSTMENT "$adj_id,@adj_date[0]/@adj_date[1]/@adj_date[2],@adj_d_code[0],01/JAN/94,dailyrun,,$dof[0],$measurement_count[0],$unknowns_count[0],$chi_square[0],$sigma_limits[2],$sigma_limits[1],$sigma_limits[3],$sigma_limits[0],JGA\n";
}}


my $vectornumber = 1;
print ADJ_MSR_GNSS "adj_id,type,from_nine_fig,to_nine_fig,vectornumber,measured,correction,meas_sd,nstat\n";
my $d_from_id;

print ADJ_MSR_CONV "adj_id,type,from_nine_fig,to_nine_fig,measured,correction,meas_sd,nstat\n";
my $adjusted_measurements;
{		local $/ = undef;
open(ADJ, "<$adj_output") || die "Can't open input $adj_output!\n";
	while (<ADJ> =~ m/Adjusted Measurements\n-+\n\n.+\n-+\n([\s\S]*)\n\nMeasurements to Station/sm)  {
$adjusted_measurements = $1;}}
 open my $fh, '<', \$adjusted_measurements or die $!;
while (<$fh>) {
	my @m_array = $_  =~ /(.)\s*(\w*)\s*(\w*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)\s*(\S*)/;
#print @m_array;
#print $m_array[0];
if ($m_array[0] eq "M" || $m_array[0] eq "E" ) {	
print ADJ_MSR_CONV "$adj_id,$m_array[0],$m_array[1],$m_array[2],$m_array[3],@m_array[5],@m_array[7],@m_array[9]\n";
}
elsif ($m_array[0] eq "G") {	
	print ADJ_MSR_GNSS "$adj_id,$m_array[0]$m_array[3],$m_array[1],$m_array[2],$vectornumber,$m_array[4],@m_array[6],@m_array[8],@m_array[10]\n";
 if ($m_array[3] eq "Z") {$vectornumber++ }
}
elsif ($m_array[0] eq "D") {	
	$d_from_id = $m_array[1];
}
elsif ($m_array[0] eq " ") {	
print ADJ_MSR_CONV "$adj_id,D,$d_from_id,$m_array[1],$m_array[2].$m_array[3]".(100*$m_array[4]).",@m_array[5],@m_array[8],@m_array[10]\n";
}
elsif ($m_array[0] eq "H") {	
print ADJ_MSR_CONV "$adj_id,$m_array[0],$m_array[1],,$m_array[2]$m_array[3],@m_array[5],@m_array[7],@m_array[9]\n";
}

}