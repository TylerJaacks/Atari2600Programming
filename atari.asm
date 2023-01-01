	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG.U var
        ORG $80
        
Counter ds.bs 1,0
        
        SEG
        ORG $F000
Reset
	lda #$40
        sta COLUBK
        
        ldx #$70
        stx COLUP0
        
        ldx #%00000000
        stx NUSIZ0
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
        
	sec
        sta WSYNC
        lda Counter
        and #127
        ldx #0
DivideLoop:
	sbc #15
        bcs DivideLoop
        
        eor #7
        asl
        asl
        asl
        asl
        
        sta.wx HMP0,X
        sta RESP0,X
        
        sta WSYNC
        sta HMOVE
        
       	ldx #0
        
        ; ---------------------------
        ; 192 scanlines of picture.
        ; ---------------------------
        REPEAT 15
        	lda PLAYER,X
                sta GRP0
                inx
        	sta WSYNC
        REPEND
        
        lda #0
        sta GRP0
               
        REPEAT 174
        	sta WSYNC
        REPEND
        ; ---------------------------
        ; End of picture scanlines.
        ;----------------------------
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK
        inc Counter

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
                
        jmp StartOfFrame
        
PLAYER:
	.byte #%00111100
        .byte #%11111111
        .byte #%00100100
        .byte #%00100100
        .byte #%00111100
        .byte #%00011000
        .byte #%00011000
        .byte #%01111110
        .byte #%01111110
        .byte #%11111111
        .byte #%11111111
        .byte #%11111111
        .byte #%11111111
        .byte #%01111110
        .byte #%00111100

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END