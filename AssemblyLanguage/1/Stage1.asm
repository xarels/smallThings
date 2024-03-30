;	Stage 2 of the asssignment code
;----	Data
;----- [bp + value]
%assign x0 12
%assign y0 10
%assign x1 8
%assign y1 6
%assign color 4
;---- [bp - value]
%assign X 16
%assign Y 14
%assign deltaX 12
%assign deltaY 10
%assign sX 8
%assign sY 6
%assign err 4
%assign e2 2		
;----	Functions
Change_Video_Mode_To_VGA:
	mov ah, 0h ;reset ah value
	mov al, 13 ; Switch video mode
	int 10h ; video BIOS interrupt		
	ret
	
_DrawLine:
	push 	bp
	mov		bp, sp
	sub 	sp, 16 ; reserve space for local variables
; ------ 	Assign X and Y
	mov ax, [bp + x0]
	mov [bp - X], ax 	;x = x0
	mov bx, [bp + y0]
	mov [bp - Y], bx	;y = y0
; ------ 	Delta X
	mov ax, [bp + x1] 
	mov bx, [bp + x0] 
	sub ax, bx
	cmp ax, 0	; Get abs delta Y
	jg positiveDX
	neg ax
	mov [bp - deltaX], ax
	positiveDX:
	mov [bp - deltaX], ax
; ------ 	Delta Y	
	mov ax, [bp + y1]
	mov bx, [bp + y0]
	sub ax, bx	; y1 - y0
	cmp ax, 0	; Get abs delta Y
	jg positiveDY
	neg ax
	mov [bp - deltaY], ax
	positiveDY:
	mov [bp - deltaY], ax
; ------ 	Check sx
	mov cx, 1
	mov ax, [bp + x0]
	mov bx, [bp + x1]
	cmp ax, bx
	jl x0LessThanX1
	neg cx	;else
	mov [bp - sX], cx
	x0LessThanX1:	;	if true
	mov [bp - sX], cx
; ------ 	Check sy
	mov cx, 1	
	mov ax, [bp + y0]
	mov bx, [bp + y1]
	cmp ax, bx
	jl y0LessThanY1
	neg cx	; else
	mov [bp - sY], cx
	y0LessThanY1:	;	if true
	mov [bp - sY], cx
; -----		Get Distance (err)	
	mov ax, [bp - deltaX]
	mov bx,	[bp - deltaY]
	sub ax, bx
	mov [bp - err], ax
; ------ 	Do-While loop
Do_while_loop:
; -----		draw pixel	
	mov ax, [bp - X]
	mov bx, [bp - Y]
	mov cx,	[bp + color]		
	push ax
	push bx	
	push cx
	call _SetPixel
; -----		if x = x1 exit loop
	mov ax, [bp - X]
	mov bx, [bp + x1]
	cmp ax, bx
	je exit_loop
; -----		if y = y1 exit loop
	mov ax, [bp - Y]
	mov bx, [bp + y1]
	cmp ax, bx
	je exit_loop
; -----		get e2
	mov ax, [bp - err]
	add ax, ax
	mov [bp - e2], ax
; -----		if  e2 > -dy
	mov ax, [bp - e2]
	mov bx, [bp - deltaY]
	neg bx
	cmp ax, bx
	jl e2LessThanNegDY
	mov cx, [bp - err]
	add cx, bx	;	err + -dy
	mov [bp - err], cx	;	err = err + -dy
	mov cx, [bp - X]
	mov dx, [bp - sX]
	add cx, dx	;	x + sx
	mov [bp - X], cx	;	x = x + sx
	e2LessThanNegDY:
	; 	Do Nothing
; -----		if  e2 > dx
	mov ax, [bp - e2]
	mov bx, [bp - deltaX]
	cmp ax, bx
	jg e2GreaterThanDX
	mov cx, [bp - err]
	add cx, bx	;	err + dx
	mov [bp - err], cx	;	err = err + dx
	mov cx, [bp - Y]
	mov dx, [bp - sY]
	add cx, dx	;	y + sy
	mov [bp - Y], cx
	e2GreaterThanDX:
	; 	Do Nothing
;Condition of do-while
	mov ax, [bp + x1] 
	mov bx, [bp - X]
	cmp bx, ax
	jne Do_while_loop
	mov sp, bp
	pop bp
	ret
	
 exit_loop:
	hlt	
	
_SetPixel:
	push 	bp
	mov		bp, sp
	mov bh, 0h
	mov cx, [bp + 8] ; column
	mov dx, [bp + 6] ; row
	mov Al, [bp + 4] ; color
	mov ah,0Ch
	int 10h
	mov sp, bp
	pop bp
	ret	