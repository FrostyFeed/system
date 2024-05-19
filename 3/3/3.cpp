#include <iostream>
#include <Windows.h>
int main() {
	DWORD drives = GetLogicalDrives();
	for (char letter = 'A'; letter <= 'Z'; ++letter) {
		if (drives & 1) {
			std::cout << letter << ":\\" << std::endl;
		}
		drives >>= 1;
	}
	return 0;
}
