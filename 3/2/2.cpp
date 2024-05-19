#include <iostream>
#include <Windows.h>
#include <string>

int main() {
    DWORD drives = GetLogicalDrives();
    for (char letter = 'A'; letter <= 'Z'; ++letter) {
        if (drives & 1) {
            std::wstring drive = std::wstring(1, letter) + L":\\";
            DWORD driveType = GetDriveType(drive.c_str());
            std::string typeString;
            switch (driveType) {
            case DRIVE_UNKNOWN:
                typeString = "�� ������ ���";
                break;
            case DRIVE_NO_ROOT_DIR:
                typeString = "���� ��� ���������� ��������";
                break;
            case DRIVE_REMOVABLE:
                typeString = "�������� ����";
                break;
            case DRIVE_FIXED:
                typeString = "Գ�������� ����";
                break;
            case DRIVE_REMOTE:
                typeString = "��������� ����";
                break;
            case DRIVE_CDROM:
                typeString = "CD-ROM";
                break;
            case DRIVE_RAMDISK:
                typeString = "RAM ����";
                break;
            default:
                typeString = "��������";
            }
            std::wcout << letter << L":\\ - " << std::wstring(typeString.begin(), typeString.end()) << std::endl;
        }
        drives >>= 1;
    }
    return 0;
}
