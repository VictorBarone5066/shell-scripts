#!/bin/csh

set dirControl="/gpfs/scratch/vkb5066/dosVacResults/"
set maxDepth=11
set i=0
set add="*/"
set file=/OUTCAR

rm outputM.csv
rm -r poscars
mkdir poscars

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

echo "directory,energy,working directory (where POSCAR is),displacement from original positions,name for determining information,id Code,area,CAtoms,lat Const,xV,yV,zV,mag" >/storage/home/vkb5066/scripts/writeOutput/outputM.csv
while ($i < $maxDepth)

	foreach j ($dirControl)
		#echo $j
		cd j
	
		if (-f OUTCAR) then
			cd ../

			if (-f USEMAG) then
				set id=`cat USEMAG`
				cd -

				#echo "OUTCAR found in `pwd` !"
				set strain=-99
				set mag=-99
				
				#Get all free energy values, only take the last (most recent) one, store it in tmp file
				grep "TOTEN" OUTCAR >tmp  
				tail -1 tmp >tmp2
				rm tmp				

				#Use sed magic, store energy value in another tmp file
				sed -i 's/^.*= \(.*\) eV.*$/\1/p' tmp2   #now I understand why taking comp sci counts as a foreign language
				tail -1 tmp2 >tmp
				rm tmp2

				#Store energy in variable for use later
				set NRG=`cat tmp`

				#Get all mag values, only take the last (most recent) one, store
				grep "magnetization" OUTCAR >tmpMag
				tail -1 tmpMag >tmpMag2
				rm tmpMag
			
				#Use sed magic to only grab the numerical value for mag
				sed -i 's/^.*magnetization \(.*\).$/\1/p' tmpMag2
				tail -1 tmpMag2 >tmpMag
				rm tmpMag2
				set mag=`cat tmpMag`

				#Find Strain
				set k=`echo "$j" | awk -F "/" '{print $(NF-1)}'`
			
				#Determine Name
				set m=`echo "$j" | awk -F "/" '{print $(NF-2)}'`

				#Determining strain (make any new files write strain in the top comment line to avoid needing this)
       				if ($k == 0) then
	       			set strain="-0.02"
       		 		endif
       		 		if ($k == 1) then
        			set strain="-0.015"
        			endif
        			if ($k == 2) then
        			set strain="-0.010"
        			endif
        			if ($k == 3) then
        			set strain="-0.005"
        			endif
        			if ($k == 4) then
        			set strain="0.0"
        			endif
        			if ($k == 5) then
        			set strain="0.005"
        			endif
        			if ($k == 6) then
        			set strain="0.010"
        			endif
        			if ($k == 7) then
        			set strain="0.015"
        			endif
        			if ($k == 8) then
        			set strain="0.020"
        			endif

				#Extra cases
				if ($k == 1.5) then
				set strain="-0.0125"
				endif
				if ($k == 9) then
				set strain="0.025"
				endif
				if ($k == 10) then
				set strain="0.030"
				endif
				
				if (-f POSCAR) then
					cp POSCAR /storage/home/vkb5066/scripts/writeOutput/POSCAR
				else	
					echo "POSCAR not found in `pwd`"
					sleep 2
				endif
			
				set small=-1
				set big=-1
	
				set PWD=`pwd`
				cd /storage/home/vkb5066/scripts/writeOutput/
				if (-f POSCAR) then
                                	./a.out

					#Find the new lattice constant - lattice vector X divided by num rings (6)
        	                        set big=`sed -n '3p' POSCAR | awk '{print $1;}'`
	                                set small=`echo "$big * 0.16666666667" | bc -l`
				else
					echo "No POSCAR - I'll write what I can."
				endif

				#append data to csv, and clean up directory
				echo "$PWD,$NRG,$k,$strain,$m,$id,`cat area`,`cat nAtoms`,$small,`cat xVect`,`cat yVect`,`cat zVect`,$mag" >>/storage/home/vkb5066/scripts/writeOutput/outputM.csv
				rm nAtoms
				rm area
				cp POSCAR /storage/home/vkb5066/scripts/writeOutput/poscars/POSCAR$m
                                rm POSCAR

				rm xVect
				rm yVect
				rm zVect

				cd -
			
			endif
		cd ../
		endif
	end

set dirControl="$dirControl$add"
@ i++
end
echo "endf,1,1,1,endf,-1,1,-1,-1" >>/storage/home/vkb5066/scripts/writeOutput/outputM.csv
echo "you should not see this" >/storage/home/vkb5066/scripts/writeOutput/poscars/POSCARendf

rm -r /gpfs/scratch/vkb5066/dosVacResults/depthControl/ 
echo "Script End"

