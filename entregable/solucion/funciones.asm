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


extern printf
extern malloc

section .data

section .text

; ============ lista * listaCrear()
listaCrear:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	;para llamar a malloc tengo que poner en rdi el tamaño de la lista
	xor rdi, rdi
	mov rdi, lista_size ;la lista ocupa 12 bytes
	call malloc ;el puntero resultado está en rax
	mov dword [rax], 0 ;new->tipo_dato = sin_tipo
	mov qword [rax + int_size], NULL ;new->primero = NULL;
	pop rbp
	ret

; ============ void listaInsertar(lista * l, enum tipo e, void* dato);
listaInsertar:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	;*l está en RDI
	
	
	pop rbp
	ret

; ============ void  listaDestruir(lista * l)
listaDestruir:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ void  listaImprimir(lista  * l, char *archivo)
listaImprimir:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ lista  listaFilter(lista l, void* (*funcion_filter)(void*) )
listaFilter:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp	
	ret

; ============ lista  listaMap(lista l, void* (*funcion_map)(void*) )
listaMap:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ boolean es_multiplo_de_5(int* dato)
es_multiplo_de_5:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ boolean es_negativo(double* dato)
es_negativo:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ boolean es_largo_mayor_10(char* dato)
es_largo_mayor_10:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ int* dividir_por_dos(int* dato);
dividir_por_dos:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ double* multiplicar_por_pi(double* dato);
multiplicar_por_pi:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret

; ============ char* tomar_primeros_10(char* dato)
tomar_primeros_10:
	;stack frame
	push rbp ;A
	mov rbp, rsp ;A
	
	pop rbp
	ret
