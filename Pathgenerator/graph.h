#ifndef GRAPH_H
#define GRAPH_H

#pragma once

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
	
	void Dijkstra();

private:
	int m_size;
	Matrix m_matrix;

	bool isPath(int from, int to);
};

#endif