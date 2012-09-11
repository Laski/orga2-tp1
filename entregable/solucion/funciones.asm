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
;global listaDestruir
;global listaImprimir
;global listaFilter
;global listaMap
;global es_multiplo_de_5
;global es_negativo
;global es_largo_mayor_10
;global tomar_primeros_10
;global dividir_por_dos
;global multiplicar_por_pi

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

extern printf
extern malloc
extern strlen
extern strcpy

section .data

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
	
	cmp dword [rbx + tipo_dato_offset], 1
	je copiar_int
	cmp dword [rbx + tipo_dato_offset], 2
	je copiar_double
	cmp dword [rbx + tipo_dato_offset], 3
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
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ void  listaImprimir(lista  * l, char *archivo)
listaImprimir:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ lista  listaFilter(lista l, void* (*funcion_filter)(void*) )
listaFilter:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp	
	ret

; ============ lista  listaMap(lista l, void* (*funcion_map)(void*) )
listaMap:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ boolean es_multiplo_de_5(int* dato)
es_multiplo_de_5:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ boolean es_negativo(double* dato)
es_negativo:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ boolean es_largo_mayor_10(char* dato)
es_largo_mayor_10:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ int* dividir_por_dos(int* dato);
dividir_por_dos:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ double* multiplicar_por_pi(double* dato);
multiplicar_por_pi:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret

; ============ char* tomar_primeros_10(char* dato)
tomar_primeros_10:
	;stack frame
	push rbp; A
	mov rbp, rsp
	
	pop rbp
	ret
