#include <iostream>
#include <Windows.h>
int main() {
	TCHAR computerName[MAX_COMPUTERNAME_LENGTH + 1];
	DWORD size = sizeof(computerName) / sizeof(computerName[0]);
	if (GetComputerName(computerName, &size)) {
		std::wcout << L"Назва комп'ютера: " << computerName << std::endl;
	}
	else {
		std::cerr << "Не вдалося отримати назву комп'ютера." << std::endl;
	}
	return 0;
}