#include <windows.h>
#include <stdio.h>
// ������� ��� ��������� ������ ������ � ���� ������� .reg
void CopyRegistryKeyToFile(const wchar_t* keyPath, const wchar_t* filePath) {
	// ³������� ������ ������ ��� �������
	HKEY hKey;
	if (RegOpenKeyEx(HKEY_CURRENT_USER, keyPath, 0, KEY_READ, &hKey) !=
		ERROR_SUCCESS) {
		printf("������� �������� ������ ������.\n");
		return;
	}
	// ³������� ����� ��� ������
	FILE* file;
	if (_wfopen_s(&file, filePath, L"w") != 0) {
		printf("������� �������� �����.\n");
		RegCloseKey(hKey);
		return;
	}
	// ����� � ���� ��������� ������� .reg
	fwprintf(file, L"Windows Registry Editor Version 5.00\n\n");
	fwprintf(file, L"[%s]\n", keyPath);
	// ���������� �� ����� ������� �������� ������ � ����
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
		// �������� ���� ��������
		const wchar_t* valueTypeStr = L"";
		switch (valueType) {
		case REG_SZ:
			valueTypeStr = L"\"";
			break;
		case REG_DWORD:
			valueTypeStr = L"dword:";
			break;
			// �������� �������� ����� ������ ��� ����� ���� �������
		}
		// ����� �������� � ����
		fwprintf(file, L"%s%s=%s\n", valueName, valueTypeStr, valueData);
	}
	// �������� ������ ������ �� �����
	RegCloseKey(hKey);
	fclose(file);
}
int main() {
	// ���� �� ������ ������ �� ����� ��� ����������
	const wchar_t* keyPath =
		L"Software\\Microsoft\\Windows\\CurrentVersion\\Run";
	const wchar_t* filePath = L"C:\\Temp\\RegistryBackup.reg";
	// ������ ������� ��������� ������ ������ � ����
	CopyRegistryKeyToFile(keyPath, filePath);
	printf("����� ������ ������ ���������� � ���� %ls.\n", filePath);
	return 0;
}