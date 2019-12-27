#!/bin/csh

foreach i ( 1DVacBulkX 1DVacBulkY 2DVacBulk )
	cd $i

	./strain*

	set j=0
	while ($j < 9)
		#mkdir $j
		mv Edit$j $j/POSCARorig0
		#cp ../INCAR $j/INCAR
		#cp ../KPOINTS $j/KPOINTS
		#cp ../POTCAR $j/POTCAR
		#cp ../RUN $j/RUN

		@ j++
	end

	cd ../
end
 
echo "done."
