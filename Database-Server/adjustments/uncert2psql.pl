use strict;
#use warnings;
use IO::Handle;
use DBI;

my $OUT;
my $APU;
my $adjustment = $ARGV[0];
my $source = $ARGV[0].".phased-mt.apu";
my $FOURCHAR;
my $fourchar;
my $CLEAN;
my $FINAL;
my $ninefig; my $lat; my $lon; my $UncertH; my $UncertV; my $semiMajor; my $semiMinor; my $Orientation; my $xx; my $xy; my $xz; my $yy; my $yz; my $zz;
my $decimal_xx;

#Connect to Database
my $driver   = "Pg";
my $database = "geo";
my $dsn = "DBI:$driver:dbname=$database;host=localhost;port=5433";
my $userid = "dave";
my $password = "xxxxxx";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 ,AutoCommit => 0})
                      or die $DBI::errstr;

print "Opened database successfully\n";

#open(APU,"<victoria_160203.phased-mt.apu") || die "Cannot open log file $APU\n";
open(APU, "<", "$source") || die "Cannot open input file $source\n";
open(OUT, ">uncert_temp.txt") || die "Can't open output script for writing$!\n";
open(FOURCHAR, "<4char_9fig.csv") || die "Cannot open log file FOURCHAR\n";


#split /,/,
 {local $/;
while(<APU>)
  {
 $_ =~ s/\n                                                                                                                                                          /   /gm;
  $_ =~ s/\n                                                                                                                                       /   /gm;

  print OUT $_;
  }

  };
  close OUT;
   open (FINAL, ">uncert_final.txt");
  print FINAL "nine_fig,pos_uncertainty,xx,xy,xz,yy,yz,zz,v_uncertainty\n";
 open (CLEAN, "<uncert_temp.txt");
open (CLEAN2,">uncert_clean.txt");


  while (<CLEAN>)  {
  #my $n = CLEAN->input_line_number();
 next unless (CLEAN->input_line_number() > 16);
 #next if $. < 16;
  print CLEAN2 $_;
 ($ninefig, $lat, $lon, $UncertH, $UncertV, $semiMajor, $semiMinor, $Orientation, $xx, $xy, $xz, $yy, $yz, $zz) = split (/\s+/,$_);
 my $UnvertVahd = sqrt($UncertV*$UncertV+0.05*0.05);
  print FINAL $ninefig,",", (sprintf("%.3f",$UncertH)),",",(sprintf("%.14f", $xx)),",", (sprintf("%.14f", $xy)),",", (sprintf("%.14f", $xz)),",", (sprintf("%.14f", $yy)),",", (sprintf("%.14f", $yz)),",", (sprintf("%.14f", $zz)),",", (sprintf("%.3f",$UnvertVahd)) , "\n" ;
#  my $stmt = qq(INSERT INTO uncertainties (nine_fig, pos_uncertainty, xx,xy,xz,yy,yz,zz,v_uncertainty)
 #     VALUES ($ninefig,(sprintf("%.3f",$UncertH)),(sprintf("%.14f", $xx)),(sprintf("%.14f", $xy)),(sprintf("%.14f", $xz)),(sprintf("%.14f", $yy)),(sprintf("%.14f", $yz)),(sprintf("%.14f", $zz)),(sprintf("%.3f",$UncertV)));
#	  );
$dbh->do('INSERT INTO "scn"."uncert" (nine_fig, pos_uncertainty, xx,xy,xz,yy,yz,zz,v_uncertainty,adjustment) VALUES (?,?,?,?,?,?,?,?,?,?)',
			undef,
			$ninefig,(sprintf("%.3f",$UncertH)),(sprintf("%.14f", $xx)),(sprintf("%.14f", $xy)),(sprintf("%.14f", $xz)),(sprintf("%.14f", $yy)),(sprintf("%.14f", $yz)),(sprintf("%.14f", $zz)),(sprintf("%.3f",$UnvertVahd)),$adjustment);
 };
 $dbh->commit();
  print "Uncertainties written to database successfully\n";



