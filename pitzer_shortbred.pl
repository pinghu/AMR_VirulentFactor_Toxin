##################################################################
#Ping HU; 2022-08-02; Run ShortBred Pipeline on OSC
#################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my $dir="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/merge2/";
my $rstD="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/shortbred/";


open (A, "<$file")||die "could not open $file\n";
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    
    $count++;
    open (B, ">OSC.shortbred.$count")||die "could not open OSC.shortbred.$count\n";
    print B "#!/bin/bash\n";
    print B "#SBATCH --time=12:00:00\n";
    print B "#SBATCH --nodes=1 --ntasks-per-node=28\n";
    print B "#SBATCH --account=PYS0226\n";
    print B "\n";
    print B "source /users/PYS0226/pg123/.bashrc\n";
    
    print B "cd $dir\n";

    print B "module load bowtie2\n";
    print B "module load 2.7-conda5.2\n";
    print B "module load blast\n";
    print B "module load muscle\n";
    print B "module use /users/PYS0226/pg123/local/share/modulefiles/\n";
    print B "module load biopython/1.65\n";

    
    print B "export PATH=\$PATH:~/pkg/cd-hit-v4.6.7-2017-0501/\n";
    print B "export PATH=\$PATH:~/local/biopython/1.65/bin\n";
    print B "export PYTHONPATH=\$PYTHONPATH:~/local/biopython/1.65/lib/python2.7/site-packages\n";
    
    print B "perl ~/bin/fastq2fasta.pl $dir/$a.fastq > $dir/$a.fasta\n";

    print B "python2 /fs/scratch/PYS0226/pg123/shortbred/shortbred_quantify.py --markers /fs/project/PYS0226/pg123/shortBRED/2017_database/ShortBRED_VF_2017_markers.faa --wgs $dir/$a.fasta --results $rstD/$a.shortbred2017VF.txt --tmp $rstD/$a.2017VF 1>$rstD/out.$a.2017VF 2>$rstD/err.$a.2017VF\n";
    
    print B "python2 /fs/scratch/PYS0226/pg123/shortbred/shortbred_quantify.py --markers /fs/project/PYS0226/pg123/shortBRED/2017_database/ShortBRED_CARD_2017_markers.faa --wgs $dir/$a.fasta --results $rstD/$a.shortbred2017CARD.txt --tmp $rstD/$a.2017CARD 1>$rstD/out.$a.2017CARD 2>$rstD/err.$a.2017CARD\n";
    
    
    close B;
    print "sbatch OSC.shortbred.$count\n";
}
close A;
