#use strict;
#use warnings;
use IO::Handle;
use DBI;
use XML::Simple;
use Data::Dumper;



#Declare Variables
my $cluster_id;
my $msr_id;
my $comment_id;
my $msr_proj_id;
my $proj_id;
my $adj_id;


#Parse and prepare filenames
my $adjustment = $ARGV[0];
my $file = $ARGV[0]."msr.xml";
my $adj_output = $ARGV[0].".phased-mt.adj";

# create object
$xml = new XML::Simple;
my $close = "</DnaMeasurement>";

my $MEAS;

#GET NEXT NUMBERS FOR TABLES
#Connect to Database
my $driver   = "Pg";
my $database = "geo";
my $host = "geodetic01";
my $dsn = "DBI:$driver:dbname=$database;host=$host;port=5433";
my $userid = "dave";
my $password = "xxxx";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 ,AutoCommit => 0})
                      or die $DBI::errstr;
print "Opened database successfully\n";
my $sql = qq/select max(cluster_id) as cluster_id, max(msr_id) as msr_id from scn.msr_geodetic/;      # the query to execute
#my $sql = qq/select max(cluster_id) as cluster_id, max(msr_id) as msr_id , max(msr_comment_id) as comment_id, max(adj_id) as adj_id from scn.msr_geodetic/;      # the query to execute

my $sth = $dbh->prepare($sql);          # prepare the query
$sth->execute();                        # execute the query
 $dbh->commit();
my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row
      $cluster_id = @row[0]+1;
     $msr_id = @row[1]+1;
 # $comment_id = @row[2]+1;
 # $adj_id = @row[3]+1;
 # $proj_id = $adj_id;
  $msr_proj_id = $msr_id;
}
my $sql = qq/select max(adj_id) as msr_id from scn.adjustment/;      # the query to execute
#my $sql = qq/select max(cluster_id) as cluster_id, max(msr_id) as msr_id , max(msr_comment_id) as comment_id, max(adj_id) as adj_id from scn.msr_geodetic/;      # the query to execute

my $sth = $dbh->prepare($sql);          # prepare the query
$sth->execute();                        # execute the query
 $dbh->commit();
my @row;
while (@row = $sth->fetchrow_array) {  # retrieve one row
      $adj_id = @row[0]+1;
  $comment_id = $adj_id;
  $proj_id = $adj_id;
}




 print "MSR_ID : $msr_id\n";
  print "Cluster ID : $cluster_id \n";
  print "Comment : $comment_id\n";
  print "ADJ ID : $adj_id \n";
  print "Project ID : $proj_id \n";




#open(OUTTEMP, ">$filetype-$file") || die "Can't open output script for writing$!\n";
#open(OUTCSV, ">$filetype.csv") || die "Can't open output script for writing$!\n";
#print OUTTEMP "test";

open(MSR_GEODETIC, ">msr_geodetic.csv") || die "Can't open msr_geodetic for writing$!\n";
open(MSR_PROJECT, ">msr_project.csv") || die "Can't open msr_project for writing$!\n";
open(MSR_COMMENTS, ">msr_comments.csv") || die "Can't open msr_geodetic for writing$!\n";
open(PROJ_COMMENTS, ">proj_comments.csv") || die "Can't open msr_project for writing$!\n";
open(MSR_DIRECTION, ">msr_direction.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_DIRECTION_SET, ">msr_direction_set.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_DISTANCE, ">msr_distance.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_HEIGHT, ">msr_height.csv") || die "Can't open msr_direction for writing$!\n";
open(ADJ_MSR_CONV, ">adj_msr_conventional.csv") || die "Can't open adj_msr_conventional for writing!\n";
open(MSR_GNSS_BASELINE, ">msr_gnss_baseline.csv") || die "Can't open msr_gnss_baseline for writing!\n";
open(MSR_GNSS_SCALING, ">msr_gnss_scaling.csv") || die "Can't open msr_gnss_scaling for writing!\n";
open(ADJ_MSR_GNSS, ">adj_msr_gnss.csv") || die "Can't open adj_msr_gnss for writing!\n";
#open(ADJUSTMENT, ">adjustment.csv") || die "Can't open adjustment for writing!\n";

print MSR_GEODETIC "msr_id,msr_type,cluster_id,adj_id,ignore,msr_category,msr_comment_id,msr_edit_comments\n";
print MSR_PROJECT "msr_project_id,project_id,msr_id\n";
print MSR_COMMENTS "msr_comment_id, msr_comments\n";
print PROJ_COMMENTS "project_id, project_name, project_comments, project_source\n";
print MSR_DIRECTION "msr_id,mark_id_from,mark_id_to,direction,std_dev\n";
print MSR_DIRECTION_SET "msr_id,mark_id_from,mark_id_to,set_count,direction,std_dev\n";
print MSR_DISTANCE "msr_id,mark_id_from,mark_id_to,distance,std_dev\n";
print MSR_HEIGHT "msr_id,mark_id_from,height,std_dev\n";
print ADJ_MSR_CONV "msr_id, adj_id,nstat,correction,adj_std_dev\n";
print MSR_GNSS_BASELINE "msr_id,mark_id_from,mark_id_to,var_count,covar_count,x,y,z,xx,xy,xz,yy,yz,zz\n";
print MSR_GNSS_SCALING "cluster_id, vscale,pscale,lscale,hscale\n";
print ADJ_MSR_GNSS "msr_id, adj_id,x_corr,y_corr,z_corr,adj_x_std_dev,adj_y_std_dev,adj_z_std_dev,x_nstat,y_nstat,z_nstat\n";
#print ADJUSTMENT "adj_id, adj_date,adj_d_code, adj_epoch, adj_runby, best_adj, dof, measurement_count, unknowns_count, chi_square, sigma_zero, lower_limit, upper_limit, confidence_interval, adj_type\n";


#Process ADJ FILE - Prep outputs
open(ADJUSTMENT, ">adjustment.csv") || die "Can't open adjustment for writing!\n";
open(ADJ_MSR_CONV_ADJUSTED, ">adj_msr_conv_upload.csv") || die "Can't open input $adj_output!\n";
open(ADJ_MSR_GNSS_ADJUSTED, ">adj_msr_gnss_upload.csv") || die "Can't open input $adj_output!\n";

print ADJUSTMENT "adj_id, adj_date,adj_d_code, adj_epoch, adj_runby, best_adj, dof, measurement_count, unknowns_count, chi_square, sigma_zero, lower_limit, upper_limit, confidence_interval, adj_type\n";
print ADJ_MSR_CONV_ADJUSTED "adj_id,type,mark_id_from,mark_id_to,measured,correction,adj_sd,nstat\n";

print MSR_COMMENTS "$adj_id,$file\n";
print PROJ_COMMENTS "$proj_id,$adjustment,$adjustment Daily Processing,dailyrun\n";


print ADJ_MSR_GNSS_ADJUSTED "adj_id,type,from_nine_fig,to_nine_fig,vectornumber,measured,correction,meas_sd,nstat\n";
#Process ADJ FILE - adjustment results
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
}
}
#Process ADJ FILE - Measurements

my $vectornumber = 1;

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
print ADJ_MSR_CONV_ADJUSTED "$adj_id,$m_array[0],$m_array[1],$m_array[2],$m_array[3],@m_array[5],@m_array[7],@m_array[9]\n";
}
elsif ($m_array[0] eq "G") {
	print ADJ_MSR_GNSS_ADJUSTED "$adj_id,$m_array[0]$m_array[3],$m_array[1],$m_array[2],$vectornumber,$m_array[4],@m_array[6],@m_array[8],@m_array[10]\n";
 if ($m_array[3] eq "Z") {$vectornumber++ }
}
elsif ($m_array[0] eq "D") {
	$d_from_id = $m_array[1];
}
elsif ($m_array[0] eq " ") {
print ADJ_MSR_CONV_ADJUSTED "$adj_id,D,$d_from_id,$m_array[1],$m_array[2].$m_array[3]".(10000*$m_array[4]).",@m_array[8],@m_array[10],@m_array[12]\n";
}
elsif ($m_array[0] eq "H") {
print ADJ_MSR_CONV_ADJUSTED "$adj_id,$m_array[0],$m_array[1],,$m_array[2]$m_array[3],@m_array[5],@m_array[7],@m_array[9]\n";
}
}





#PROCESS MSR FILE
my @filetypes = (   "E", "M", "H","D","G");
foreach $filetype (@filetypes){
{local $/ = undef;
open(MEAS, "<$file") || die "Can't open input $!\n";
while (<MEAS>) {
  $_ =~ s/\s*\n/\n/gm;

my @values = split /(?<=\/DnaMeasurement>\n)/ , $_;

my @matches = grep { /<Type>$filetype<\/Type>/ } @values;

foreach $a (@matches){
# read XML file
my $data = $xml->XMLin($a, ForceArray => [ 'Directions', 'GPSBaseline']);

my @comments = split (/\n/ , $a);
my @comment = grep{ /<!--(.+)-->/ } @comments;
my ($matched) = @comment[0] =~ m/<!--(.+)-->/;


# access XML data
if ($filetype eq 'E' || $filetype eq 'M') {
										#		print OUTCSV "$data->{First},$data->{Second},$data->{Type},$data->{Value},$data->{StdDev},";
												print MSR_GEODETIC "$msr_id,$data->{Type},,$adj_id,,E3,$comment_id,";
												print MSR_PROJECT "$msr_proj_id,$proj_id,$msr_id\n";
												print MSR_DISTANCE "$msr_id,$data->{First},$data->{Second},$data->{Value},$data->{StdDev}\n";
												print ADJ_MSR_CONV "$msr_id,$adj_id,,,\n";
												foreach $b (@comment) {
														$b =~ m/<!--(.+)-->/;
														my $comment_semi = $1  =~ s/\,/;/r;
									#					print OUTCSV "$1  ";
														print MSR_GEODETIC "$comment_semi ";}
									#			 	print OUTCSV "\n";
												 	print MSR_GEODETIC "\n";
												 $msr_id ++;
												 $msr_proj_id ++;
												 												 		 	}

elsif ($filetype eq 'H') {
										#		print OUTCSV "$data->{First},$data->{Type},$data->{Value},$data->{StdDev},";
												print MSR_GEODETIC "$msr_id,$data->{Type},,$adj_id,,E3,$comment_id,";
												print MSR_PROJECT "$msr_proj_id,$proj_id,$msr_id\n";
												print MSR_HEIGHT "$msr_id,$data->{First},$data->{Value},$data->{StdDev}\n";
												print ADJ_MSR_CONV "$msr_id,$adj_id,,,\n";
												foreach $b (@comment) {
														$b =~ m/<!--(.+)-->/;
														my $comment_semi = $1  =~ s/\,/;/r;
										#				print OUTCSV "$1  ";
														print MSR_GEODETIC "$comment_semi ";}
												 		print OUTCSV "\n";
												 		print MSR_GEODETIC "\n";
												 $msr_id ++;
												 $msr_proj_id ++;
												 		}

elsif ($filetype eq 'D') {
									for ($data){
											print MSR_DIRECTION_SET "$msr_id,$data->{First},$data->{Second},$data->{Total},$data->{Value},$data->{StdDev}\n";
										print MSR_GEODETIC "$msr_id,$data->{Type},$cluster_id,$adj_id,,E3,$comment_id,";
										print MSR_PROJECT "$msr_proj_id,$proj_id,$msr_id\n";
										print ADJ_MSR_CONV "$msr_id,$adj_id,,,\n";
										foreach $b (@comment) {
											 												$b =~ m/<!--(.+)-->/;
														my $comment_semi = $1  =~ s/\,/;/r;
										 print MSR_GEODETIC "$comment_semi ";}
										 print MSR_GEODETIC "\n";
										$msr_id ++;
										 $msr_proj_id ++;
																for (@{$data->{Directions}}) {
												#							print OUTCSV "$msr_id,$data->{Type},$cluster_id,$data->{First},$data->{Second},$data->{Value},$data->{StdDev},$_->{Target},$_->{Value},$_->{StdDev},";
																			print MSR_DIRECTION "$msr_id,$data->{First},$_->{Target},$_->{Value},$_->{StdDev}\n";
																			print MSR_GEODETIC "$msr_id,$data->{Type},$cluster_id,$adj_id,,E3,$comment_id,";
																			print MSR_PROJECT "$msr_proj_id,$proj_id,$msr_id\n";
																			print ADJ_MSR_CONV "$msr_id,$adj_id,,,\n";
																			foreach $b (@comment) {
											 												$b =~ m/<!--(.+)-->/;
																						my $comment_semi = $1  =~ s/\,/;/r;
																						  print OUTCSV "$1  ";
																						  print MSR_GEODETIC "$comment_semi ";}
												 							 print OUTCSV "\n";
												 							 print MSR_GEODETIC "\n";
												 							 $msr_id ++;
												 							  $msr_proj_id ++;	}
												$cluster_id ++			;	}	}


elsif ($filetype eq 'G') {
				for ($data){
					for (@{$data->{GPSBaseline}}) {
						#print Dumper \$1;
										#		print OUTCSV "$data->{First},$data->{Second},$data->{Type},$data->{X},$data->{Y},$data->{Z},";
												print MSR_GEODETIC "$msr_id,$data->{Type},$cluster_id,$adj_id,,E2,$comment_id,";
												print MSR_PROJECT "$msr_proj_id,$proj_id,$msr_id\n";
												print MSR_GNSS_BASELINE "$msr_id,$data->{First},$data->{Second},,,$_->{X},$_->{Y},$_->{Z},$_->{SigmaXX},$_->{SigmaXY},$_->{SigmaXZ},$_->{SigmaYY},$_->{SigmaYZ},$_->{SigmaZZ}\n";
												print MSR_GNSS_SCALING "$cluster_id,$data->{Vscale},$data->{Pscale},$data->{Lscale},$data->{Hscale}\n";
												print ADJ_MSR_GNSS "$msr_id,$adj_id,,,,,,,,,\n";
											#	foreach $b (@comment) {
													#	$b =~ m/<!--(.+)-->/;
													#	my $comment_semi = $1  =~ s/\,/;/r;
														#print OUTCSV "$1  ";
													#	print MSR_GEODETIC "$comment_semi ";}
										#		 	print OUTCSV "\n";
												 	print MSR_GEODETIC "\n";
												 $msr_id ++;
												 $msr_proj_id ++;
												 $cluster_id ++
												 										}	 	}
												 												 	}
else {}
}}}}

