#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file> \n"; 
die $usage unless @ARGV == 1;
my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;   
    if ($a =~ /^\@(\S+)/){
	print ">",$a,"\n";
	my $b=<A>;
	print $b;
	my $c=<A>;
	chomp $c;
	if ($c ne "+"){print STDERR "check here $c \n";}
	my $d=<A>;
    } 
}
close A;
