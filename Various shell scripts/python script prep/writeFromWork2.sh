#!/bin/csh

set dirControl="/storage/work/vkb5066/"
set maxDepth=11
set i=0
set add="*/"
set file=/OUTCAR

rm output.csv
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

							#important:  'displacement from...' will be referred to as 'strain' in this (and most other code written before 5/21/19)
echo "directory,energy,working directory (where POSCAR is),displacement from original positions,name for determining information,id Code,area,CAtoms,xV,yV,zV" >/storage/home/vkb5066/scripts/writeOutput/output.csv
while ($i < $maxDepth)

	foreach j ($dirControl)
		#echo $j
		cd j
	
		if (-f OUTCAR) then
			cd ../

			if (-f USE2) then
				set id=`cat USE2`
				cd -

				#echo "OUTCAR found in `pwd` !"
				set strain=-99

				#Get all free energy values, only take the last (most recent) one, store it in tmp file
				grep "TOTEN" OUTCAR >tmp  
				tail -1 tmp >tmp2
				rm tmp				

				#Use sed magic, store energy value in another tmp file
				sed -i 's/^.*= \(.*\) eV.*$/\1/p' tmp2   #this command is disgusting and i have no idea how it works
				tail -1 tmp2 >tmp
				rm tmp2

				#Store energy in variable for use later
				set NRG=`cat tmp`

				#Find Strain
				set k=`echo "$j" | awk -F "/" '{print $(NF-1)}'`
			
				#Determine Name
				set m=`echo "$j" | awk -F "/" '{print $(NF-2)}'`
				
				#Determining strain (make any new files write strain in the top comment line to avoid needing this)
       				if ($k == 0 || $k == 0.975) then
	       			set strain="-0.025"
       		 		endif
       		 		if ($k == 1 || $k == 0.980) then
        			set strain="-0.020"
        			endif
        			if ($k == 2 || $k == 0.985) then
        			set strain="-0.015"
        			endif
        			if ($k == 3 || $k == 0.990) then
        			set strain="-0.010"
        			endif
        			if ($k == 4 || $k == 0.995) then
        			set strain="-0.005"
        			endif
        			if ($k == 5 || $k == 1.000) then
        			set strain="0.00"
        			endif
        			if ($k == 6 || $k == 1.005) then
        			set strain="0.005"
        			endif
        			if ($k == 7 || $k == 1.010) then
        			set strain="0.010"
        			endif
        			if ($k == 8 || $k == 1.015) then
        			set strain="0.015"
        			endif
        			if ($k == 9 || $k == 1.020) then
        			set strain="0.020"
        			endif
        			if ($k == 10 || $k == 1.025) then
        			set strain="0.025"
        			endif

				#more special cases: extra points:
				if ($k == 4.5) then
				set strain="-0.0025"
				endif
				if ($k == -1) then
				set strain="-0.030"
				endif
				if ($k == -2) then
				set strain="-0.035"
				endif
				if ($k == -3) then
				set strain="-0.040"
				endif
				if ($k == 11) then
				set strain="0.030"
				endif
				if ($k == 12) then
				set strain="0.035"
				endif
				
				cp CONTCAR /storage/home/vkb5066/scripts/writeOutput/POSCAR
				set PWD=`pwd`
				cd /storage/home/vkb5066/scripts/writeOutput/
                                ./a.out

				echo "$PWD,$NRG,$k,$strain,$m,$id,`cat area`,`cat nAtoms`,`cat xVect`,`cat yVect`,`cat zVect`" >>/storage/home/vkb5066/scripts/writeOutput/output.csv
				rm nAtoms
				rm area
				rm xVect
				rm yVect
				rm zVect
				cp POSCAR /storage/home/vkb5066/scripts/writeOutput/poscars/POSCAR$m
                                rm POSCAR
				
				cd -
			
			endif
		cd ../
		endif
	end

set dirControl="$dirControl$add"
@ i++
end
echo "endf,1,1,1,endf,-1,1,-1" >>/storage/home/vkb5066/scripts/writeOutput/output.csv
echo "you should not see this" >/storage/home/vkb5066/scripts/writeOutput/poscars/POSCARendf

rm -r /storage/work/vkb5066/depthControl/
echo "Script End"

