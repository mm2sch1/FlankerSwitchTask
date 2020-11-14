#ifndef GRAPH_H
#define GRAPH_H

#pragma once

#include <vector>
#include <stack>

using namespace std;

typedef int** Matrix;

class Graph {
public:
	Graph(int size);
	~Graph();

	Matrix& getMatrix() {
		return m_matrix;
	}

	const int& getSize() {
		return m_size;
	}

	bool isSymmetric();
	bool isRegular();
	
	void calcGrades();
	void search();

private:
	int m_size;
	Matrix m_matrix;
	vector<int> m_grades_in;
	vector<int> m_grades_out;

	bool isPath(int from, int to);
	vector<int> getNodes(int from);
};

#endif