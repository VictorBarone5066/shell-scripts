#!/bin/csh -f

set homeDir="/storage/home/vkb5066/scripts/forceChecker"

#write the force tol to a file
if ($1 == "") then
        echo "enter a force tol as an argument to this shell script"
        exit
else
        echo $1 >forceTol
endif

#Find nAtoms
./nAtomsCPP

#read nAtoms into a variable, use it to grap the correct number of lines from OUTCAR
set numAtoms=`cat nAtoms`

@ numAtoms++
grep "TOTAL-FORCE" OUTCAR -A $numAtoms >allThisForceOutput_
@ numAtoms--

tail -$numAtoms allThisForceOutput_ >allThisForceOutput

#Print the results from the clean force output
./everythingElse

#print important info into a csv formatted file to be appended.  Append it
set here=`pwd`
set hereBoolValue=`sed '2q;d' forceInfo`
set hereMaxForce=`sed '4q;d' forceInfo`
if ($hereBoolValue == 0) then
	echo "$here,$hereBoolValue,$hereMaxForce" >hereCSVLine
	cp forceInfo /storage/home/vkb5066/scripts/forceChecker/highForces/forceInfo
endif


#clean
rm allThisForceOutput*
rm nAtoms
rm forceTol

