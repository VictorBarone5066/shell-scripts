#!/bin/csh

set origLoc=`pwd`
set dirControl="$origLoc/"
set maxDepth=10
set i=0
set add="*/"
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
	
		if (-f CONTCAR) then

#do stuff here------------------------------------------------------------------------------

mkdir tmpFol

mv POSCAR tmpFol/.
mv CONTCAR tmpFol/.
mv OUTCAR tmpFol/.

rm *

mv tmpFol/POSCAR .
mv tmpFol/CONTCAR .
mv tmpFol/OUTCAR .

rm -r tmpFol

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

