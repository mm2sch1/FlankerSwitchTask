#include <iostream>
#include <vector>
#include <string>
using namespace std;

enum Symbol {
	S,
	H 
};

enum Color {
	red,
	blue
};

enum Task {
	symbol,
	color
};

struct SVertex {
	Task task;
	Symbol sign;
	Symbol hint;
	Color csign;
	Color chint;

	void toString() {
		cout << "task: " << task << " sign: " << sign  <<" csign " << csign << " hint: " << hint << " chint: " << chint << endl;
	}
};

int initVertices(vector<SVertex> &vertices) {
	for (Task task : { symbol, color }) {
		for (Symbol sign : { S, H }) {
			for (Symbol hint : { S, H }) {
				for (Color csign : { red, blue }) {
					for (Color chint : { red, blue }) {
						SVertex v;
						v.task = task;
						v.sign = sign;
						v.hint = hint;
						v.csign = csign;
						v.chint = chint;

						vertices.push_back(v);
					}
				}
			}
		}
	}

	for (int i = 0; i < vertices.size(); i++) {
		cout << i << ": ";
		vertices[i].toString();
	}

	return vertices.size();
}

void initMatrix(int size, int** &m) {
	m = new int*[size];
	for (int i = 0; i < size; ++i)
		m[i] = new int[size];

	for (int i = 0; i < size; ++i) {
		for (int j = 0; j < size; ++j) {
			m[i][j] = 0;
		}
	}
}

void exitMatrix(int  size, int** &m) {
	for (int i = 0; i < size; ++i)
		delete[] m[i];
	delete[] m;
}

int getCase(SVertex &from, SVertex &to) {
	if (from.task == Task::symbol && from.task == to.task && from.sign == Symbol::S && from.sign == to.sign)
		return 1;
	if (from.task == Task::symbol && from.task == to.task && from.sign == Symbol::S && to.sign == Symbol::H)
		return 2;
	if (from.task == Task::symbol && from.task == to.task && from.sign == Symbol::H && to.sign == Symbol::S)
		return 3;
	if (from.task == Task::symbol && from.task == to.task && from.sign == Symbol::H && from.sign == to.sign)
		return 4;

	if (from.task == Task::color && from.task == to.task && from.csign == Color::red && from.csign == to.csign)
		return 5;
	if (from.task == Task::color && from.task == to.task && from.csign == Color::red && to.csign == Color::blue)
		return 6;
	if (from.task == Task::color && from.task == to.task && from.csign == Color::blue && to.csign == Color::red)
		return 7;
	if (from.task == Task::color && from.task == to.task && from.csign == Color::blue && from.csign == to.csign)
		return 8;

	if (from.task == Task::symbol && to.task == Task::color && from.sign == Symbol::S && to.csign == Color::red)
		return 9;
	if (from.task == Task::symbol && to.task == Task::color && from.sign == Symbol::S && to.csign == Color::blue)
		return 10;
	if (from.task == Task::symbol && to.task == Task::color && from.sign == Symbol::H && to.csign == Color::red)
		return 11;
	if (from.task == Task::symbol && to.task == Task::color && from.sign == Symbol::H && to.csign == Color::blue)
		return 12;

	if (from.task == Task::color && to.task == Task::symbol && from.csign == Color::red && to.sign == Symbol::S)
		return 13;
	if (from.task == Task::color && to.task == Task::symbol && from.csign == Color::red && to.sign == Symbol::H)
		return 14;
	if (from.task == Task::color && to.task == Task::symbol && from.csign == Color::blue && to.sign == Symbol::S)
		return 15;
	if (from.task == Task::color && to.task == Task::symbol && from.csign == Color::blue && to.sign == Symbol::H)
		return 16;

	cout << "no class" << endl;
	from.toString();
	to.toString();
	return 0;
}

void deepSearch(vector<SVertex> &vertices, int** &matrix, vector<int> &histogram) {
	int** weights = nullptr;
	int size = vertices.size();
	vector<int> vweights(size);

	initMatrix(size, weights);

	int vsize = 0;
	int pathsize = 64;
	vector<SVertex> path(pathsize);
	while (vsize != pathsize) {
		path[vsize] = vertices[vsize];
		vsize++;
	}

	exitMatrix(size, weights);
}

void chooseNextPath(vector<SVertex> &vertices, int** &matrix, vector<int> &histogram, int** &weights, vector<int> &vweights) {
	// geht morgen weiter
}

int main() {
	vector<SVertex> vertices;
	vector<int> histogram(16);
	int** matrix = nullptr;
	
	int size = initVertices(vertices);
	initMatrix(size, matrix);

	for (int i = 0; i < 16; i++)
		histogram[i] = 0;

	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			if (i == j) {
				matrix[i][j] = 0;
			} 
			else {
				SVertex from = vertices[i];
				SVertex to = vertices[j];
				int c = getCase(from, to);
				if (c > 0)
					histogram[c - 1]++;
				matrix[i][j] = c;
			}
		}
	}


	for (int i = 0; i < 16; i++)
		cout << "class " << i+1 << " : " << histogram[i] << endl;

	exitMatrix(size, matrix);
	

	getchar();
	return 0;
}