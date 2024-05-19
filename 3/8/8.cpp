#include <iostream>
#include <Windows.h>
int main() {
	TCHAR systemDirectory[MAX_PATH];
	if (GetSystemDirectory(systemDirectory, MAX_PATH) > 0) {
		std::wcout << L"Поточний системний каталог: " << systemDirectory <<
			std::endl;
	}
	TCHAR tempPath[MAX_PATH];
	if (GetTempPath(MAX_PATH, tempPath) > 0) {
		std::wcout << L"Тимчасовий каталог: " << tempPath << std::endl;
	}
	TCHAR currentDirectory[MAX_PATH];
	if (GetCurrentDirectory(MAX_PATH, currentDirectory) > 0) {
		std::wcout << L"Поточний робочий каталог: " << currentDirectory <<
			std::endl;
	}
	return 0;
}