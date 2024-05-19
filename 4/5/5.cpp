#include <windows.h>
#include <stdio.h>
// Функція для копіювання розділу реєстру у файл формату .reg
void CopyRegistryKeyToFile(const wchar_t* keyPath, const wchar_t* filePath) {
	// Відкриття розділу реєстру для читання
	HKEY hKey;
	if (RegOpenKeyEx(HKEY_CURRENT_USER, keyPath, 0, KEY_READ, &hKey) !=
		ERROR_SUCCESS) {
		printf("Помилка відкриття розділу реєстру.\n");
		return;
	}
	// Відкриття файлу для запису
	FILE* file;
	if (_wfopen_s(&file, filePath, L"w") != 0) {
		printf("Помилка відкриття файлу.\n");
		RegCloseKey(hKey);
		return;
	}
	// Запис у файл заголовку формату .reg
	fwprintf(file, L"Windows Registry Editor Version 5.00\n\n");
	fwprintf(file, L"[%s]\n", keyPath);
	// Зчитування та запис кожного значення реєстру у файл
	wchar_t valueName[255];
	DWORD valueNameSize = sizeof(valueName) / sizeof(valueName[0]);
	DWORD valueType;
	BYTE valueData[4096];
	DWORD valueDataSize = sizeof(valueData);
	for (DWORD i = 0; ; i++) {
		valueDataSize = sizeof(valueData);
		valueNameSize = sizeof(valueName);
		if (RegEnumValue(hKey, i, valueName, &valueNameSize, NULL, &valueType,
			valueData, &valueDataSize) != ERROR_SUCCESS) {
			break;
		}
		// Перевірка типу значення
		const wchar_t* valueTypeStr = L"";
		switch (valueType) {
		case REG_SZ:
			valueTypeStr = L"\"";
			break;
		case REG_DWORD:
			valueTypeStr = L"dword:";
			break;
			// Додаткові перевірки можна додати для інших типів значень
		}
		// Запис значення у файл
		fwprintf(file, L"%s%s=%s\n", valueName, valueTypeStr, valueData);
	}
	// Закриття розділу реєстру та файлу
	RegCloseKey(hKey);
	fclose(file);
}
int main() {
	// Шлях до розділу реєстру та файлу для збереження
	const wchar_t* keyPath =
		L"Software\\Microsoft\\Windows\\CurrentVersion\\Run";
	const wchar_t* filePath = L"C:\\Temp\\RegistryBackup.reg";
	// Виклик функції копіювання розділу реєстру у файл
	CopyRegistryKeyToFile(keyPath, filePath);
	printf("Розділ реєстру успішно скопійовано у файл %ls.\n", filePath);
	return 0;
}