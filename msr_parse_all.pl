#use strict;
#use warnings;
use IO::Handle;
use DBI;
use XML::Simple;
use Data::Dumper;



my $file = $ARGV[0];
my $filetype = $ARGV[1];
my $cluster_id = 12;
my $msr_id = 111;
my $comment_id = 3;
my $msr_proj_id = 111;
my $proj_id = 5;
my $adj_id = 5;


# create object
$xml = new XML::Simple;
my $close = "</DnaMeasurement>";
 
my $MEAS;
 
#open(OUTTEMP, ">$filetype-$file") || die "Can't open output script for writing$!\n";
#open(OUTCSV, ">$filetype.csv") || die "Can't open output script for writing$!\n";
#print OUTTEMP "test";

open(MSR_GEODETIC, ">msr_geodetic.csv") || die "Can't open msr_geodetic for writing$!\n";
open(MSR_PROJECT, ">msr_project.csv") || die "Can't open msr_project for writing$!\n";
open(MSR_DIRECTION, ">msr_direction.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_DIRECTION_SET, ">msr_direction_set.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_DISTANCE, ">msr_distance.csv") || die "Can't open msr_direction for writing$!\n";
open(MSR_HEIGHT, ">msr_height.csv") || die "Can't open msr_direction for writing$!\n";
open(ADJ_MSR_CONV, ">adj_msr_conventional.csv") || die "Can't open adj_msr_conventional for writing!\n";
open(MSR_GNSS_BASELINE, ">msr_gnss_baseline.csv") || die "Can't open msr_gnss_baseline for writing!\n";
open(MSR_GNSS_SCALING, ">msr_gnss_scaling.csv") || die "Can't open msr_gnss_scaling for writing!\n";
open(ADJ_MSR_GNSS, ">adj_msr_gnss.csv") || die "Can't open adj_msr_gnss for writing!\n";



print MSR_GEODETIC "msr_id,msr_type,cluster_id,adj_id,ignore,msr_category,msr_comment_id,msr_edit_comments\n";
print MSR_PROJECT "msr_project_id,project_id,msr_id\n";
print MSR_DIRECTION "msr_id,mark_id_from,mark_id_to,direction,std_dev\n";
print MSR_DIRECTION_SET "msr_id,mark_id_from,mark_id_to,set_count,direction,std_dev\n";
print MSR_DISTANCE "msr_id,mark_id_from,mark_id_to,distance,std_dev\n";
print MSR_HEIGHT "msr_id,mark_id_from,height,std_dev\n";
print ADJ_MSR_CONV "msr_id, adj_id,nstat,correction,adj_std_dev\n";
print MSR_GNSS_BASELINE "msr_id,mark_id_from,mark_id_to,var_count,covar_count,x,y,z,xx,xy,xz,yy,yz,zz\n";
print MSR_GNSS_SCALING "cluster_id, vscale,pscale,lscale,hscale\n";
print ADJ_MSR_GNSS "msr_id, adj_id,x_corr,y_corr,z_corr,adj_x_std_dev,adj_y_std_dev,adj_z_std_dev,x_nstat,y_nstat,z_nstat\n";



 #my $measure_count;

my @filetypes = (   "E", "M", "H","D","G");
#my @filetypes = (   "G");

#my @filetypes = ( "D");
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
#my $datagnss = $xml->XMLin($a, ForceArray => [ 'GPSBaseline']);
#
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
}
}
}
}

