#include <stdio.h>

#include <iostream>
#include <vector>

using namespace std;

enum SLetter {
	S = 0,
	H = 1
};

struct SVertex {
	SLetter s;
	SLetter h;
};

int main() {
	vector<SVertex> V;
	SVertex v;
	v.s = S;
	v.h = H;
	V.push_back(v);

	cout << V[0].s << endl;
	getchar();
	return 0;
}