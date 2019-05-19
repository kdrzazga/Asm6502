//Kick Assembler
//BasicUpstart2(start)

.const InterruptStatusRegister1 = $d019
.const InterruptStatusRegister2 = $d01a
.const InterruptControlAndStatusRegister1 = $dc0d
.const InterruptControlAndStatusRegister2 = $dd0d
.const InterruptExecutionMSB = $fffe
.const InterruptExecutionLSB = $ffff
.const ProcessorPort = $0001

			* = $0960
music:		lda #$00
			jsr music_init
			sei
			lda #%00110101
			sta ProcessorPort
			lda #<irq1
			sta InterruptExecutionMSB
			lda #>irq1
			sta InterruptExecutionLSB

			lda #%10000001
			sta InterruptStatusRegister2
			lda #%01111111
			sta InterruptControlAndStatusRegister1
			sta InterruptControlAndStatusRegister2

			lda InterruptControlAndStatusRegister1
			lda InterruptControlAndStatusRegister2
			lda #$ff
			sta InterruptStatusRegister1

			cli
			//jmp *
			rts

irq1:  		pha
			txa
			pha
			tya
			pha
			lda #$ff
			sta	InterruptStatusRegister1

			jsr music_play
			pla
			tay
			pla
			tax
			pla
			rti

			*=$1000 "Music"
			.label music_init =*			// <- You can define label with any value (not just at the current pc position as in 'music_init:') 
			.label music_play =*+3			// <- and that is useful here
			.import binary "ode64.bin"

//----------------------------------------------------------
// A little macro
.macro SetBorderColor(color) {		// <- This is how macros are defined
	lda #color
	sta $d020
}
