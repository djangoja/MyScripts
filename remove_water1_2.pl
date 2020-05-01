#--------------------------------------------------------------------------
# Version 1.2
# By Anthony Nash, University of Oxford
#-------------------------------------------------------------------------
# 1.1 - a temp fix by directly stating how many lines there are in the input file 2010
#
# As the size of the systems are very big, the number of water molecules causes the atoms count to roll
# over starting back at 1. This makes the index group removal null and void. I must therefore write out
# all atoms I want to keep directly to an index file and then call editcon_f. This script will output a file
# named "number". Inside is a single value representing the number of water atoms preserved.
#
# 1.2 - brought back to life! 2017 (Dec)
# At the moment this will work with SOL water molecules names that have an OW atom types
#
#


use warnings;
use strict;

#1- inputfile.gro
#2- outputfile.gro
#3- z1 coordinate - remove what is inbetween z1 and z2
#4- z2 coordinate
#5 - number of lines in file

my $version = 1.2;
if(($ARGV[0] eq "-v") && (@ARGV == 1)) {
    print "Version $version\n";
    exit;
} elsif(($ARGV[0] eq "-v") && (@ARGV != 1)) {
    print "Unknown remove water command!\n"; 
    exit;
}

print "\n";
print "\t\t\tBilayer Water Removal Tool for Gromacs files\n";
print "\t\t\tBy Anthony Nash - Version $version\n";
print "*************************************************************************************\n\n";


if(($ARGV[0] eq "-h") && (@ARGV == 1)) {
    print "The removal of all atom water molecules from the lipid bilayer centre\n\n";
    print "Ensure you enter the following information in the given order\n";
    print "You can take the z1 and z2 z-coordinates using VMD, but remember that VMD works in angstrom and gromacs works in nano metres.\n";
    print "perl remove_water.pl inputfile.gro outputfile.gro z1 z2\n";
    print "\tinputfile.gro - file containing the water molecules to be removed.\n";
    print "\toutputfile.gro - output.\n";
    print "\tz1 and z2 - remove the water molecules between these two points (nm).\n";
    print "\t number_of_lines - number of lines in the input file"
} elsif(($ARGV[0] eq "-h") && (@ARGV != 1)) {
    print "Unknown remove water command!\n";
    exit;
}

my $numberOfWantedArgs = 5;
my $numberOfArgs = @ARGV;
if($numberOfWantedArgs != $numberOfArgs) {
    print "Not enough arguments.\n";
    exit;
}

my $inputFile = $ARGV[0];
my $outputFile = $ARGV[1];
my $z1 = $ARGV[2];
my $z2 = $ARGV[3];
my $numberOfLines = $ARGV[4];

#------------------------------------------------------------------------


my $il1 = 0;
my $il2 = 1;
my $il3 = $numberOfLines - 1;


#WE WRITE INTO AN INDEX FILE ALL OF THE ATOMS WE WANT TO KEEP
open(IN, "<$ARGV[0]") or die("Cannot open the input file for shift out the bad water!");
open(OUTFILE,">water_removed.gro") or die("Cannot create a new index file for the molecules we want to keep");

my $water_atom_count = 0;
my $atom_count = 0;
my $line;
my $water;
my $i=0;
while($line = <IN>) {
    if(($i!=$il1) && ($i!=$il2) && ($i!=$il3)) {
        my $name = substr($line,5,5);
        my $type = substr($line,10,5);
        if(($name =~ m/SOL/) && ($type =~ m/OW/)) {
            my $z = substr($line,36,8);
            if(($z <= $z1) || ($z >= $z2)) {
                $water = 1;
                $water_atom_count++;
                $atom_count++;
                print(OUTFILE "$line");
            } else {
		my $atomName = substr($line,15,5);
                $water = 0;
            }
        } elsif(($name =~ m/SOL/) && ($type !~ m/OW/)) {
              if($water == 1) {
                  $water_atom_count++;
                  $atom_count++;
                  print(OUTFILE "$line");
              }
        } else {
              #everything that is not water
              $atom_count++;
              print(OUTFILE "$line");
        }
    } else {
        print(OUTFILE "$line");
    }

    $i++;
}
close(IN);
close(OUTFILE);

open(COUNT_OUT,">number") or die("Cannot write out the number of preserved water atoms");
print(COUNT_OUT "$water_atom_count");
close(COUNT_OUT);

#I need to open up the file that was just created and update the number of atoms there are. 
open(IN, "<water_removed.gro") or die("Cannot open the gro file water_removed.gro after having removed all of the unwanted water molecules. Perhaps it does not exist!");
open(OUT, ">updated_water.gro") or die("Cannot create the new file which contains the updated atom count\n");

my $line_counter = 1;
while(my $line = <IN>) {
    if($line_counter == 2) {
        print(OUT "$atom_count\n");
    } else {
        print(OUT "$line");
    }

    $line_counter++;

}

close(IN);
close(OUT);


#reallign the atom numbers
my $run9 = system("/usr/local/gromacs5.1.2/bin/gmx_d editconf -quiet -f updated_water.gro -o $outputFile");
if($run9 != 0) {
    print "Unable to resolved atom numbering in the final step. Gromacs FAIL.\n";
    exit;
}

