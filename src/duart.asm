.include "macros_65C02.inc65"

.zeropage
tmpstack:			.res 1
ptr1:					.res 1
;
; File generated by cc65 v 2.19 - Git a861d84
;
	.fopt		compiler,"cc65 v 2.19 - Git a861d84"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.macpack	longbranch

	.export	_duart_init
	.export _duart_putc
	.export _duart_getc
	.export _duart_puts
	.export _duart_put_newline

	DUART        = $CE00
	DUARTMRA     = DUART
	DUARTSRA     = DUART+$1
	DUARTCSRA    = DUART+$1
	DUARTCRA     = DUART+$2
	DUARTRXA     = DUART+$3
	DUARTTXA     = DUART+$3
	DUARTIPCR    = DUART+$4
	DUARTACR     = DUART+$4
	DUARTISR     = DUART+$5
	DUARTIMR     = DUART+$5
	DUARTCTU     = DUART+$6
	DUARTCTPU    = DUART+$6
	DUARTCTL     = DUART+$7
	DUARTCTPL    = DUART+$7
	DUARTMRB     = DUART+$8
	DUARTSRB     = DUART+$9
	DUARTCSRB    = DUART+$9
	DUARTCRB     = DUART+$A
	DUARTRXB     = DUART+$B
	DUARTTXB     = DUART+$B
	DUARTIVEC    = DUART+$C
	DUARTIPR     = DUART+$D
	DUARTSOPR    = DUART+$E
	DUARTROPR    = DUART+$F
	DUART_STATUS_RX_FULL    = 1 << 0
.segment "CODE"

_duart_init:  LDA #$B0          ; Reset MRA Pointer to $00
						STA DUARTCRA				;CE02
						LDA #$C9          ; Enable RX Watchdog, RX Interrupt level 16 bytes, 16 byte FIFO, Baud Extended mode I
						STA DUARTMRA				;CE00
						LDA #$53          ; disable RX controlled RTS, RX Interrupt level 16 bytes, No parity, 8 Bits per character
						STA DUARTMRA				;CE00
						LDA #$01
						STA DUARTSOPR				;CE0E
						LDA #$07          ; Enable TX CTS Control, 1 Stop Bit
						STA DUARTMRA			;CE00
						LDA #$60          ; Set timer mode external clock x1
						STA DUARTACR			;CE04
						LDA #$CC          ; Set TX/RX Baud to 250 000
						STA DUARTCSRA			;CE01
						LDA #$0A          ; Enable Timer/RxRDYA Interrupts
						STA DUARTIMR
						;LDA #$24          ; 100hz interval for Timer
						;STA DUARTCTPU
						;STZ DUARTCTL
						;LDA DUARTSOPR     ; Start timer
						LDA #$05
						STA DUARTCRA      ; CE02 Enable TX/RX on Channel A
						LDA #$0A
						STA DUARTCRB      ; CE0A Disable TX/RX on Channel B
						RTS

_duart_put_newline:  						PHA
						                    LDA #$0D
						                    JSR _duart_putc
						                    LDA #$0A
						                    JSR _duart_putc
						                    PLA
						                    RTS

_duart_putc: PHA
            LDA DUARTSRA
            AND #$04
            BEQ _duart_putc+1
            PLA
            STA DUARTTXA
            RTS

_duart_getc:
@wait_rxd_full:     lda DUARTSRA
						        and #DUART_STATUS_RX_FULL
						        beq @wait_rxd_full
						        lda DUARTRXA
						        rts

_duart_puts:phay
          	sta ptr1
          	stx ptr1 + 1
          	ldy #0
@next_char: lda (ptr1),y
          	beq @eos
          	jsr _duart_putc
          	iny
          	bne @next_char
@eos:       play
          	rts
