#include <Windows.h>
#include <iostream>
#include <string>
void PrintStartupPrograms(HKEY hKey) {
    HKEY hKeyRun;
    if (RegOpenKeyEx(hKey, L"Software\\Microsoft\\Windows\\CurrentVersion\\Run", 0, KEY_READ, &hKeyRun) == ERROR_SUCCESS) {
        DWORD dwIndex = 0;
        WCHAR szValueName[MAX_PATH];
        DWORD dwValueNameLen = MAX_PATH;
        BYTE lpData[MAX_PATH];
        DWORD dwDataLen = MAX_PATH;
        DWORD dwType = 0;

        while (RegEnumValue(hKeyRun, dwIndex, szValueName, &dwValueNameLen, NULL, &dwType, lpData, &dwDataLen) == ERROR_SUCCESS) {
            if (dwType == REG_SZ || dwType == REG_EXPAND_SZ) {
                std::wstring valueName(szValueName, dwValueNameLen);
                std::wstring valueData(reinterpret_cast<wchar_t*>(lpData), dwDataLen / sizeof(wchar_t));
                std::wcout << L"Program: " << valueName << L", Path: " << valueData << std::endl;
            }
            dwIndex++;
            dwValueNameLen = MAX_PATH;
            dwDataLen = MAX_PATH;
        }
        RegCloseKey(hKeyRun);
    }
    else {
        std::wcerr << L"Failed to open registry key." << std::endl;
    }
}
int main() {
	std::wcout << L"Startup programs for all users:" << std::endl;
	PrintStartupPrograms(HKEY_LOCAL_MACHINE);
	std::wcout << std::endl << L"Startup programs for current user:" <<std::endl;
	PrintStartupPrograms(HKEY_CURRENT_USER);
	return 0;
}