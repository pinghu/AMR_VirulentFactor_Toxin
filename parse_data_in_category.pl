#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file]\n"; 
die $usage unless @ARGV ==1;

my %category;
my %data;
my %sample;
my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
my $x=<A>;
chomp $x;
for($x){s/\r//gi;}
my @title=split /\t/, $x;
my $datalen=(scalar @title) -6;
for (my $i=1; $i < $datalen; $i++){
    #print $title[$i], "\n";
    $sample{$title[$i]}=1;
}
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    if (defined $tmp[$datalen+5]){
	$category{$tmp[$datalen+3]}="VF";
	$category{$tmp[$datalen+4]}="VFC";
	$category{$tmp[$datalen+5]}="species";
	#print $tmp[$datalen+3], "  VF \n", $tmp[$datalen+4], "  VFC\n", $tmp[$datalen+5], "  species\n";
	for (my $i=1; $i < $datalen; $i++){
	    if(! defined $data{$tmp[$datalen+3]}{$title[$i]}){
		$data{$tmp[$datalen+3]}{$title[$i]}=$tmp[$i];
	    }else{
		$data{$tmp[$datalen+3]}{$title[$i]}=$data{$tmp[$datalen+3]}{$title[$i]}+$tmp[$i];
	    }

	    if(! defined $data{$tmp[$datalen+4]}{$title[$i]}){
		$data{$tmp[$datalen+4]}{$title[$i]}=$tmp[$i];
	    }else{
		$data{$tmp[$datalen+4]}{$title[$i]}=$data{$tmp[$datalen+4]}{$title[$i]}+$tmp[$i];
	    }

	    if(! defined $data{$tmp[$datalen+5]}{$title[$i]}){
		$data{$tmp[$datalen+5]}{$title[$i]}=$tmp[$i];
	    }else{
		$data{$tmp[$datalen+5]}{$title[$i]}=$data{$tmp[$datalen+5]}{$title[$i]}+$tmp[$i];
	    }


	    
	}
    }
    
}
close A;

open (B, ">$file.category.sum")||die "could not open $file.category.sum\n";
print B "VFDBcategory\tVFDBlevel";
for (my $i=1; $i < $datalen; $i++){
    print B "\t", $title[$i];
}
print B "\n";

foreach my $i (sort keys %category){
    print B $i, "\t", $category{$i};
    for (my $j=1; $j < $datalen; $j++){
	print B "\t", $data{$i}{$title[$j]};
    }
    print B "\n";
}
close B;
