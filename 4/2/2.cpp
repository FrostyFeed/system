#include <Windows.h>
#include <iostream>
void AddToStartup(const std::wstring& appName, const std::wstring& appPath) {
	HKEY hKey;
	// ³������� ��� ��������� ����� ������ ��� ��������� �����������
	if (RegOpenKeyEx(HKEY_CURRENT_USER,
		L"Software\\Microsoft\\Windows\\CurrentVersion\\Run", 0, KEY_SET_VALUE, &hKey)== ERROR_SUCCESS) {
		// ��������� ��� ��������� �������� ��� ����� ������
		if (RegSetValueEx(hKey, appName.c_str(), 0, REG_SZ, (const
			BYTE*)appPath.c_str(), (appPath.size() + 1) * sizeof(wchar_t)) == ERROR_SUCCESS)
		{
			std::wcout << L"�������� ������ ������ �� ���������������� ��� ��������� �����������." << std::endl;
		}
		else {
			std::wcerr << L"������� ��������� �������� �� ����������������." <<
				std::endl;
		}
		RegCloseKey(hKey);
	}
	else {
		std::wcerr << L"������� �������� ������ ��� ��������� �������� �� ����������������." << std::endl;
	}
}
int main() {
	std::wstring appName = L"Microsoft Word"; // ��'�, �� ���� �������� �������� �� ����������������
		std::wstring appPath = L"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE"; // ���� �� ������������ ����� ��������
		AddToStartup(appName, appPath);
	return 0;
}