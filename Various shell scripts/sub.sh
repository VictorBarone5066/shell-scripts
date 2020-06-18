#!/bin/csh

set origLoc=`pwd`
set dirControl="$origLoc/"
set maxDepth=10
set i=0
set add="*/"
set file=/POSCAR
set runLoc=`pwd`/RUN
set rnCount=0

#make dirControl in folder to avoid early termination
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
	
		if (-f POSCAR) then

#do stuff here------------------------------------------------------------------------------

cp $origLoc/RUN RUN$rnCount
cp $origLoc/POTCAR .
cp $origLoc/KPOINTS .

if (-f ../vac) then
	cp $origLoc/INCARvac INCAR
else
	cp $origLoc/INCARelse INCAR
endif

#qsub RUN$rnCount
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

