#include <fstream>
#include <cmath>

std::string energyPath = "enInfo";
std::string outfilePath = "result";

int main()
{
	std::ifstream infile (energyPath.c_str());
	std::ofstream outfile (outfilePath.c_str());

	double tol;
	double nLines;
	bool ok;
	double diff;

	double e1, e2;
	
	infile >> tol;
	infile >> nLines;

	getline(infile, *new std::string); //get rid of extra stuff

	if (nLines == 0)
	{
		ok = false;
		return 0;
	}
	else
		if (nLines == 1)
		{
			diff = 0;
			ok = true;
		}
		else
			if (nLines > 1)
			{
				infile >> e1;
				infile >> e2;
				diff = std::abs(std::abs(e1)-std::abs(e2)); 
			}

	if (diff < tol)
		ok = true;
	else 
		ok = false;

	outfile << ok << "\n";
	outfile << diff;
	outfile.close();

	return 0;
}
