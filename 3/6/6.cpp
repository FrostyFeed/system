#include <iostream>
#include <Windows.h>
int main() {
	TCHAR computerName[MAX_COMPUTERNAME_LENGTH + 1];
	DWORD size = sizeof(computerName) / sizeof(computerName[0]);
	if (GetComputerName(computerName, &size)) {
		std::wcout << L"����� ����'�����: " << computerName << std::endl;
	}
	else {
		std::cerr << "�� ������� �������� ����� ����'�����." << std::endl;
	}
	return 0;
}