#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <thread>
#include <mutex> // ��� �'������
using namespace std;
void sortArray(vector<int>& arr) {
	// ���������� ������
	sort(arr.begin(), arr.end());
}
int main() {
	ifstream file("..//data.dat");
	if (!file.is_open()) {
		cout << "������� �������� �����!" << endl;
		return 1;
	}
	vector<int> data;
	int temp;
	while (file >> temp) {
		data.push_back(temp);
	}
	file.close();
	// ��������� �'������
	mutex mtx;
	// ���������� �� ���������� ������ "�����" ��� ������� ����������
	cout << "�������� �����, ��� ������ ����������: ";
	char key = cin.get();
	if (key != ' ') {
		cout << "�� ���� ��������� ������!" << endl;
		return 1;
	}
	// ���������� �'������ ����� �������� �� ������� �����
	mtx.lock();
	// ���������� ������
	sortArray(data);
	// ������������� �'������ ���� ���������� ������� �� ������� �����
	mtx.unlock();
	// ��������� ����� � ������������ �������
	ofstream outputFile("..//data.dat"); // ������ ����� ����� �� data.dat
	if (!outputFile.is_open()) {
		cout << "������� �������� ����� ��� ������!" << endl;
		return 1;
	}
	for (int num : data) {
		outputFile << num << " ";
	}
	outputFile.close();
	cout << "������ ���������. ³��������� ��� ��������� � ���� 'data.dat'."
		<< endl;
	return 0;
}