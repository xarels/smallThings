; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "bpb.asm"						; A copy of the BIOS Parameter Block (i.e. information about the disk format)
%include "floppy16.asm"					; Routines to access the floppy disk drive
%include "fat12.asm"					; Routines to handle the FAT12 file system
%include "functions_16.asm"
%include "a20.asm"
%include "Stage1.asm"

; This is the real mode address where we will initially load the kernel
%define	KERNEL_RMODE_SEG		1000h
%define KERNEL_RMODE_OFFSET		0000h

; Kernel name (Must be a 8.3 filename and must be 11 bytes exactly)
ImageName     db "KERNEL  SYS"

; This is where we will store the size of the kernel image in sectors (updated just before jump to kernel to be kernel size in bytes)
KernelSize    dd 0

; Used to store the number of the boot device

boot_device	  db  0				

;	Start of the second stage of the boot loader
	
Second_Stage:
    mov		[boot_device], dl		; Boot device number is passed in from first stage in DL. Save it to pass to kernel later.

    mov 	si, second_stage_msg	; Output our greeting message
    call 	Console_WriteLine_16

	call	Enable_A20
	
	push 	dx						; Save the number containing the mechanism used to enable A20
	mov		si, dx					; Display the appropriate message that indicates how the A20 line was enabled
	add		si, dx
	mov		si, [si + a20_message_list]
	call	Console_WriteLine_16
	pop		dx						; Retrieve the number
	cmp		dx, 0					; If we were unable to enable the A20 line, we cannot continue the boot
	je		Cannot_Continue

; 	We are now going to load the kernel into memory
	
;	First, load the root directory table
	call	LoadRootDirectory

;	Load kernel.sys.  We have to load it into conventional memory since the BIOS routines
;   can only access conventional memory.  We will relocate it to high memory later
  
	mov		ebx, KERNEL_RMODE_SEG	; BX:BP points to memory address to load the file to
    mov		bp, KERNEL_RMODE_OFFSET
	mov		si, ImageName			; The file to load
	call	LoadFile				; Load the file

	mov		dword [KernelSize], ecx	; Save size of kernel (in sectors)
	cmp		ax, 0					; Test for successful load
	je		Switch_To_Protected_Mode

	mov		si, msgFailure			; Unable to load kernel.sys - print error
	call	Console_WriteLine_16
	
	call    Change_Video_Mode_To_VGA ; change video mode	
	
	; assign coordinates and param (x0,y0,x1,y1,color)
	push word 0; x0 
	push word 0; y0 
	push word 160; x1
	push word 100; y1
	push word 15; color 
	call	_DrawLine
	hlt
	
	
Cannot_Continue:	
	mov		si, wait_for_key_msg
	call	Console_WriteLine_16
	mov		ah, 0
	int     16h                    	; Wait for key press before continuing
	int     19h                     ; Warm boot computer
	hlt

; 	We are now ready to switch to 32-bit protected mode.  We will see this next week.

Switch_To_Protected_Mode:

	hlt								; For now, we just stop
	
	
%include "messages.asm"
hello db 'hello',0

	times 3584-($-$$) db 0	