#!/bin/csh

#set dirControl="/storage/work/vkb5066/"
set dirControl="/gpfs/scratch/vkb5066/14.71_12.67/"
set maxDepth=11
set i=0
set add="*/"
set file=/OUTCAR
set enTol=0.01

if (-f output.csv) then
	rm output.csv
endif

if (-d nonConverged/) then
        rm -r nonConverged
endif
mkdir nonConverged


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

echo "directory,energy ok? (should all be 0),energy diff between the last two writes (eV)" >/storage/home/vkb5066/scripts/energyConvChecker/output.csv

while ($i < $maxDepth)

        foreach j ($dirControl)
                cd j

                if ((-f INCAR) && (-f KPOINTS) && (-f POTCAR) && (-f OUTCAR)) then

#do stuff here-------------------------------------------------------------------------------------------------------
				
				#pre Clean
				if (-f enInfo) then
					rm enInfo
				endif
				if (-f hereCSVLine) then
					rm hereCSVLine
				endif
				
				#run drive subScript
				cp /storage/home/vkb5066/scripts/energyConvChecker/drive.sh drive.sh
				cp /storage/home/vkb5066/scripts/energyConvChecker/energy energy
				./drive.sh $enTol
				rm drive.sh
				rm energy
				

				if (-f $j/hereCSVLine) then
					#Determine name
        	                        set n=`echo "$j" | awk -F "/" '{print $(NF-1)}'`
	                                set m=`echo "$j" | awk -F "/" '{print $(NF-2)}'`

					cat hereCSVLine >>/storage/home/vkb5066/scripts/energyConvChecker/output.csv
					mv /storage/home/vkb5066/scripts/energyConvChecker/nonConverged/enInfo /storage/home/vkb5066/scripts/energyConvChecker/nonConverged/enInfo$m$n
					rm hereCSVLine
				endif

#stop doing stuff here------------------------------------------------------------------------------------------------

                cd ../
                endif
        end

set dirControl="$dirControl$add"
@ i++

end

rm -r /storage/work/vkb5066/14.71_12.67/depthControl/
echo "Script End"

