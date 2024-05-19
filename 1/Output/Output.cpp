#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex> // ��� �'������
using namespace std;
int main() {
	ifstream file("..//data.dat");
	if (!file.is_open()) {
		cout << "������� �������� �����!" << endl;
		return 1;
	}
	char ch;
	// ��������� �'������
	mutex mtx;
	while (file.get(ch)) {
		// ���������� �'������ ����� �������� �� ������� �����
		mtx.lock();
		if (ch == ' ') {
			cout << "*"; // ���� ������� '*' ������ �����
		}
		else if (ch != '\n') {
			cout << ch;
		}
		else {
			cout << endl;
		}
		// ������������� �'������ ���� ���������� ������� �� ������� �����
		mtx.unlock();
		// �������� �� 0.5 �������
		this_thread::sleep_for(chrono::milliseconds(500));
	}
	file.close();
	return 0;
}