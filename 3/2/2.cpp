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
                typeString = "Не відомий тип";
                break;
            case DRIVE_NO_ROOT_DIR:
                typeString = "Диск без кореневого каталогу";
                break;
            case DRIVE_REMOVABLE:
                typeString = "Видалний диск";
                break;
            case DRIVE_FIXED:
                typeString = "Фіксований диск";
                break;
            case DRIVE_REMOTE:
                typeString = "Мережевий диск";
                break;
            case DRIVE_CDROM:
                typeString = "CD-ROM";
                break;
            case DRIVE_RAMDISK:
                typeString = "RAM диск";
                break;
            default:
                typeString = "Невідомий";
            }
            std::wcout << letter << L":\\ - " << std::wstring(typeString.begin(), typeString.end()) << std::endl;
        }
        drives >>= 1;
    }
    return 0;
}
