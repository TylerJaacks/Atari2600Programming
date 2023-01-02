	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
Reset
	lda #$40
        sta COLUBK
        
        ldx #$70
        stx COLUP0
        
        ldx #%00000001
        stx CTRLPF
StartOfFrame
	; Start of vertical blanking.
        lda #0
        sta VBLANK
        
        lda #2
        sta VSYNC
        
        ; 3 scanlines of VSYNCH singal.
        REPEAT 3
        	sta WSYNC
        REPEND
        
        lda #0
        sta VSYNC
        
        ; 37 scanlines of vertical blank.
        REPEAT 37
        	sta WSYNC
        REPEND
        
        ; ---------------------------
        ; 192 scanlines of picture.
        ; ---------------------------
        ldx #192
        
Main:
	lda PFData0,X
        sta PF0
        lda PFData1,X
        sta PF1
        lda PFData2,X
        sta PF2
        sta WSYNC
        dex
        cpx #192
        bne Main
        
        ; ---------------------------
        ; End of picture scanlines.
        ;----------------------------
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
                
        jmp StartOfFrame
        
PLAYER1:
	.byte #%01000001
        .byte #%01000010
        .byte #%00100100
        .byte #%00011000
        .byte #%00011000
        .byte #%00100100
        .byte #%01000010
        .byte #%10000001
        
PLAYER2:
	.byte #%00011000
        .byte #%00100100
        .byte #010000010
        .byte #%10000001
        .byte #%10000001
        .byte #%01000010
        .byte #%00100100
        .byte #%00011000
PFData0:
	.byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
        .byte #%00010000
       	.byte #%00010000
PFData1:
	.byte #%00010000
        .byte #%00001000
        .byte #%00001000
        .byte #%00000000
        .byte #%00001000
        .byte #%00000100
        .byte #%00000100
	.byte #%00000010
        .byte #%00000010
        .byte #%00000001
        .byte #%00000010
        .byte #%00000001
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
PFData2:
	.byte #%10000000
        .byte #%10000000
        .byte #%10000001
        .byte #%00000000
        .byte #%00000000
        .byte #%00000000
        .byte #%10000000
        .byte #%10000001
        .byte #%10000011
        .byte #%01000010
        .byte #%01000010
        .byte #%01000000
        .byte #%00100000
        .byte #%00000100
        .byte #%10000110
        .byte #%10000000
        .byte #%00100000
        .byte #%10011100
        .byte #%10000100
        .byte #%10000000

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END