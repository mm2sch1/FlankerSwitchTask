#include <iostream>
#include <vector>
#include <string>
#include <fstream>

#include "graph.h"

using namespace std;

enum Symbol { S, H };
enum Color { red, blue };
enum Task { symbol, color };

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

void writePathesToFile(string filename, vector<vector<int> > &pathes) {
	ofstream file;
	file.open(filename);

	int size = pathes.size();
	for (int i = 0; i < size; ++i) {
		int psize = pathes[i].size()-1;

		for (int v = 0; v < psize; ++v) {
			file << pathes[i][v] << ";";
		}
		file << pathes[i][psize] << "\n";
	}

	file.close();
}

int main() {
	vector<SVertex> vertices;
	vector<int> histogram(16);
	vector<vector<Edge> > edges(16);
	
	int size = initVertices(vertices);

	Graph graph(size, 16);
	Matrix matrix = graph.getMatrix();

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
				if (c > 0) {
					histogram[c - 1]++;
					Edge edge;
					edge.from = i;
					edge.to = j;
					edge.c = c;
					edges[c - 1].push_back(edge);
				}
				matrix[i][j] = c;
			}
		}
	}
	
	vector<vector<int> > pathes;
	int cnt = 0;
	while (cnt < 1000) {
		vector<int> path = graph.search();
		if (path.size() == 64) {
			pathes.push_back(path);
			cout << "Path found " << cnt << endl;
			cnt++;
		}
	}

	writePathesToFile("out.csv", pathes);

	getchar();
	return 0;
}