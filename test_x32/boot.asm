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
push dx;DL - disk drive
mov ah,00h;Reset disk driver
int 13h

mov ax, 0003h;clear video memory
int 10h

mov ah, 02h;Read sector from drive
pop dx;DH - head, DL - drive
mov ch, 00h;Cylinder
mov cl, 02h;Sector(count from 1)
mov al, 02h;Sectors to read we read 2 sectors because our kernel has size = 2 sectors
mov bx, 0000h
mov es,bx    ;ES:BX memory address
mov bx, 0500h
int 13h;Read sector from drive

;mov ch, 00h
;mov cl, 03h
;mov al, 01h
;mov bx, 0000h
;mov es,bx
;mov bx, 0x700
;int 13h

jmp 0500h

times 510-($-$$) db 0
db 055h,0aah;Конец бута