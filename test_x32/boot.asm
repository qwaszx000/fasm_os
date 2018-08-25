format binary
org 7c00h
use16

push dx
cli
mov ax,00h
mov ds,ax
mov es,ax
mov ss,ax
sti

pop dx
push dx
mov ah,00h
int 13h

mov ax, 0003h
int 10h

mov ah, 02h
pop dx
push dx
mov ch, 00h
mov cl, 02h
mov al, 01h
mov bx, 0000h
mov es,bx
mov bx, 0500h
int 13h
jmp 0500h

times 510-($-$$) db 0
db 055h,0aah;Конец бута