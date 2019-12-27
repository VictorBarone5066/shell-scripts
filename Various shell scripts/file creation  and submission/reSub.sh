#!/bin/csh

set origLoc=`pwd`
set dirControl="$origLoc/"
set maxDepth=10
set i=0
set add="*/"
set file=/POSCAR
set runLoc=`pwd`/RUN
set rnCount=0

#make dirControl in scratch folder to avoid early termination
set z=0
cd $dirControl
mkdir depthControl
cd depthControl
while ($z < $maxDepth)
        mkdir $z
        cd $z
        @ z++
end

while ($i < $maxDepth)

	foreach j ($dirControl)
		cd j
	
		if ((-f INCAR) && (-f KPOINTS) && (-f POTCAR)) then

#do stuff here------------------------------------------------------------------------------

mv POSCAR POSCARorig2
if (-f OUTCAR) then
	mv OUTCAR OUTCARorig2
endif
mv CONTCAR POSCAR
qsub RUN$rnCount

@ rnCount++

#stop doing stuff here----------------------------------------------------------------------
		
		cd ../
		endif
	end

set dirControl="$dirControl$add"
@ i++

end

cd $origLoc
rm -rf depthControl
echo "Script End"

