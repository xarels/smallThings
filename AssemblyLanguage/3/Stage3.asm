;	Stage 1 of the asssignment code
;
Change_Video_Mode_To_VGA:
	mov ah, 0h ;reset ah value
	mov al, 13 ; Switch video mode
	int 10h ; video BIOS interrupt
	ret
	
_DrawCircleBres:
	;----- [bp + value]
	%assign xc 10
	%assign yc 8
	%assign r 6
	%assign color 4
;----- [bp - value]	
	%assign X 6
	%assign Y 4
	%assign P 2
	
	push 	bp
	mov 	bp, sp
	sub 	sp, 6
	
	mov word[bp - X], 0 ; x = 0
	
	mov ax, [bp + r]
	mov [bp - Y], ax ; y = r
	
	mov word[bp - P], 3
	add ax, [bp + r] ; ax hold r from before
	sub word[bp - P], ax
	
	While_Loop:	
	;draw pixel
	;x1
	mov ax, [bp + xc] 
	mov bx, [bp - X];
	add ax, bx ; x = xc + x
	;y1
	mov bx, [bp + yc] 
	mov cx, [bp - Y];
	add bx, cx ; y = yc + y
	push ax
	push bx
	push word[bp + color] ; color
	call SetPixel

	;x2
	mov ax, [bp + xc] 
	mov bx, [bp - X];
	sub ax, bx ; x = xc - x
	;y2
	mov bx, [bp + yc] 
	mov cx, [bp - Y];
	add bx, cx ;  y = yc + y	
	push ax
	push bx
	push word[bp + color]	
	call SetPixel
	
	;x3
	mov ax, [bp + xc] 
	mov bx, [bp - X];
	add ax, bx ; x = xc + x
	;y3
	mov bx, [bp + yc] 
	mov cx, [bp - Y];
	sub bx, cx ; y = yc - y
	push ax
	push bx
	push word[bp + color]
	call SetPixel
	
	;x4
	mov ax, [bp + xc] 
	mov bx, [bp - X];
	sub ax, bx ; x = xc - x
	;y4
	mov bx, [bp + yc] 
	mov cx, [bp - Y];
	sub bx, cx ; y = yc - y		
	push ax
	push bx
	push word[bp + color]
	call SetPixel
	
	; x5
	mov ax, [bp + xc] 
	mov bx, [bp - Y];
	add ax, bx ; x = xc + y
	; y5
	mov bx, [bp + yc] 
	mov cx, [bp - X];
	add bx, cx ; y = yc + x
	push ax
	push bx
	push word[bp + color]	
	call SetPixel		

; x6
	mov ax, [bp + xc] 
	mov bx, [bp - Y];
	add ax, bx ; x = xc + y
	push ax
	; y6
	mov bx, [bp + yc] 
	mov cx, [bp - X];
	sub bx, cx ; y = yc - x
	push bx
	push word[bp + color]	
	call SetPixel
	
	; x7
	mov ax, [bp + xc] 
	mov bx, [bp - Y];
	sub ax, bx ; x = xc + y
	push ax
	; y7
	mov bx, [bp + yc] 
	mov cx, [bp - X];
	add bx, cx ; y = yc - x
	push bx
	push word[bp + color]	
	call SetPixel
	
	; x8
	mov ax, [bp + xc] 
	mov bx, [bp - Y];
	sub ax, bx ; x = xc + y
	push ax
	; y8
	mov bx, [bp + yc] 
	mov cx, [bp - X];
	sub bx, cx ; y = yc - x
	push bx
	push word[bp + color]	
	call SetPixel
	
	mov ax, [bp - X]
	cmp ax, [bp - Y]
	je Exit
	
	;inc x
	add word[bp - X], 1	
	;calculation for else
	mov ax, [bp - X]
	shl ax, 2
	add ax, 6
	add ax, [bp - P] ; p+4*(x)+6;	
	cmp word[bp - P], 0
	jl	PLZ
	; p = p + 4 * (x-y) + 10
	mov ax, [bp - X]
	sub ax, [bp - Y]
	shl ax, 2
	add ax, 10
	add ax, [bp - P]	;p+4*(x-y)+10;
	mov [bp - P], ax ; p=p+4*(x-y)+10;
	;dec y
	sub word[bp - Y], 1
	PLZ:
	mov [bp - P], ax ; p=p+4*(x)+6;

	mov ax, [bp - Y]
	cmp [bp - X], ax ; x <= y
	jle While_Loop
	pop bp
	mov sp, bp
	ret

Exit:
hlt	
	
_FillRectangle:	
;----- [bp + value]
	%assign x 12
	%assign y 10
	%assign rHeight 8
	%assign rWidth 6
	%assign color 4
;----- [bp - value]	
	%assign recHeight 4
	%assign recWidth 2

	push 	bp
	mov		bp, sp
	sub 	sp, 4 ; reserve space for local variables
	
	mov dx, [bp + y]	; set y pixel
	mov di, [bp + rHeight]		
	add di, dx ; y + height
	mov [bp - recHeight], di
	
	mov si, [bp + rWidth]
	add si, [bp + x]; x + width
	mov [bp - recWidth], si
	
	mov bh, 0h
	mov Al, [bp + color] ; color	
	mov ah,0Ch
	
	SetX:
	mov cx, [bp + x]
	
	SetY:	
	int 10h ; draw pixel
	; inc X
	add cx, 1
	; if x< width jmp loop
	cmp cx, [bp - recWidth]
	jb SetY	
	; inc Y
	add dx, 1
	; if y< height jmp loop
	cmp dx, [bp - recHeight]
	jb SetX
	
	mov	sp, bp
	pop bp
	ret
	
SetPixel:
	push bp
	mov bp, sp
	mov bh, 0h
	mov cx, [bp + 8] ; column
	mov dx, [bp + 6] ; row
	mov Al, [bp + 4] ; color
	mov ah,0Ch
	int 10h
	mov sp,bp
	pop bp
	ret