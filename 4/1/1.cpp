#include <Windows.h>
#include <iostream>
#include <string>
void PrintTasks(HKEY hKey) {
	DWORD index = 0;
	TCHAR szSubKeyName[256];
	DWORD dwSize = ARRAYSIZE(szSubKeyName);
	while (RegEnumKeyEx(hKey, index++, szSubKeyName, &dwSize, NULL, NULL, NULL,
		NULL) == ERROR_SUCCESS) {
		std::wcout << szSubKeyName << std::endl;
		dwSize = ARRAYSIZE(szSubKeyName);
	}
}
int main() {
	// Для всіх користувачів
	HKEY hKeyAllUsers;
	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, L"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Schedule\\TaskCache\\Tasks", 0, KEY_READ, &hKeyAllUsers) ==ERROR_SUCCESS) {
		std::wcout << L"Tasks for all users:" << std::endl;
			PrintTasks(hKeyAllUsers);
			RegCloseKey(hKeyAllUsers);
	}
	// Для поточного користувача
	HKEY hKeyCurrentUser;
		if (RegOpenKeyEx(HKEY_CURRENT_USER, L"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Schedule\\TaskCache\\Tasks", 0, KEY_READ, &hKeyCurrentUser)== ERROR_SUCCESS) {
			std::wcout << L"Tasks for current user:" << std::endl;
				PrintTasks(hKeyCurrentUser);
				RegCloseKey(hKeyCurrentUser);
		}
	return 0;
}