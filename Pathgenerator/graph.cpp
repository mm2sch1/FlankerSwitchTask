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

void Graph::Dijkstra() {

}

bool Graph::isPath(int from, int to) {
	return (m_matrix[from][to] != 0);
}
