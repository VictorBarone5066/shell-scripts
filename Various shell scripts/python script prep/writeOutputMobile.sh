#!/bin/csh

set origLoc=`pwd`
set dirControl="$origLoc/"
set maxDepth=10
set i=0
set add="*/"

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


echo "directory,energy,working directory (where POSCAR is),displacement from original positions,name for determining information,id Code,area,CAtoms,lat Const,xV,yV,zV" >$origLoc/output.csv


#Begin looping thorugh sub directories
while ($i < $maxDepth)

	foreach j ($dirControl)
		cd j
	
		if (((-f POSCAR) || (-f CONTCAR)) && (-f OUTCAR) && (-f ../USE12)) then

#do stuff here------------------------------------------------------------------------------

#Find energy...
grep "free  energy" OUTCAR | tail -1 >tmpEnergy
sed -i 's/^.*= \(.*\) eV.*$/\1/p' tmpEnergy
set nrg=`tail -1 tmpEnergy`
rm tmpEnergy

#Find working directory...
set wd=`echo "$j" | awk -F "/" '{print $(NF-1)}'`
   
#Determine if this file was generated before or after march (displacement values vary)
set pres=`pwd`

#Define displacements from original positions...
set disp=-99
#For files before march
if(!("$pres" =~ "*fter?arch*")) then
	set disp=`echo "0.005 * $wd - 0.02" | bc -l`	
#For files after march
else if("$pres" =~ "*fter?arch*") then
	set disp=`echo "0.010 * $wd - 0.02" | bc -l` 
endif

#Determine Defect Name
set defName=`echo "$j" | awk -F "/" '{print $(NF-2)}'`

#Find ID code
set id=`cat ../USE12`

#Done volume relaxing so lat vects between POS and CONT are the same.  
if (-f POSCAR) then
	cp POSCAR file__
endif
if (-f CONTCAR) then
	cp CONTCAR file__
endif

#Get the area of the supercell (without C++...oh boy)
set usf=`cat file__ | sed -n '2p'`
set ax=`cat file__ | sed -n '3p' | awk '{print $1}'`
set ay=`cat file__ | sed -n '3p' | awk '{print $2}'`
set az=`cat file__ | sed -n '3p' | awk '{print $3}'`
set bx=`cat file__ | sed -n '4p' | awk '{print $1}'`
set by=`cat file__ | sed -n '4p' | awk '{print $2}'`
set bz=`cat file__ | sed -n '4p' | awk '{print $3}'`
set cx=`cat file__ | sed -n '5p' | awk '{print $1}'`
set cy=`cat file__ | sed -n '5p' | awk '{print $2}'`
set cz=`cat file__ | sed -n '5p' | awk '{print $3}'`	#no trig functions (as far as I know) in bc, so need to explicitly write out the dot of the cross product
set vol=`echo ""$usf"*"$usf"*"$usf"*("$cx"*("$ay"*"$bz" - "$az"*"$by") + "$cy"*("$az"*"$bx" - "$ax"*"$bz") + "$cz"*("$ax"*"$by" - "$ay"*"$bx"))" | bc -l`
set area=`echo ""$vol"/sqrt("$cx"*"$cx" + "$cy"*"$cy" + "$cz"*"$cz")" | bc -l`

#Get the lattice vector lengths for later
set xV=`echo "sqrt("$ax"*"$ax" + "$ay"*"$ay" + "$az"*"$az")" | bc -l`
set yV=`echo "sqrt("$bx"*"$bx" + "$by"*"$by" + "$bz"*"$bz")" | bc -l`
set zV=`echo "sqrt("$cx"*"$cx" + "$cy"*"$cy" + "$cz"*"$cz")" | bc -l`

#Get number of carbon atoms
set cAtoms=`cat file__ | sed -n '7p'`

#Get lat constant for the x direction (I dont use this anymore)
set lat=`echo ""$xV"/6" | bc -l`

#Append all of this information to the csv line
echo "`pwd`,$nrg,$wd,$disp,$defName,$id,$area,$cAtoms,$lat,$xV,$yV,$zV" >>$origLoc/output.csv

rm file__

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

