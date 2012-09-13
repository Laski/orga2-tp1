;RDI,RSI,RDX,RCX,R8,R9
;XMM0,XMM1,XMM2,XMM3,XMM4,XMM5,XMM6,XMM7
;Preservar RBX, R12, R13, R14, R15
;resultado en RAX o XMM0
;Byte: AL, BL, CL, DL, DIL, SIL, BPL, SPL, R8L - R15L
;Word: AX, BX, CX, DX, DI, SI, BP, SP, R8W - R15W
;DWord: EAX, EBX, ECX, EDX, EDI, ESI, EBP, ESP, R8D - R15D
;QWord: RAX, RBX, RCX, RDX, RDI, RSI, RBP, RSP, R8 - R15

global listaCrear
global listaInsertar
global listaDestruir
global listaImprimir
global listaFilter
global listaMap
global es_multiplo_de_5
global es_negativo
global es_largo_mayor_10
global tomar_primeros_10
global dividir_por_dos
global multiplicar_por_pi

%define NULL 0

%define sin_tipo 0
%define tipo_int 1
%define tipo_double 2
%define tipo_string 3

%define false 0
%define true 1

%define char_size 1
%define int_size 4
%define word_size 2
%define double_size 8
%define puntero_size 8
%define lista_size 12
%define nodo_size 16

; la estructura de mi lista es:
; 0..3	enum tipo_e tipo_dato
; 4..11	struct nodo_t *primero

; la estructura de un nodo es:
; 0..7	struct nodo_t *siguiente;
; 7..15	void *dato;

%define tipo_dato_offset 0
%define primero_offset 4
%define siguiente_offset 0
%define dato_offset 8

extern fopen
extern fclose
extern fprintf
extern malloc
extern free
extern strlen
extern strcpy


section .data
pi: dq 3.14159265;- pi está en [pi]
fopen_mode: db "a", 0
format_int: db "[%d]", 0
format_double: db "[%f]", 0
format_string: db "[%s]", 0
salto_linea: db 10, 0
format_salto: db "%s", 0



section .text

; ============ lista * listaCrear()
listaCrear:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	;para llamar a malloc tengo que poner en rdi el tamaño de la lista
	xor rdi, rdi
	mov rdi, lista_size
	call malloc; lista *new = malloc(lista_size)
	; ----------------- new está en rax
	
	mov dword [rax + tipo_dato_offset], sin_tipo; new->tipo_dato = sin_tipo
	mov qword [rax + primero_offset], NULL; new->primero = NULL;
	
	;desarmo stack frame
	pop rbp
	ret

; ============ void listaInsertar(lista * l, enum tipo e, void* dato);
listaInsertar:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*l está en rdi, e está en rsi, *dato está en rdx
	
	;primero necesito hacer el checkeo de tipos
	cmp dword [rdi + tipo_dato_offset], 0
	je ningun_tipo
	
	cmp [rdi + tipo_dato_offset], esi
	jne distinto_tipo
	
	je mismo_tipo
	
ningun_tipo:
	mov dword [rdi + tipo_dato_offset], esi; l->tipo_dato = e
	;e está en &l
	
mismo_tipo:
	;para llamar a malloc tengo que poner en rdi el tamaño del nodo
	;pero no quiero perder los parámetros
	mov rbx, rdi
	; ----------------- *l está en rbx, e está en [rbx + 0]
	mov r12, rdx
	; ----------------- *dato está en r12
	xor rdi, rdi
	mov rdi, nodo_size
	call malloc; nodo *new_nodo = malloc(nodo_size)
	;*new_nodo está en rax, quiero preservarlo
	mov r15, rax
	; ----------------- *new_nodo está en r15

copiar_dato:
	;para copiar el dato necesito comparar el tipo de la lista con los
	;tres posibles y llamar a malloc dependiendo del resultado
	xor rdi, rdi
	
	cmp dword [rbx + tipo_dato_offset], tipo_int
	je copiar_int
	cmp dword [rbx + tipo_dato_offset], tipo_double
	je copiar_double
	cmp dword [rbx + tipo_dato_offset], tipo_string
	je copiar_string

copiar_int:
	;para llamar a malloc tengo que poner en rdi el tamaño de un int
	mov rdi, int_size
	call malloc; int *new_i = malloc(int_size)
	;new_i está en rax
	;quiero hacer mov [rax], [r12] (copiar el dato)
	xor r13, r13
	mov r13d, [r12]
	mov dword [rax], r13d; ahora [rax] tiene el dato copiado
	mov r14, rax; lo guardo
	; ----------------- *new_i está en r14
	jmp ya_copiado
		
copiar_double:
	;para llamar a malloc tengo que poner en rdi el tamaño de un double
	mov rdi, double_size
	call malloc; double *new_d = malloc(double_size)
	;new_d está en rax
	;quiero hacer mov [rax], [r12] (copiar el dato)
	xor r13, r13
	mov qword r13, [r12]
	mov qword [rax], r13; ahora [rax] tiene el dato copiado
	mov r14, rax; lo guardo
	; ----------------- *new_d está en r14
	jmp ya_copiado
	
copiar_string:
	;un string es un puntero a char, pero quiero reservar espacio
	;para todo el string, por lo que necesito saber su tamaño
	mov rdi, r12; rdi <- *dato
	;size_t strlen ( const char * str )
	call strlen
	;rax <- |dato|
	;para llamar a malloc tengo que poner en rdi el tamaño del string
	;+ 1 para el caracter de final
	inc rax
	mov rdi, rax
	call malloc; *char new_s = malloc(strlen(*dato))
	;new_s está en rax
	;quiero copiar [r12] a [rax]
	;char * strcpy ( char * destination, const char * source )
	mov rdi, rax
	mov rsi, r12
	call strcpy
	;ahora [rax] tiene el string copiado
	mov r14, rax; lo guardo
	; ----------------- *new_s está en r14
	
ya_copiado:
	;quiero asignar el dato copiado al nodo
	;el puntero al dato estaba en r14, el nodo en [r15]
	mov [r15 + dato_offset], r14
	
asignar_nodo:
	;por último quiero asignar el nuevo nodo a la lista
	;quiero hacer mov qword [r15 + siguiente_offset],
	;[rbx + primero_offset]
	mov qword r8, [rbx + primero_offset]
    mov qword [r15 + siguiente_offset], r8; new_nodo->siguiente =
    ;										l->primero
    mov qword [rbx + primero_offset], r15; l->primero = new_nodo

distinto_tipo: ; MUERE!
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; ============ void  listaDestruir(lista * l)
listaDestruir:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*l está en rdi
	mov rbx, rdi
	; ----------------- *l está en rbx
	;primero quiero borrar todos los nodos (y su contenido)
	;hasta que el siguiente sea null
	mov r12, [rbx + primero_offset]
	; ----------------- *nodo está en r12

ciclo_destruir:
	;me fijo si la lista no está vacía
	cmp r12, NULL
	je vacia_destruir
	;borro el primer nodo y pongo en r12 el valor del siguiente
	mov r13, [r12 + siguiente_offset]
	; ----------------- *siguiente está en r13
	;para llamar a free tengo que poner en rdi los punteros
	;al contenido y después al nodo
	mov rdi, [r12 + dato_offset]
	call free
	mov rdi, r12
	call free
	;el nuevo nodo es el siguiente a ser borrado
	mov r12, r13
	
	jmp ciclo_destruir
	
vacia_destruir:
	;termine con la lista, quiero borrarla también
	mov rdi, rbx
	call free	
	
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; ============ void  listaImprimir(lista  * l, char *archivo)
listaImprimir:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*l está en rdi, *archivo está en rsi
	mov rbx, rdi
	; ----------------- *l está en rbx
	mov r15, rsi
	; ----------------- *archivo está en r15
	;quiero abrir el archivo para usarlo, vamos a llamar a fopen
	;FILE * fopen ( const char * filename, const char * mode )
	mov rdi, r15; primer parámetro
	xor rsi, rsi
	mov rsi, fopen_mode; segundo parámetro
	call fopen
	;el resultado está en rax
	mov r15, rax
	; ----------------- archivo está en r15
	cmp r15, NULL
	je fin_imprimir; manejo de errores
	
	;ahora quiero hacer un ciclo que recorra la lista y la imprima
	mov qword r12, [rbx + primero_offset]
	; ----------------- *nodo está en r12
	;primero el chequeo de tipos
	xor r13d, r13d
	mov dword r13d, [rbx + tipo_dato_offset]
	; ----------------- tipo_dato está en r13d
	cmp r13d, sin_tipo
	je fin_imprimir
	cmp r13d, tipo_double
	;je imprimir_double
	cmp r13d, tipo_string
	;je imprimir_string
	
imprimir_int:
	cmp r12, NULL; terminé?
	je fin_imprimir
	;imprimo el nodo en el que estoy, quiero llamar a fprintf
	;int fprintf ( FILE * stream, const char * format, ... );
	mov rdi, r15; primer parámetro
	mov rsi, format_int; segundo parámetro
	mov rdx, [r12 + dato_offset]; puntero al dato
	mov edx, [rdx]; tercer parámetro
	mov rax, 1; necesario para llamar a fprintf
	call fprintf
	mov r12, [r12 + siguiente_offset]; paso al siguiente nodo
	jmp imprimir_int
	
imprimir_double:
	cmp r12, NULL; terminé?
	je fin_imprimir
	;imprimo el nodo en el que estoy, quiero llamar a fprintf
	;int fprintf ( FILE * stream, const char * format, ... );
	mov rdi, r15; primer parámetro
	mov rsi, format_double; segundo parámetro
	mov rdx, [r12 + dato_offset]; puntero al dato
	mov rdx, [rdx]; tercer parámetro
	mov rax, 1; necesario para llamar a fprintf
	call fprintf
	mov r12, [r12 + siguiente_offset]; paso al siguiente nodo
	jmp imprimir_double
	
imprimir_string:
	cmp r12, NULL; terminé?
	je fin_imprimir
	;imprimo el nodo en el que estoy, quiero llamar a fprintf
	;int fprintf ( FILE * stream, const char * format, ... );
	mov rdi, r15; primer parámetro
	mov rsi, format_string; segundo parámetro
	mov rdx, [r12 + dato_offset]; puntero al dato
	mov rdx, [rdx]; tercer parámetro
	mov rax, 1; necesario para llamar a fprintf
	call fprintf
	mov r12, [r12 + siguiente_offset]; paso al siguiente nodo
	jmp imprimir_double

fin_imprimir:
	;falta imprimir el salto de línea
	mov rdi, r15; primer parámetro
	mov rsi, format_salto; segundo parámetro
	mov rdx, salto_linea; tercer parámetro
	call fprintf
	
	;y cerrar el archivo
	;int fclose ( FILE * stream );
	mov rdi, r15; primer parámetro
	call fclose
	
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret


; ============ lista  listaFilter(lista * l, void* (*funcion_filter)(void*) )
listaFilter:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*l está en rdi, *funcion_filter esta en rsi
	mov rbx, rdi
	mov qword r12, [rbx + primero_offset]
	; ----------------- *l está en rbx, *nodo está en r12
	mov r15, rsi
	; ----------------- *funcion_filter está en r15

ciclo_filter:
	;la lista podría estar vacía
	cmp r12, NULL
	je vacia_filter

	;guardo el valor al siguiente nodo
	mov qword r13, [r12 + siguiente_offset]
	; ----------------- *siguiente está en r13
	cmp r13, NULL
	je falta_el_primero
	;paso por parámetro a funcion_filter el dato del nodo siguiente
	xor rax, rax
	mov qword rdi, [r13 + dato_offset]
	call r15
	cmp al, false
	je false_filter
	;me muevo al siguiente nodo
	mov r12, r13
	jmp ciclo_filter

false_filter:
	;tengo que borrar el nodo y su contenido y corregir la estructura
	mov rdi, [r13 + dato_offset]
	call free
	mov r14, [r13 + siguiente_offset]
	; ----------------- el siguiente válido está en r14
	mov rdi, r13
	call free
	;corrijo la estructura
	mov qword [r12 + siguiente_offset], r14
	jmp ciclo_filter
	
falta_el_primero:
	;todavía tengo que mirar el primer dato
	mov qword r12, [rbx + primero_offset]
	mov qword rdi, [r12 + dato_offset]
	call r15
	cmp al, true; terminé?
	je vacia_filter
	;tengo que borrar el primero y su contenido y corregir la estructura
	mov qword rdi, [r12 + dato_offset]
	call free
	mov qword r14, [r12 + siguiente_offset]
	; ----------------- el siguiente válido está en r14
	mov rdi, r12
	call free
	;corrijo la estructura
	mov qword [rbx + primero_offset], r14

vacia_filter:
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret


; ============ lista  listaMap(lista l, void* (*funcion_map)(void*) )
listaMap:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*l está en rdi
	mov rbx, rdi
	mov qword r12, [rbx + primero_offset]
	; ----------------- *l está en rbx, *nodo está en r12
	mov r15, rsi
	; ----------------- *funcion_map está en r15

ciclo_map:
	;terminé?
	cmp r12, NULL
	je termine_map
	;procesar el nodo
	mov r13, [r12 + dato_offset]
	; ----------------- *dato está en r13
	mov rdi, r13
	call r15
	mov [r12 + dato_offset], rax
	;falta liberar el dato anterior
	mov rdi, r13
	call free
	;paso al nodo siguiente
	mov r12, [r12 + siguiente_offset]
	jmp ciclo_map
	
termine_map:
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; ============ boolean es_multiplo_de_5(int* dato)
es_multiplo_de_5:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	;*dato está en rdi
	xor rdx, rdx
	xor rax, rax
	xor rcx, rcx
	mov dword eax, [rdi]
	;dato está en rax
	mov dword ecx, 5
	idiv ecx; divide por 5
	;el resto está en edx
	mov qword rax, false; la respuesta "default" es false
	cmp edx, 0
	je true_multiplo
	jmp fin_multiplo

true_multiplo:
	mov qword rax, true
	pop rbp
	ret

fin_multiplo:
	;desarmo stack frame
	pop rbp
	ret


; ============ boolean es_negativo(double* dato)
es_negativo:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	;*dato está en rdi
	mov qword rax, [rdi]
	;dato está en rax
	bt rax, 63
	;si el número es negativo, CF debe ser 1
	jc negativo
	;si llegué acá el numero es positivo
	mov qword rax, false
	jmp fin_negativo

negativo:
	mov qword rax, true

fin_negativo:
	;desarmo stack frame
	pop rbp
	ret

; ============ boolean es_largo_mayor_10(char* dato)
es_largo_mayor_10:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	;*dato está en rdi
	;puedo usar strlen directamente
	call strlen
	cmp dword eax, 10
	jg mayor
	;si llegó hasta acá es menor o igual a diez
	mov qword rax, false
	jmp fin_largo

mayor:
	mov qword rax, true

fin_largo:
	;desarmo stack frame
	pop rbp
	ret
	
	
; ============ int* dividir_por_dos(int* dato);
dividir_por_dos:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*dato está en rdi
	;quiero moverlo a un nuevo lugar de memoria dividido por dos
	mov rbx, rdi
	; ----------------- *dato está en rbx
	mov qword rdi, int_size
	call malloc
	; el puntero resultado está en rax
	xor r12, r12
	mov dword r12d, [rbx]
	; ----------------- dato está en r12
	shr r12, 1; lo divido por dos
	mov dword [rax], r12d; y lo guardo

	;y mi puntero resultado sigue en rax así que no hace falta moverlo
	
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; ============ double* multiplicar_por_pi(double* dato);
multiplicar_por_pi:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*dato está en rdi
	;quiero moverlo a un nuevo lugar de memoria multiplicado por pi
	mov rbx, rdi
	; ----------------- *dato está en rbx
	mov qword rdi, double_size
	call malloc
	; el puntero resultado está en rax
	xor r12, r12
	movq xmm0, [rbx]
	; ----------------- dato está en xmm0
	mulsd xmm0, [pi]; - res está en xmm0
	movq [rax], xmm0; lo guardo
	
	;y mi puntero resultado sigue en rax así que no hace falta moverlo
	
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret

; ============ char* tomar_primeros_10(char* dato)
tomar_primeros_10:
	;armo stack frame
	push rbp; A
	mov rbp, rsp
	push rbx; D
	push r12; A
	push r13; D
	push r14; A
	push r15; D
	sub rsp, 8; A
	;*dato está en rdi
	;quiero moverlo a un nuevo lugar de memoria recortado
	mov rbx, rdi
	; ----------------- *dato está en rbx
	
	; a malloc tengo que pedirle 11 chars
	lea qword rdi, [char_size * 11]
	call malloc
	; el puntero resultado está en rax
	mov r12, rax
	; ----------------- *new está en r12
	; ahora tengo que asegurarme de que |dato| > 10
	mov rdi, rbx
	call strlen
	cmp rax, 9
	jng no_es_mayor

	mov byte [r12 + 10], 0; caracter de finalización
	mov qword rcx, 10; cantidad de iteraciones

ciclo_tomar:
	;quiero hacer mov byte [r12 + rcx], [rbx + rcx]
	xor rdx, rdx
	mov byte dl, [rbx + rcx - 1]
	mov byte [r12 + rcx - 1], dl
	loop ciclo_tomar
	jmp termine_tomar
	
no_es_mayor:
	;la longitud está en rax
	mov byte [r12 + rax], 0; caracter de finalización
	mov rcx, rax ; cantidad de iteraciones
	jmp ciclo_tomar

termine_tomar:
	;devuelvo el resultado por rax
	mov rax, r12
	;desarmo stack frame
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
