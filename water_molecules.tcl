set outfile [open water_numbers.dat w]
set nf [molinfo top get numframes]
set sel [atomselect top "name OW and water and within 5.0 of resid 500"]
# water molecules number calculation loop within 5 angstrom of resid phenol or others
for { set i 1 } { $i <= $nf } { incr i} {$sel frame $i
$sel update
puts $outfile "$i  [$sel num]"
 }
close $outfile
