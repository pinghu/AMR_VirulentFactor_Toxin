#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### perl combine_one_col_from_multiplefile.pl 13 select.list >BC3.AB.select.xls
##########################################################################
use strict;
my $usage="$0   <filelist> \n"; 
die $usage unless @ARGV >=1 ;
my ( $filelist) = @ARGV;
my %group;
my %AMR;
my %fid;
my %AMRid;
my %gid;
open (A, "<$filelist")||die "could not open $filelist\n";
while (my $a=<A>){
    chomp $a;
    for ($a){s/\r//gi;}
    $fid{$a}=1;
    open (B, "<$a")||die "could not open $a\n";
    my $tmp=<B>;
    while (my $b=<B>){
	chomp $b;
	for($b){s/\r//gi;}
	my @tmp=split /\t/, $b;	
	if(! defined $AMR{$tmp[0]}{$a}){
	    $AMR{$tmp[0]}{$a}=$tmp[11];
	}else{
	    $AMR{$tmp[0]}{$a}=$tmp[11]+$AMR{$tmp[0]}{$a};
	}
	if(!defined $group{$tmp[4]}{$a}){
	    $group{$tmp[4]}{$a}=$tmp[11];
	}else{
	     $group{$tmp[4]}{$a}=$tmp[11]+$group{$tmp[4]}{$a};
	}
	$gid{$tmp[4]}=1;
	$AMRid{$tmp[0]}=1;
    }
    close B;
}
close A;

print "AMR\tCategory";
foreach my $ff(sort keys %fid){
    print "\t", $ff;
}
print "\n";

foreach my $i (keys %AMRid){
    print $i, "\tAMR";	
    foreach my $ff(sort keys %fid){

	if(defined $AMR{$i}{$ff}){
	    print "\t", $AMR{$i}{$ff};
	}else{
	    print "\t0";
	}
    }
    print  "\n";

}
foreach my $i (keys %gid){
    print $i, "\tAMRCategory";	
    foreach my $ff(sort keys %fid){

	if(defined $group{$i}{$ff}){
	    print "\t", $group{$i}{$ff};
	}else{
	    print "\t0";
	}
    }
    print  "\n";

}
