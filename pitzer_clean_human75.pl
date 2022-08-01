#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### https://www.osc.edu/resources/available_software/software_list/python
#https://www.osc.edu/resources/getting_started/howto/howto_locally_installing_software
##########################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my $dir="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/merge/";
my $rstD="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/result/";
my $rstD2="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/merge2/";

open (A, "<$file")||die "could not open $file\n";
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    
    my $N1="$a.R1.fastq";
    my $N2="$a.R2.fastq";
    $count++;
    open (B, ">OSC.BWA.$count")||die "could not open OSC.BWA.$count\n";
    

    print B "#!/bin/bash\n";
    print B "#SBATCH --time=12:00:00\n";
    print B "#SBATCH --nodes=1 --ntasks-per-node=8\n";
    print B "#SBATCH --account=PYS0226\n";
    print B "\n";
    print B "source /users/PYS0226/pg123/.bashrc\n";
    print B "conda activate biobakery3\n";

    print B "cd $dir\n";


    print B "module load samtools\n";
    print B "module load bwa/0.7.17-r1198\n";
 

    print B "gunzip $dir/$N1.gz\n";
    print B "gunzip $dir/$N2.gz\n";   
    
    print B "cutadapt -q 30 --minimum-length 31 -o $rstD/$N1 -p $rstD/$N2 $dir/$N1 $dir/$N2 2>$rstD/$N1.err\n";

    print B "bwa mem /fs/project/PYS0226/pg123/bwa_database/hs38p7Phix -T 8  -M  $rstD/$N1 $rstD/$N2 >$rstD/$N1.sam 2>$rstD/$N1.bwa.err\n";
    print B "samtools view -b -S -o $rstD/$N1.bam $rstD/$N1.sam 2>$rstD/$N1.sam.err \n";
    print B "samtools view -b -f 4 $rstD/$N1.bam > $rstD/$N1.unmapped.bam 2>$rstD/$N1.samtools.err\n";
    print B "samtools fastq $rstD/$N1.unmapped.bam -1 $rstD/$N1.BWA_unmapped.fastq -2 $rstD/$N2.BWA_unmapped.fastq 2>$rstD/$N2.samtools.err\n";
    print B  "perl /users/PYS0226/pg123/bin/filter_fastq.pl $rstD/$N1.BWA_unmapped.fastq 30 50 >$rstD/$N1.S30L50.fastq 2>$rstD/$N1.filter.err\n";
    print B  "perl /users/PYS0226/pg123/bin/filter_fastq.pl $rstD/$N2.BWA_unmapped.fastq 30 50 >$rstD/$N2.S30L50.fastq 2>$rstD/$N2.filter.err\n";
    print B "cat $rstD/$a.R1.fastq.S30L50.fastq $rstD/$a.R2.fastq.S30L50.fastq >$rstD2/$a.fastq\n";

   
    close B;
    print "qsub OSC.BWA.$count\n";
}
close A;
