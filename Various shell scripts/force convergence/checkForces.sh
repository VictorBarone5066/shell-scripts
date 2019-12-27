#!/bin/csh

set dirControl="/storage/work/vkb5066/"
#set dirControl="/gpfs/scratch/vkb5066/"
set maxDepth=11
set i=0
set add="*/"
set file=/OUTCAR
set forceTol=0.01

if (-f output.csv) then
	rm output.csv
endif

if (-d highForces/) then
        rm -r highForces
endif
mkdir highForces


#make dirControl in scratch folder to avoid early termination
set z=0
cd $dirControl
mkdir depthControl
cd depthControl
while ($z < 20)
	mkdir $z
	cd $z
	@ z++
end

echo "directory,force ok? (should all be 0),max force (eV / angst.)" >/storage/home/vkb5066/scripts/forceChecker/output.csv
while ($i < $maxDepth)

	foreach j ($dirControl)
		#echo $j
		cd j
	
		if (-f OUTCAR) then
			cd ../

			if (-f USE2) then
				set id=`cat USE2`
				cd -
#do stuff here-------------------------------------------------------------------------------------------------------
				
				#pre Clean
				if (-f forceInfo) then
					rm forceInfo
				endif
				if (-f hereCSVLine) then
					rm hereCSVLine
				endif
				
				#run drive subScript
				cp /storage/home/vkb5066/scripts/forceChecker/drive.sh drive.sh
				cp /storage/home/vkb5066/scripts/forceChecker/nAtomsCPP nAtomsCPP
				cp /storage/home/vkb5066/scripts/forceChecker/everythingElse everythingElse
				./drive.sh $forceTol
				rm drive.sh
				rm nAtomsCPP
				rm everythingElse

				if (-f $j/hereCSVLine) then
					#Determine name
        	                        set n=`echo "$j" | awk -F "/" '{print $(NF-1)}'`
	                                set m=`echo "$j" | awk -F "/" '{print $(NF-2)}'`

					cat hereCSVLine >>/storage/home/vkb5066/scripts/forceChecker/output.csv
					mv /storage/home/vkb5066/scripts/forceChecker/highForces/forceInfo /storage/home/vkb5066/scripts/forceChecker/highForces/forceInfo$m$n
				endif

#stop doing stuff here------------------------------------------------------------------------------------------------
				cd -
			
			endif
		cd ../
		endif
	end

set dirControl="$dirControl$add"
@ i++
end

rm -r /storage/work/vkb5066/depthControl/
echo "Script End"

