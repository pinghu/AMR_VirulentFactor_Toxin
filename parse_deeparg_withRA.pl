#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### perl combine_one_col_from_multiplefile.pl 13 select.list >BC3.AB.select.xls
##########################################################################
use strict;
my $usage="$0   <filelist> <R1 reads countfile> \n"; 
die $usage unless @ARGV >=1 ;
my ( $filelist) = @ARGV;
my %orgCount;
open (A, "</mnt/G6_2D/project/AMR_VirulentFactor/deeparg/R1.reads")||die "could not open /mnt/G6_2D/project/AMR_VirulentFactor/deeparg/R1.reads\n";
while (my $a=<A>){
    chomp $a;
    for ($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    $orgCount{$tmp[0]}=2*$tmp[1];
    #print STDERR "orgCount ", $tmp[0], "\n";
}
close A;

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
    open (B, "<$a.deeparg.clean.deeparg.mapping.ARG")||die "could not 1open $a.deeparg.clean.deeparg.mapping.ARG\n";
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
	$AMRid{$tmp[0]}=$tmp[4];
    }
    close B;
}
close A;
################################################################################
open (C, ">ARG_count")||die "could not open ARG_count\n";
print C "AMR\tCategory\tSubcategory";
foreach my $ff(sort keys %fid){
    print C "\t", $ff;
}
print C "\n";

foreach my $i (keys %AMRid){
    print C $i, "\tAMR\t", $AMRid{$i};	
    foreach my $ff(sort keys %fid){

	if(defined $AMR{$i}{$ff}){
	    print C "\t", $AMR{$i}{$ff};
	}else{
	    print C "\t0";
	}
    }
    print  C "\n";

}
foreach my $i (keys %gid){
    print C $i, "\tAMRCategory\tAMRCategory";	
    foreach my $ff(sort keys %fid){

	if(defined $group{$i}{$ff}){
	    print C "\t", $group{$i}{$ff};
	}else{
	    print C "\t0";
	}
    }
    print  C "\n";

}
print C "TotalReads\tTotalReads\tTotalReads";
foreach my $ff(sort keys %fid){
   # print STDERR "fid $ff\n";
    print C "\t", $orgCount{$ff};
}
print C "\n";
close C;
##############################################################
open (C, ">ARG_RA")||die "could not open ARG_RA\n";
print C "AMR\tCategory\tSubcategory";
foreach my $ff(sort keys %fid){
    print C "\t", $ff;
}
print C "\n";

foreach my $i (keys %AMRid){
    print C $i, "\tAMR\t", $AMRid{$i};	
    foreach my $ff(sort keys %fid){

	if(defined $AMR{$i}{$ff}){
	    print C "\t", $AMR{$i}{$ff}/$orgCount{$ff};
	}else{
	    print C "\t0";
	}
    }
    print  C "\n";

}
foreach my $i (keys %gid){
    print C $i, "\tAMRCategory\tAMRCategory";	
    foreach my $ff(sort keys %fid){

	if(defined $group{$i}{$ff}){
	    print C "\t", $group{$i}{$ff}/$orgCount{$ff};
	}else{
	    print C "\t0";
	}
    }
    print  C "\n";

}

close C;
