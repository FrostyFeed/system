
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
using namespace std;
int main() {
	// ³�������� ���� ��� ������
	ofstream file("..//data.dat");
	// ����������, �� ���� ������� �������
	if (!file.is_open()) {
		cout << "������� �������� ����� ��� ������!" << endl;
		return 1;
	}
	// ������������ ������� ���������� ���������� ����� ������� �� ���������
		srand(time(0));
	// �������� ��������� ������� ����� � ������� �� 20 �� 30
	int count = rand() % 11 + 20;
	// �������� �� �������� �������� ����� � ����
	for (int i = 0; i < count; ++i) {
		// �������� ��������� ����� � ������� �� 10 �� 100
		int number = rand() % 91 + 10;
		// �������� ����� � ����
		file << number << " ";
	}
	// ��������� ����
	file.close();
	cout << "���� ������ ��������� ����������� �������." << endl;
	return 0;
}
