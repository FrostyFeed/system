#include <iostream>
#include <Windows.h>
#include <string>
int main() {
	DWORD drives = GetLogicalDrives();
	for (char letter = 'A'; letter <= 'Z'; ++letter) {
		if (drives & 1) {
			std::string drive = std::string(1, letter) + ":\\";
			ULARGE_INTEGER freeBytesAvailable;
			ULARGE_INTEGER totalNumberOfBytes;
			ULARGE_INTEGER totalNumberOfFreeBytes;
			if (GetDiskFreeSpaceExA(drive.c_str(), &freeBytesAvailable,
				&totalNumberOfBytes, &totalNumberOfFreeBytes)) {
				std::cout << "���� " << letter << ":\\ - ";
				std::cout << "³����: " << freeBytesAvailable.QuadPart << " ����, ";
					std::cout << "�������: " << totalNumberOfBytes.QuadPart << " ����" << std::endl;
			}
		}
		drives >>= 1;
	}
	return 0;
}