format ELF64
public _start

;(64)rax = (32)eax = (16)ax = (8)ah|al(8)

section '.data' writable
	; Array 		db 17, -41, 71, 123, 2, -23, -17, 42, 73, -60
	Array 		db 24, 17, 71, 98, 3, 45, 76, 8, 11, 9
	n 		= $-Array
	new_line 	equ 0xA						; пустая строка
	msg 		db "Исходный массив:        Преобразованный массив:", new_line, 0		; 0 - конец строки
	msg2		db "Суммы: ", 0
	bss_char	rb 1						; буфер для хранения 1 байта (вывод символа)


section '.code' executable
; весь код располагается тут
_start:
	; вывод исходного массива:
	mov rax, msg
	call print_string
	push rcx
	mov rcx, 0
	xor rbx, rbx

	.nex_iter:
		cmp rcx, n
		je .close

		xor rax, rax 				; чистим rax
		mov al, [Array+rcx]			; перетаскиваем значение рассматриваемого элемента массива в регистр al
		add rbx, rax 				; добавляем с rbx значение rax 		подсчет суммы (первая сумма хранится в rbx)
		call print_number 			; печатаем текущий элемент массива

		;преобразование элемента массива
		or al, 00010000b			; умножение по маске
		add rdx, rax
		call print_tab
		call print_tab
		call print_tab
		call print_number 			; печатаем текущий преобразованный элемент массива
		call print_line 			; перенос каретки

		inc rcx 				; инкремент счетчика
		jmp .nex_iter
	.close:
		pop rcx

		call print_line
		xor rax, rax
		mov rax, msg2				; вывод строки "Сумма"
		call print_string
		call print_tab
		mov rax, rbx 				; вывод суммы исходного массива
		call print_number
		call print_tab
		call print_tab
		xor rax, rax
		mov rax, rdx 				; вывод суммы преобразованного массива
		call print_number
		call print_line

	;xor rax, rax
	;mov rax, "."
	;call print_char
	;call print_line

	; не далее
	call exit

section '.print_string' executable
print_string:
	push rax 				;
	push rbx 				; правильный
	push rcx 				; код
	push rdx 				;

	mov rcx, rax 				; передаем указатель на msg
	call length_string
	mov rdx, rax				; передаем длину выводимого сообщения
	mov rax, 4 				; 4 - write
	mov rbx, 1 				; 1 - stdout
	int 0x80				; обращение в операционной системе

	pop rdx 				;
	pop rcx 				; правильный
	pop rbx 				; код
	pop rax 				;

	ret 					; возвращаемся в точку вызова

section '.length_string' executable
length_string:
	push rdx				; если регистр rdx - использовался, то мы его значение запихнули в стек
	xor rdx ,rdx				; обнулим регистр
	.next_iter:
		cmp [rax+rdx], byte 0		; сравниваем значение rax со смещением rdx на наличие 0
		je .close			; закрытие процедуры (выход)
		inc rdx
		jmp .next_iter
	.close:
		mov rax, rdx
		pop rdx				; раз впихнули в стек, то нужно и выпихнуть :)
		ret


section '.print_number' executable
print_number:
	push rax
	push rbx
	push rcx
	push rdx
	xor rcx, rcx 				;чистим rcx
	.next_iter:
		cmp rax, 0			; когда rax будет равен 0
		je .print_iter			; закрытие процедуры (выход)

		mov rbx, 10 			; для деления
		xor rdx, rdx 			; чистим rdx
		div rbx 			; делим rax на rbx
		add rdx, '0'
		push rdx
		inc rcx 			; инкремент регистра, чтобы знать, сколько чисел выводить
		jmp .next_iter
	.print_iter:
		cmp rcx, 0
		je .close

		pop rax
		call print_char
		dec rcx
		jmp .print_iter
	.close:
		pop rdx
		pop rcx
		pop rbx
		pop rax
		ret


section '.print_char' executable
print_char:
	;32bit
	push rax
	push rbx
	push rcx
	push rdx
	mov [bss_char], al

	mov rax, 4
	mov rbx, 1
	mov rcx, bss_char
	mov rdx, 1
	int 0x80
	pop rdx
	pop rcx
	pop rbx
	pop rax
	

	;64bit
	;push rax

	;mov rax, 1	; 1 - write
	;mov rdi, 1	; stdout
	;mov rsi, rsp 	; rsp - последнее значение из стека
	;mov rdx, 1	; количество символов
	;syscall

	;pop rax

	ret

section '.print_line' executable
print_line:
	push rax
	mov rax, 0xA
	call print_char
	pop rax
	ret

section '.print_tab' executable
print_tab:
	push rax
	mov rax, 09
	call print_char
	pop rax
	ret

section '.exit' executable
exit:
	mov rax, 1 ; 1 - exit
	mov rbx, 0 ; 0 - return
	int 0x80