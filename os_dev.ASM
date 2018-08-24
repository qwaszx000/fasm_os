format binary
org 7c00h
use16

;push print_m mov_cursor get_simbol write_simb get_cursor_pos gra_t  ;В стек адреса функций


start:;Start or reset
	push dx;Сохраняем бут-хрень
	cli
	mov ax,00h
	mov ds,ax      ;Запрещаем прерывания, обнуляем все, разрешаем прерывания
	mov es,ax
	mov ss,ax
	sti

	pop dx
	push dx
	mov ah,00h;Рекалибруем диск
	int 13h;   Для запуска ядра
	jc int13_err

	mov ax, 0004h ; Очистить экран,80х25 текст  ;4
	int 10h

	mov dx,0000h ;Установка курсора
	call mov_cursor

	mov bp,greating
	mov cx,24
	call print_m

	mov dx,0100h
	call mov_cursor

;	 mov bp,help_nt
;	 mov cx,20
;	 call print_m

;	 mov dx,0200h
;	 call mov_cursor

	mov bp,kernel_wait
	mov cx,24
	call print_m

writing:
	call get_simbol
	cmp al,08h
	jz back_space_wr
	cmp al,0Dh
	jz enter_wr
       ; cmp al,37
	;jz left_key
	;cmp al,38
	;jz up_key
	;cmp al,40
	;jz down_key
	;cmp al,39
	;jz right_key
	;cmp al,27;Escape
	;jz start;Reset data
	call write_simb
	mov [comnd],al
	jmp writing

print_m:; cx - длина текста    bp - текст ;Написать текст
	mov ax,1301h
	mov bh,00h
	mov bl,01h
	int 10h
	ret

mov_cursor:;dh - строка dl - колонка   сдвинуть курсор(текстовый)
	mov ah,02h
	mov bh,0h
	int 10h
	ret

get_cursor_pos:;Получить позицию курсора
	mov bh,00h
	;Выход:
	;DH - строка
	;DL - колонка
	ret

get_simbol:;Получить символ из клавиатуры
	;in al,60h
	mov ah,00h
	int 16h
	;AL - ASCII
	ret

write_simb:;Написать символ в текущей позиции текстового курсора
	mov ah,0eh
	;al - символ
	int 10h
	ret

back_space_wr:;Обработка бекспейса
	mov al,08h
	call write_simb
	mov al,20h
	call write_simb
	mov al,08h
	call write_simb
	;ret
	jmp writing

enter_wr:;Обработка ентера
	call get_cursor_pos
	inc dh
	call mov_cursor
	;ret
	cmp [comnd],'q'
	jz quit
	cmp [comnd],'n'
	jz load_kernel
	jmp writing

load_kernel:
	mov ah,02h
	pop dx	;
	push dx ;DX - DH и DL для запуска
	mov ch,00h;Нулевой цилиндр
	mov cl,02h;Второй сектор(ядро) см all_os.asm счет с 1!
	mov al,01h;1 сектор

	mov bx,0000h
	mov es,bx   ;Адрес, куда писать ядро(0000h:0500h)
	mov bx,0500h
	int 13h
	jc int13_err

	jmp 0500h;Ядро

int13_err:
	mov cx,13
	mov bp,int13_ert
	call print_m
	jmp writing
quit:
	jmp $

;up_key:;Стрелка вверх
;	 call get_cursor_pos
;	 dec dh
;	 call mov_cursor
;	 jmp writing

;down_key:
;	 jmp enter_wr

;left_key:
;	 call get_cursor_pos
;	 dec dl
;	 call mov_cursor
;	 jmp writing

;right_key:
;	 mov al,20h
;	 call write_simb
;	 jmp writing

gra_t:;Графическая точка
	mov ah,0Ch
	mov bh,0h
	;dx - строка
	;cx - колонка
	;mov al,05h ;AL - цвет
	int 10h
	ret

greating db "Hello,kernel! I am OS!..",0h
kernel_wait db "Type 'n' to load kernel!",0h
int13_ert db "Int 13 error!",0h
;enter_i db "You нажал enter",0h
;simb db "a",0h
;help_nt db "Type F1 to get help!",0h
;help db "Type 'q' to shutdown OS. F1 to help and esc to restart OS.",0h
comnd db ?
times (510-($-$$)) db 0
db 055h,0aah;Конец бута