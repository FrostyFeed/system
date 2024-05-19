#include <iostream>
#include <Windows.h>
int main() {
	MEMORYSTATUSEX memoryStatus;
	memoryStatus.dwLength = sizeof(memoryStatus);
	if (GlobalMemoryStatusEx(&memoryStatus)) {
		std::cout << "Фізична пам'ять:" << std::endl;
		std::cout << "Загальний обсяг: " << memoryStatus.ullTotalPhys << " байт"
			<< std::endl;
		std::cout << "Вільно: " << memoryStatus.ullAvailPhys << " байт" <<
			std::endl;
		std::cout << "Використано: " << memoryStatus.ullTotalPhys -
			memoryStatus.ullAvailPhys << " байт" << std::endl;
		std::cout << std::endl;
		std::cout << "Віртуальна пам'ять:" << std::endl;
		std::cout << "Загальний обсяг: " << memoryStatus.ullTotalVirtual << " байт" << std::endl;
			std::cout << "Вільно: " << memoryStatus.ullAvailVirtual << " байт" <<
			std::endl;
		std::cout << "Використано: " << memoryStatus.ullTotalVirtual -
			memoryStatus.ullAvailVirtual << " байт" << std::endl;
	}
	else {
		std::cerr << "Не вдалося отримати інформацію про системну пам'ять." <<
			std::endl;
	}
	return 0;
}