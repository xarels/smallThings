; BIOS Parameter Block

bpbBytesPerSector:  	dw 512			; Bytes per sector
bpbSectorsPerCluster: 	db 8			; Sectors per cluster
bpbReservedSectors: 	dw 8			; Number of reserved sectors
bpbNumberOfFATs: 	    db 2			; Number of copies of the file allocation table
bpbRootEntries: 	    dw 512			; Size of root directory
bpbTotalSectors: 	    dw 20160		; Total number of sectors on the disk (if disk less than 32MB)
bpbMedia: 	            db 0F8h			; Media descriptor
bpbSectorsPerFAT: 	    dw 8			; Size of file allocation table (in sectors)
bpbSectorsPerTrack: 	dw 63			; Number of sectors per track
bpbHeadsPerCylinder: 	dw 16			; Number of read-write heads
bpbHiddenSectors: 	    dd 1			; Number of hidden sectors
bpbTotalSectorsBig:     dd 0			; Number of sectors if disk greater than 32MB
bsDriveNumber: 	        db 80h			; Drive boot sector came from
bsUnused: 	            db 0			; Reserved
bsExtBootSignature: 	db 29h			; Extended boot sector signature
bsSerialNumber:	        dd 635B1B48h	; Disk serial number`
bsVolumeLabel: 	        db "BOOT DISK  "; Disk volume label
bsFileSystem: 	        db "FAT12   "	; File system type
