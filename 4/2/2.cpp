#include <Windows.h>
#include <iostream>
void AddToStartup(const std::wstring& appName, const std::wstring& appPath) {
	HKEY hKey;
	// Відкриття або створення ключа реєстру для поточного користувача
	if (RegOpenKeyEx(HKEY_CURRENT_USER,
		L"Software\\Microsoft\\Windows\\CurrentVersion\\Run", 0, KEY_SET_VALUE, &hKey)== ERROR_SUCCESS) {
		// Додавання або оновлення значення для ключа реєстру
		if (RegSetValueEx(hKey, appName.c_str(), 0, REG_SZ, (const
			BYTE*)appPath.c_str(), (appPath.size() + 1) * sizeof(wchar_t)) == ERROR_SUCCESS)
		{
			std::wcout << L"Програма успішно додана до автозавантаження для поточного користувача." << std::endl;
		}
		else {
			std::wcerr << L"Помилка додавання програми до автозавантаження." <<
				std::endl;
		}
		RegCloseKey(hKey);
	}
	else {
		std::wcerr << L"Помилка відкриття реєстру для додавання програми до автозавантаження." << std::endl;
	}
}
int main() {
	std::wstring appName = L"Microsoft Word"; // Ім'я, під яким додається програма до автозавантаження
		std::wstring appPath = L"C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE"; // Шлях до виконуваного файлу програми
		AddToStartup(appName, appPath);
	return 0;
}