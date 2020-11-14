#include "graph.h"

Graph::Graph(int size) {
	m_size = size;
	m_matrix = new int*[m_size];
	for (int i = 0; i < m_size; ++i)
		m_matrix[i] = new int[m_size];

	for (int i = 0; i < m_size; ++i) {
		for (int j = 0; j < m_size; ++j) {
			m_matrix[i][j] = 0;
		}
	}

	m_grades_in.resize(m_size);
	m_grades_out.resize(m_size);
}

Graph::~Graph() {
	for (int i = 0; i < m_size; ++i)
		delete[] m_matrix[i];
	delete[] m_matrix;
}

bool Graph::isSymmetric() {
	for (int i = 0; i < m_size; ++i) {
		for (int j = 0; j < m_size; j++) {
			if (m_matrix[i][j] != m_matrix[j][i])
				return false;
		}
	}

	return true;
}

bool Graph::isRegular() {
	for (int i = 0; i < m_size; ++i) {
		if (m_grades_in[i] != m_grades_out[i])
			return false;
	}

	return true;
}


void Graph::calcGrades() {
	for (int i = 0; i < m_size; ++i) {
		for (int j = 0; j < m_size; j++) {
			if (m_matrix[i][j] > 0) {
				m_grades_out[i]++;
				m_grades_in[j]++;
			}
		}
	}
}

vector<int> Graph::getNodes(int from) {
	vector<int> nodes;
	for (int j = 0; j < m_size; ++j) {
		if (m_matrix[from][j] > 0)
			nodes.push_back(j);
	}
	return nodes;
}

void Graph::search() {
	stack<int> stack;
	stack.push(0);


	while (!stack.empty()) {

	}
}

bool Graph::isPath(int from, int to) {
	return (m_matrix[from][to] != 0);
}