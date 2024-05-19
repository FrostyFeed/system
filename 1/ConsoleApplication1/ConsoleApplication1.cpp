
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
using namespace std;
int main() {
	// Відкриваємо файл для запису
	ofstream file("..//data.dat");
	// Перевіряємо, чи файл вдалося відкрити
	if (!file.is_open()) {
		cout << "Помилка відкриття файлу для запису!" << endl;
		return 1;
	}
	// Встановлюємо початок генератора випадкових чисел залежно від поточного
		srand(time(0));
	// Генеруємо випадкову кількість чисел в діапазоні від 20 до 30
	int count = rand() % 11 + 20;
	// Генеруємо та записуємо випадкові числа в файл
	for (int i = 0; i < count; ++i) {
		// Генеруємо випадкове число в діапазоні від 10 до 100
		int number = rand() % 91 + 10;
		// Записуємо число у файл
		file << number << " ";
	}
	// Закриваємо файл
	file.close();
	cout << "Файл успішно заповнено випадковими числами." << endl;
	return 0;
}
