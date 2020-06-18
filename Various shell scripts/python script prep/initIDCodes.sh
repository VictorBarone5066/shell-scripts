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

set pres=`pwd`

if ("$pres" =~ "*ure*") then
	echo "0" >../USE12
else if("$pres" =~ "*ingle?ac*") then
	echo "1" >../USE12
else if(("$pres" =~ "*i?ac*") && !("$pres" =~ "*fter?arch*")) then
	echo "2" >../USE12
else if(("$pres" =~ "*i?ac*") && ("$pres" =~ "*fter?arch*")) then
	echo "3" >../USE12
else if("$pres" =~ "*555777*") then
	echo "4" >../USE12
else if(("$pres" =~ "*tone*ine*") && !("$pres" =~ "*fter?arch*")) then
	echo "5" >../USE12
else if(("$pres" =~ "*tone*ine*") && ("$pres" =~ "*fter?arch*")) then
	echo "6" >../USE12
endif

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

