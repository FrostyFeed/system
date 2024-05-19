#include <iostream>
#include <Windows.h>
#include <Lmcons.h>

int main() {
    WCHAR userName[UNLEN + 1]; // Use WCHAR for wide characters
    DWORD size = sizeof(userName) / sizeof(userName[0]);

    if (GetUserNameW(userName, &size)) { // Use GetUserNameW for wide characters
        std::cout << L"�������� ����������: " << userName << std::endl;
    }
    else {
        std::cerr << "�� ������� �������� ����� ��������� �����������." << std::endl;
    }

    return 0;
}
