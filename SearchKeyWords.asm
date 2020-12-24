DATAS SEGMENT
    ;----------------------------const area-----------------------------
	string1 db 'Enter keyword:','$'
    string2 db 'Enter Sentence:','$' 
    string3 db 'Match at location: ','$'	   ;注意后面有个空格
    string4 db 'H of the sentence',13,10,'$'   
    string5 db 'No match',13,10,'$'
    
    ;-----------------------------DebugTools---------------------------------
    _enter db 13,10,'$'
    string6 db 'si:','$'
    string7 db 'di:','$'
    string8 db 'ax:','$'
    string9 db 'bx:','$'
    string10 db 'Enter one word:','$'
    string11 db 'Success','$'
    string12 db 'Single match fail','$'
    ;------------------------------函数名-------------------------------- 
    string13 db 'inner_cmp',13,10,'$'
    string14 db 'continue_cmp',13,10,'$'
    ;------------------------------变量---------------------------------
    var_keywords label byte
        maxlen1 db 0ffh
        strlen1 db ?
        strbuf1 db 0ffh dup(0)
    var_string label byte
        maxlen2 db 0ffh
        strlen2 db ?
        strbuf2 db 0ffh dup(0)
    var_glory label byte
        maxlen3 db 0ffh
        strlen3 db ?
        strbuf3 db 0ffh dup(0)    
DATAS ENDS

CODES SEGMENT 
    ASSUME CS:CODES,DS:DATAS
start:
    mov ax,DATAS
    mov ds,ax

    call getstr ;用户输入字符串

    lea di,strbuf1 ;di存的是keywords
    lea si,strbuf2
    jmp match
getstr:
    lea dx,string1
    call print_const_string

    mov ah,0ah
    lea dx,var_keywords
    int 21h

    lea dx,_enter
    call print_const_string

    lea dx,string2
    call print_const_string

    mov ah,0ah
    lea dx,var_string
    int 21h

    lea dx,_enter
    call print_const_string

    ret
match:
;该程序对di和si指向的单元进行比较，di为keywords,si为string
    call s0 ;内循环

    inc si
	mov ax,si
	sub ax,offset strbuf2;获取当前已比较的字符串长度

    sub bx,bx
	mov bl,strlen1
	add ax,bx

    sub bx,bx
	mov bl,strlen2;if cur_len2+strlen1=strlen2+1则退出,超界
	inc bx
	cmp ax,bx	
	
	je fail
	jmp match
s0:
    push si
    push di;保存外循环计数
inner_cmp:
    sub ax,ax
    sub bx,bx ;养成习惯，8位寄存器赋值前先对高位清零
    mov byte ptr al,ds:[di]
    mov byte ptr bl,ds:[si]
    cmp ax,bx

    je judge_success ;判断是否关键词比较到末尾
    pop di
    pop si
    ret ;内循环匹配失败退出到外循环，注意pop的顺序和push的顺序相反
judge_success:
    mov ax,di
    sub ax,offset strbuf1
    inc ax ;做差后加一才是已经匹配到的位置

    sub bx,bx
    mov bl,strlen1

    cmp ax,bx
    je success

    inc di
    inc si
    jmp inner_cmp ;未匹配满继续匹配
success:
    pop di
    pop si ;取出比较成功时外循环的si指针

    lea dx,string3
    call print_const_string

    mov bx,si
    sub bx,offset strbuf2
    inc bx ;相减后加一才是位置
    call show_hex

    lea dx,string4
    call print_const_string

    lea dx,_enter
    call print_const_string

    jmp start ;重新开始
fail:
    lea dx,string5
    call print_const_string

    lea dx,_enter
    call print_const_string

    jmp start
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
;参数：dx存放字符串基址
;功能：显示用户输入的字符串
    mov bx,dx
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
	lea dx,string6
	call print_const_string
	mov bx,si
	call show_hex
	
	lea dx,_enter
	call print_const_string

	
	lea dx,string7
	call print_const_string
	mov bx,di
	call show_hex
	
	lea dx,_enter
	call print_const_string
	
	call breakpoint
	
	ret
show_ax:
	push ax;;
	
	lea dx,string8
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
	
	lea dx,string9
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