%include "sseutils64.nasm"

section .data


dataset     equ 8

n           equ 12
dimension   equ 16
nr          equ 20
divi        equ 24
result      equ 28

dim         equ 4



section .bss            ; Sezione contenente dati non inizializzati

section .text			; Sezione contenente il codice macchina

global  extr_col

extr_col:

    push		rbp				; salva il Base Pointer
	mov		rbp, rsp			; il Base Pointer punta al Record di Attivazione corrente
	pushaq						; salva i registri generali


    mov     eax, 0      ; j = 0 
    mov     edx, [ebp+dimension]; d
    ;imul    edx, dim    ; d*4

    xorps xmm6, xmm6
    xorps xmm7, xmm7

forj:   
    mov     ebx, 0      ; i = 0
    mov     ecx, 0      ; h = 0

fori:
    mov     esi, [ebp+dataset]  ;dataset
    mov     edi, [ebp+n]    ; n
    imul    edi, eax        ; n*j
    add     edi, ecx        ; h+n*j
    imul    edi, dim        ;;; 4 ( h+n*j)
    add     esi, edi        ; dataset + h+n*j
    movss   xmm1, [esi]     ; ds[h+n*j]

    mov     esi, [ebp+result] ;result
    mov     edi, [ebp+nr]   ; nr
    imul    edi, eax        ; nr*j
    add     edi, ebx        ; i+nr*j
    imul    edi, dim        ;;; 4(i+nr*j)
    add     esi, edi
    movss   [esi], xmm1     ; result[i+nr*j] = ds[h+n*j]

    ;add     ebx, dim        ; i++
    add     ebx, 1

    mov     esi, [ebp+nr]
    mov edi, [ebp+divi]
    add     ecx, edi        ; h+=n/nr
    ;imul    esi, dim        ; nr*4

    cmp     ebx, esi        ; i < nr
    jb      fori


    add     eax, 1  

    cmp     eax, edx        ; j < d
    jb      forj



    popaq						; ripristina i registri generali
	mov		rsp, rbp			; ripristina lo Stack Pointer
	pop		rbp				; ripristina il Base Pointer
	ret						; torna alla funzione C chiamante

