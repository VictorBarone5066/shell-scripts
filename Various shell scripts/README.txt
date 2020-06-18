Shell scripts written in csh.  Intended to be used with VASP output files, although some can be edited for general purpose use.  The newest files are more for general usage

'python script prep' is the most specific.  Used for walking down a directory tree and adding data necessary for calculating elastic and magnetic properties to a file to be read by python code.  
INPUT:  nothing - but the directories must be formatted in the following way:
	<anything>
	USE	<folders a through z>	
	folder n:
		POSCAR	INCAR	KPOINTS	POTCAR	<anything>

	where USE is a file containing a number corresponding to the type of defect POSCAR has.
OUTPUT:	a csv file, 'output.csv', containing all necessary information for calculating properties.
	a folder, 'poscars/', which contains one of each type of defect and strain POSCAR file that the script found


'energy convergence' and 'force convergence' are scripts that walk down the directory tree and list all files that
a. have a difference in converged energy steps above a specific energy cutoff, or
b. have an atom whose forces are above a certian force cutoff.
INPUT: 	the energy cutoff (in eV), or the force tol for a single atom.
OUTPUT:	a csv file listing all visited directories, energies / forces, and whether or not the energy of highest force atom of that file is below the desired tolerance.  
	a folder of files that exceed the energy or force tolerance

'reSub' is a general script that walks down a directory tree starting from the place the script is at, and submits jobs through PBS based on the files existing inside each existing directory.  No input or output.  The current implementation is to re-submit jobs for second runs, but it could be used for anything - just change the lines of code between the two comments which give directions on where to start and stop writing.

'mkFiles' is specific to the elastic and magnetic properties stuff - it creates directory trees for 3 types of strain and prepares for file submission with minimal set-up.  No input or output, but the executables to create strained files must be named 'strain<anything>'.


