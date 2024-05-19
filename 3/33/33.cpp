#include <iostream>
#include <Windows.h>
#include <string>
int main() {
	DWORD drives = GetLogicalDrives();
	for (char letter = 'A'; letter <= 'Z'; ++letter) {
		if (drives & 1) {
			std::string drive = std::string(1, letter) + ":\\";
			char volumeName[MAX_PATH + 1] = { 0 };
			char fileSystemName[MAX_PATH + 1] = { 0 };
			DWORD serialNumber = 0;
			DWORD maxComponentLength = 0;
			DWORD fileSystemFlags = 0;
			if (GetVolumeInformationA(drive.c_str(), volumeName,
				sizeof(volumeName), &serialNumber, &maxComponentLength, &fileSystemFlags,
				fileSystemName, sizeof(fileSystemName))) {
				std::cout << "Диск " << letter << ":\\ - ";
				std::cout << "Назва тома: " << volumeName << ", ";
				std::cout << "Серійний номер: " << serialNumber << ", ";
				std::cout << "Файлова система: " << fileSystemName << std::endl;
			}
		}
		drives >>= 1;
	}
	return 0;
}
