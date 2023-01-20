#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my %ann;
open (A, "</mnt/G6_2D/project/AMR_VirulentFactor/shortbred/externalHospital_study/VFDB.ann.txt")||die "could not open VFDB.ann.txt\n";
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    $ann{$tmp[0]}=$a;
}
close A;

my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
open (B, ">$file.ann.xls")||die "could not open $file.ann.xls\n";
my $x=<A>;
chomp $x;
for($x){s/\r//gi;}
print B $x, "\tID\tgenbank\tgene_name\tcategory1\tcategory2\tSpecies\n", ;

while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    my @nn=split /\|/, $tmp[0];
    my @xx=split /\(/, $nn[1];
    if(defined $ann{$xx[0]}){
        print B $a, "\t",$ann{$xx[0]}, "\n" ;
    }else{
	print B $a, "\n";
    }
}
close A;
close B;

