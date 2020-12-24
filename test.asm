DATAS SEGMENT
    ;----------------------------const area-----------------------------
   
    ;-----------------------------DebugTools---------------------------------
    _enter db 13,10,'$'
    _str0 db 'si:','$'
    _str1 db 'di:','$'
    _str2 db 'ax:','$'
    _str3 db 'bx:','$'
    _str4 db 'Enter one word:','$'
    ;------------------------------函数名-------------------------------- 
   
    ;------------------------------变量---------------------------------
   DATAS ENDS

CODES SEGMENT 
    ASSUME CS:CODES,DS:DATAS
start:
    mov ax,DATAS
    mov ds,ax

;---------------------------Extra Tools---------------------------------
print_const_string:
    push ax;;

    mov ah,09h
    int 21h

    pop ax
    ret
show_hex:
;把bx寄存器中数据转换成十六进制显示
    mov cx,4
s1:
    push cx

    sub cx,cx
    mov cl,4
    rol bx,cl ;循环左移cl次，cl寄存器为本指令参数
    mov dl,bl
    and dl,0fh ;高四位清零

    add dl,30h
    cmp dl,3ah ;转换为ascii码
    jl s2
    add dl,07h ;如果不是数字再加07h
s2:
    mov ah,02h
    int 21h ;显示字符

    pop cx
    loop s1

    ret
show_input_string:
;参数：bx存放字符串基址
;功能：显示用户输入的字符串
   lea dx,_enter
   call print_const_string
   
   inc bx;指向存储的字符数量
   mov byte ptr al,[bx]
   mov ah,0
   mov si,ax
   
      inc bx   
    mov cx,'$'
    mov [bx+si],cx 
    
    mov dx,bx    
    call print_const_string
    
    lea dx,_enter
    call print_const_string
    
    mov cx,0
    mov [bx+si],cx;还原字符串

   ret
show_si_di:
   lea dx,_str0
   call print_const_string
   mov bx,si
   call show_hex
   
   lea dx,_enter
   call print_const_string

   
   lea dx,_str1
   call print_const_string
   mov bx,di
   call show_hex
   
   lea dx,_enter
   call print_const_string
   
   call breakpoint
   
   ret
show_ax:
   push ax;;
   
   lea dx,_str3
   call print_const_string
   
   
   mov bx,ax
   call show_hex
   
   lea dx,_enter
   call print_const_string
   
   call breakpoint   
   pop ax
   ret
show_bx:
   push ax;;
   
   lea dx,_str3
   call print_const_string
   
   call show_hex
   
   lea dx,_enter
   call print_const_string
   
   call breakpoint
   
   pop ax
   ret
breakpoint:
   push ax;;
   
   lea dx,string10
   call print_const_string
   
   mov ah,0ah
   lea dx,var_glory
   int 21h
   
   lea dx,_enter
   call print_const_string
   
   pop ax
   ret
return:
   mov ax,4c00h
   int 21h
CODES ENDS
    END start 