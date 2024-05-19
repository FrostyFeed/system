#include <iostream>
#include <fstream>
#include <cstdlib> // Для функцій rand() та srand()
#include <ctime> // Для функції time()

using namespace std;

const string FILE_NAME = "data.dat";
const int MIN_VALUE = 10;
const int MAX_VALUE = 100;
const int NUMBERS_COUNT = 20; // Змініть на 30, якщо потрібно

int main2() {
    srand(time(nullptr)); // Ініціалізуємо генератор випадкових чисел

    ofstream file(FILE_NAME, ios::binary | ios::out); // Відкриваємо файл для запису
    if (!file.is_open()) {
        cout << "Failed to open the file." << endl;
        return 1;
    }

    // Записуємо випадкові числа в файл
    for (int i = 0; i < NUMBERS_COUNT; ++i) {
        int randomNumber = rand() % (MAX_VALUE - MIN_VALUE + 1) + MIN_VALUE;
        file.write(reinterpret_cast<const char*>(&randomNumber), sizeof(int));
    }

    file.close(); // Закриваємо файл

    cout << "File \"" << FILE_NAME << "\" has been successfully created and filled with random numbers." << endl;

    return 0;
}
