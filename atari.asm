	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
        
Reset
	lda #$40
        sta COLUBK
        
        lda #$80
        sta COLUPF
        
        lda #$C0
        sta COLUP0
        
        lda #$1E
        sta COLUP1
        
	lda #%00010000
        sta CTRLPF
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
        
        ldx #$FF
        stx ENABL
        ; stx GRP0
	
        ldy #0
Main:
        ; 192 scanlines of picture.
	sta WSYNC
        lda THREE,Y
        sta PF1
        iny
        cpy #11
        bne Main
        
        lda #0
        ; sta GRP0
        sta ENABL
        sta PF1
        
        REPEAT 2
        	nop
        REPEND
        
        stx RESP0
        
        REPEAT 181
        	sta WSYNC
        REPEND
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
        
        jmp StartOfFrame
        
        ORG $FFF0

THREE: 
	.byte %11111111
        .byte %11111111
        .byte %00000111
        .byte %00000111
        .byte %11111111
        .byte %11111111
        .byte %00000111
        .byte %00000111
        .byte %11111111
        .byte %11111111

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END