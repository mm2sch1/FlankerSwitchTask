#ifndef GRAPH_H
#define GRAPH_H

#pragma once

#include <vector>
#include <stack>
#include <random>
#include <set>
#include <iostream>

using namespace std;

struct Edge {
	int from;
	int to;
	int c;
};

typedef int** Matrix;

class Graph {
public:
	Graph(int size, int num_classes);
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
	std::default_random_engine generator;

	int m_size;
	int m_num_classes;
	Matrix m_matrix;
	vector<int> m_grades_in;
	vector<int> m_grades_out;

	bool isPath(int from, int to);
	vector<Edge> getEdges(int from);
	Edge chooseEdge(int from);

	vector<int> vertexWeights;
	vector<int> edgeWeights;
};

#endif