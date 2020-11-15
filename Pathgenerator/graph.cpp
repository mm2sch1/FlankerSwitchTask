#include "graph.h"

Graph::Graph(int size, int num_classes) {
	m_size = size;
	m_num_classes = num_classes;

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

vector<Edge> Graph::getEdges(int from) {
	vector<Edge> nodes;
	
	for (int j = 0; j < m_size; ++j) {
		if (m_matrix[from][j] > 0) {
			Edge edge;
			edge.from = from;
			edge.to = j;
			edge.c = m_matrix[from][j];
			nodes.push_back(edge);
		}
	}

	return nodes;
}

vector<int> Graph::search() {
	vertexWeights.resize(m_size);
	fill(vertexWeights.begin(), vertexWeights.end(), 0);

	edgeWeights.resize(m_num_classes);
	fill(edgeWeights.begin(), edgeWeights.end(), 8);

	vector<int> path;

	std::uniform_int_distribution<int> distribution(0, m_size - 1);
	int from = distribution(generator);
	
	path.push_back(from);
	for (int i = 0; i < 63; ++i) {
		Edge edge = chooseEdge(from);
		if (edge.c == -1) {
			break;
		}
		path.push_back(edge.to);
		from = edge.to;
	}

	return path;
}

bool Graph::isPath(int from, int to) {
	return (m_matrix[from][to] != 0);
}

Edge Graph::chooseEdge(int from) {
	Edge result;
	result.c = -1;
	vector<Edge> edges = getEdges(from);
	set<int> classes;

	for (int i = 0; i < edges.size(); i++)
		classes.insert(edges[i].c);

	int size = 0;
	for (auto it = classes.begin(); it != classes.end(); ++it) {
		int c = *it;
		size += edgeWeights[c-1];
	}

	if (size == 0)
		return result;

	std::uniform_int_distribution<int> distribution(0, size-1);
	int number = distribution(generator);
	
	int cnt = 0;
	int result_class = -1;
	for (auto it = classes.begin(); it != classes.end(); ++it) {
		int c = *it;
		cnt += edgeWeights[c-1];

		if (number < cnt) {
			result_class = c;
			break;
		}
	}

	if (result_class == -1)
		return result;

	vector<Edge> possibilities;
	for (int i = 0; i < edges.size(); i++) {
		if (edges[i].c == result_class)
			possibilities.push_back(edges[i]);
	}

	edgeWeights[result_class-1] /= 2;

	if (possibilities.size() > 0) {
		std::uniform_int_distribution<int> distribution2(0, possibilities.size() - 1);
		number = distribution2(generator);

		result = possibilities[number];
	}
	return result;
}