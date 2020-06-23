;============Keyboard controller setup============
;push eax
;mov al, 0x20
;out 0x64, al;Read configuration command
;in al, 0x60
;btr ax, 6;Set translation bit to 0
;push ax;Configuration in stack

;mov al, 0x60;Send configuration byte command
;out 0x64, al

;pop ax;Configuration in ax(al)
;out 0x60, al;Send configuration
;pop eax