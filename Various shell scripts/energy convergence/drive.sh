#!/bin/csh -f

set homeDir="/storage/home/vkb5066/scripts/energyConvChecker"

#write the energy tol to a file
if ($1 == "") then
        echo "enter an energy tol as an argument to this shell script"
        exit
else
        echo $1 >enTol
endif

#get the converged energy values from OUTCAR, put in file, check length of file (store in variable)
grep "free  energy" OUTCAR  >allThisEnergyOutput
set nLines=`wc -l < allThisEnergyOutput`

if ($nLines == 0) then
	echo "err" >>enOutput
	echo "err" >>enOutput
endif
if ($nLines > 0) then
	tail -2 allThisEnergyOutput >tmp
	sed -i 's/^.*= \(.*\) eV.*$/\1/p' tmp   #get rid of all but the numbers
head -1 tmp >enOutput
tail -1 tmp >>enOutput
endif

set nLines_=`wc -l enOutput`
cat enTol >enInfo
echo $nLines_ >>enInfo
cat enOutput >>enInfo

./energy

#print important info into a csv formatted file to be appended.  Append it
set here=`pwd`
set hereBoolValue=`sed '1q;d' result`
set hereEnDiff=`sed '2q;d' result`

if ($hereEnDiff == "") then
	set hereEnDiff="no output"
endif
	
if ($hereBoolValue == 0) then
	echo "$here,$hereBoolValue,$hereEnDiff" >hereCSVLine
	mv result /storage/home/vkb5066/scripts/energyConvChecker/nonConverged/enInfo
endif


#clean
rm tmp
rm enOutput
rm enInfo
rm enTol
rm allThisEnergyOutput
