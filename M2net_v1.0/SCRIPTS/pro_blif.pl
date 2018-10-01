#!usr/bin/perl -w

# Copyright (c) 2014, EPFL, Integrated Systems Laboratory

use strict;
use Shell;
#Use the time
use Time::gmtime;

#Get Date
my $mydate = gmctime();

my ($fname,$frpt);

sub print_usage()
{
  print "Usage:\n";
  print "      perl <script_name.pl> [-options]\n";
  print "      Options:(Mandatory!)\n";
  print "              -i <input_blif_path>\n";
  print "              -o <output_blif_path>\n";
  print "\n";
  return 1;
}

sub opts_read()
{
  if (-1 == $#ARGV)
  {
    print "Error: No input argument!\n";
    &print_usage();
    exit(1); 
  }
  else
  {
    for (my $iargv = 0; $iargv < $#ARGV+1; $iargv++)
    {
      if ("-i" eq $ARGV[$iargv]) 
      {$fname = $ARGV[$iargv+1];}
      elsif ("-o" eq $ARGV[$iargv]) 
      {$frpt = $ARGV[$iargv+1];}
    }
  } 
  return 1;
}

sub scan_blif()
{
  my ($line);
  my @tokens;
  
  # Open src file
  open(FIN, "< $fname") or die "Fail to open $fname!\n";  
  # Open des file
  open(FOUT, "> $frpt") or die "Fail to open $frpt!\n";  
  while(defined($line = <FIN>)) {
    chomp $line; 
    # Check if this line start with ".latch", which we cares only
    @tokens = split('\s+',$line);
    if (".inputs" eq $tokens[0]) {
      $line =~ s/^\.inputs/.inputs clk/;
    }
    if (".latch" eq $tokens[0]) {
      # check if we need complete it
      if ($#tokens == 3) {
        # Complete it
        for (my $i=0; $i<3; $i++) {
          print FOUT "$tokens[$i] ";
        }
        print FOUT "re clk $tokens[3]\n";
        next;
      }
    }
    print FOUT "$line\n";
  }
  close(FIN);
  close(FOUT);
  return 1;
}

sub main()
{
  &opts_read(); 
  &scan_blif();
  return 1;
}
 
&main();
exit(1);
