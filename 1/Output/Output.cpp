#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex> // для м'ютекса
using namespace std;
int main() {
	ifstream file("..//data.dat");
	if (!file.is_open()) {
		cout << "Помилка відкриття файлу!" << endl;
		return 1;
	}
	char ch;
	// Створення м'ютекса
	mutex mtx;
	while (file.get(ch)) {
		// Блокування м'ютекса перед доступом до спільних даних
		mtx.lock();
		if (ch == ' ') {
			cout << "*"; // Вивід символу '*' замість числа
		}
		else if (ch != '\n') {
			cout << ch;
		}
		else {
			cout << endl;
		}
		// Розблокування м'ютекса після завершення доступу до спільних даних
		mtx.unlock();
		// Затримка на 0.5 секунди
		this_thread::sleep_for(chrono::milliseconds(500));
	}
	file.close();
	return 0;
}