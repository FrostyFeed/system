#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <thread>
#include <mutex> // для м'ютекса
using namespace std;
void sortArray(vector<int>& arr) {
	// Сортування масиву
	sort(arr.begin(), arr.end());
}
int main() {
	ifstream file("..//data.dat");
	if (!file.is_open()) {
		cout << "Помилка відкриття файлу!" << endl;
		return 1;
	}
	vector<int> data;
	int temp;
	while (file >> temp) {
		data.push_back(temp);
	}
	file.close();
	// Створення м'ютекса
	mutex mtx;
	// Очікування на натискання клавіші "пробіл" для початку сортування
	cout << "Натисніть пробіл, щоб почати сортування: ";
	char key = cin.get();
	if (key != ' ') {
		cout << "Не вірно натиснута клавіша!" << endl;
		return 1;
	}
	// Блокування м'ютекса перед доступом до спільних даних
	mtx.lock();
	// Сортування масиву
	sortArray(data);
	// Розблокування м'ютекса після завершення доступу до спільних даних
	mtx.unlock();
	// Оновлення файлу з відсортованим масивом
	ofstream outputFile("..//data.dat"); // Змінено назву файлу на data.dat
	if (!outputFile.is_open()) {
		cout << "Помилка відкриття файлу для запису!" << endl;
		return 1;
	}
	for (int num : data) {
		outputFile << num << " ";
	}
	outputFile.close();
	cout << "Робота завершена. Відсортовані дані збережено у файлі 'data.dat'."
		<< endl;
	return 0;
}