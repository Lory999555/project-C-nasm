%include "sseutils.nasm"

section .data
	

c		equ		8


x   equ     12


distance		equ		16

i		equ		20
j		equ		24
k equ 28
subb equ 32

dim equ 4

   
section .bss
    
section .text

global rowDistance32AdcA

	rowDistance32AdcA:

        start
        mov ecx,[ebp+c]
        mov ebx,[ebp+k]
        mov edi,[ebp+subb]

        mov edx,[ebp+j]                     ;prendo j
        imul edx,dim   
        imul edx,edi                        ;j*sub
        imul edx,ebx                        ;j*k*subb
        ;printreg edx

        mov ebx,[ebp+i]                     ;prendo i
        imul ebx,dim
        imul ebx,edi                        ;i*subb
        add ebx,edx                         ;j*k*subb+i*subb
        add ebx,ecx                         ;c[j*k*subb+i*subb]

        mov eax,[ebp+x]                     ;prendo x
        
        
        ;xorps xmm5,xmm5                     ;distance=0 

        movaps xmm1,[eax]                   ;uj_x[0]
        ;printregps xmm1
        movaps xmm7, [ebx]
        ;printregps xmm7
        subps xmm1,[ebx]                    ;uj_x[0]-c[j*k*subb+i*subb+0]
        mulps xmm1,xmm1                     ;(..)^2
        ;printregps xmm1
        ;mov edi,[ebp+subb]                     ;subb
        ;mov ecx,dim
        sub edi,16                          ;subb-16
        mov esi,4                            ;z=4
        xorps xmm2,xmm2
    ciclo:
        cmp esi,edi
        jg resto

        movaps xmm0,[eax+4*esi]             ;uj_x[z]
        movaps xmm3,[eax+4*esi+16]
        movaps xmm4,[eax+4*esi+32]
        movaps xmm5,[eax+4*esi+48]

        subps xmm0,[ebx+4*esi]              ;uj_x[z]- c[j*k*subb+i*subb+z]
        subps xmm3,[ebx+4*esi+16]
        subps xmm4,[ebx+4*esi+32]
        subps xmm5,[ebx+4*esi+48]
        ;printregps xmm0
        mulps xmm0,xmm0                     ;(..)^2
        mulps xmm3,xmm3
        mulps xmm4,xmm4
        mulps xmm5,xmm5
        ;printregps xmm0
        addps xmm1,xmm0                     ;distance+=(..)^2
        addps xmm1,xmm3                     ;distance+=(..)^2
        addps xmm1,xmm4                     ;distance+=(..)^2
        addps xmm1,xmm5                     ;distance+=(..)^2
        ;printregps xmm1
        add esi,16

        jmp ciclo

    resto:
        mov edi, [ebp+subb]
        sub edi, 4
    ciclo2:
        cmp esi, edi
        jg resto2
        movaps xmm0,[eax+4*esi] ;sommo gli ultimi elementi rimanenti
        ;printregps xmm0
        ;movaps xmm7, [ebx]
        ;printregps xmm7
        subps xmm0,[ebx+4*esi]
        mulps xmm0,xmm0
        addps xmm2,xmm0
        ;printregps xmm1
        add esi, 4
        jmp ciclo2
    resto2:
        mov edi, [ebp+subb]
    ciclo3:
        cmp esi, edi
        je  fine
        movss xmm0,[eax+4*esi] ;sommo gli ultimi elementi rimanenti
        ;printregps xmm0
        ;movaps xmm7, [ebx]
        ;printregps xmm7
        subss xmm0,[ebx+4*esi]
        mulss xmm0,xmm0
        addss xmm2, xmm0
        ;printregps xmm1
        add esi, 1
        jmp ciclo3
    fine:
        haddps xmm1,xmm2        ;merge di tutte le somme
        haddps xmm1,xmm1        ;|
        haddps xmm1,xmm1        ;|
        ;printreg esi
        mov eax,[ebp+distance]
        movss  [eax],xmm1

        stop



global rowDistance32AdcU

	rowDistance32AdcU:

        start
        mov ecx,[ebp+c]
        mov ebx,[ebp+k]
        mov edi,[ebp+subb]

        mov edx,[ebp+j]                     ;prendo j
        imul edx,dim   
        imul edx,edi                        ;j*sub
        imul edx,ebx                        ;j*k*subb
        ;printreg edx

        mov ebx,[ebp+i]                     ;prendo i
        imul ebx,dim
        imul ebx,edi                        ;i*subb
        add ebx,edx                         ;j*k*subb+i*subb
        add ebx,ecx                         ;c[j*k*subb+i*subb]

        mov eax,[ebp+x]                     ;prendo x
        
        
        ;xorps xmm5,xmm5                     ;distance=0 

        movups xmm1,[eax]                   ;uj_x[0]
        ;printregps xmm1
        movups xmm7, [ebx]
        ;printregps xmm7
        subps xmm1,xmm7                    ;uj_x[0]-c[j*k*subb+i*subb+0]
        mulps xmm1,xmm1                     ;(..)^2
        ;printregps xmm1
        ;mov edi,[ebp+subb]                     ;subb
        ;mov ecx,dim
        sub edi,16                          ;subb-16
        mov esi,4                            ;z=4
        xorps xmm2,xmm2
    cicloU:
        cmp esi,edi
        jg restoU

        movups xmm0,[eax+4*esi]             ;uj_x[z]
        movups xmm3,[eax+4*esi+16]
        movups xmm4,[eax+4*esi+32]
        movups xmm5,[eax+4*esi+48]

        movups xmm6,[ebx+4*esi]             ;uj_x[z]
        movups xmm7,[ebx+4*esi+16]
        

        subps xmm0,xmm6              ;uj_x[z]- c[j*k*subb+i*subb+z]
        subps xmm3,xmm7

        movups xmm6,[ebx+4*esi+32]
        movups xmm7,[ebx+4*esi+48]

        subps xmm4,xmm6
        subps xmm5,xmm7
        ;printregps xmm0
        mulps xmm0,xmm0                     ;(..)^2
        mulps xmm3,xmm3
        mulps xmm4,xmm4
        mulps xmm5,xmm5
        ;printregps xmm0
        addps xmm1,xmm0                     ;distance+=(..)^2
        addps xmm1,xmm3                     ;distance+=(..)^2
        addps xmm1,xmm4                     ;distance+=(..)^2
        addps xmm1,xmm5                     ;distance+=(..)^2
        ;printregps xmm1
        add esi,16

        jmp cicloU

    restoU:
        mov edi, [ebp+subb]
        sub edi, 4
    ciclo2U:
        cmp esi, edi
        jg resto2U
        movups xmm0,[eax+4*esi] ;sommo gli ultimi elementi rimanenti
        ;printregps xmm0
        movups xmm7, [ebx+4*esi]
        ;printregps xmm7
        subps xmm0,xmm7
        mulps xmm0,xmm0
        addps xmm2,xmm0
        ;printregps xmm1
        add esi, 4
        jmp ciclo2U
    resto2U:
        mov edi, [ebp+subb]
    ciclo3U:
        cmp esi, edi
        je  fineU
        movss xmm0,[eax+4*esi] ;sommo gli ultimi elementi rimanenti
        ;printregps xmm0
        ;printregps xmm7
        subss xmm0,[ebx+4*esi]
        mulss xmm0,xmm0
        addss xmm2, xmm0
        ;printregps xmm1
        add esi, 1
        jmp ciclo3U
    fineU:
        haddps xmm1,xmm2        ;merge di tutte le somme
        haddps xmm1,xmm1        ;|
        haddps xmm1,xmm1        ;|
        ;printreg esi
        mov eax,[ebp+distance]
        movss  [eax],xmm1

        stop


