#include <iostream>
#include <Windows.h>
int main() {
	MEMORYSTATUSEX memoryStatus;
	memoryStatus.dwLength = sizeof(memoryStatus);
	if (GlobalMemoryStatusEx(&memoryStatus)) {
		std::cout << "Գ����� ���'���:" << std::endl;
		std::cout << "��������� �����: " << memoryStatus.ullTotalPhys << " ����"
			<< std::endl;
		std::cout << "³����: " << memoryStatus.ullAvailPhys << " ����" <<
			std::endl;
		std::cout << "�����������: " << memoryStatus.ullTotalPhys -
			memoryStatus.ullAvailPhys << " ����" << std::endl;
		std::cout << std::endl;
		std::cout << "³�������� ���'���:" << std::endl;
		std::cout << "��������� �����: " << memoryStatus.ullTotalVirtual << " ����" << std::endl;
			std::cout << "³����: " << memoryStatus.ullAvailVirtual << " ����" <<
			std::endl;
		std::cout << "�����������: " << memoryStatus.ullTotalVirtual -
			memoryStatus.ullAvailVirtual << " ����" << std::endl;
	}
	else {
		std::cerr << "�� ������� �������� ���������� ��� �������� ���'���." <<
			std::endl;
	}
	return 0;
}