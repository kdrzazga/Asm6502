.const BASIC = $0801
.const GETIN  =  $ffe4
.const SCNKEY =  $ff9f
.const SOFT_RESET = $fce2
.const SPACE = 32
.const CLRSCR = $ff81
.const KERNAL_CHAR_ROM = $e544
	
.const textMemoryBank = $0400
.const screenControlRegister = $d016
.const memorySetupRegister = $d018
.const rasterLineCell = $d012
.const textScreenWidth = 40
BasicUpstart2(start)
			* = $825
start: 		sei

			jsr KERNAL_CHAR_ROM
			lda %11000
			sta memorySetupRegister
			
			.const row = 11
			.const column = 8
			.const target = textMemoryBank + row * textScreenWidth + column
			ldx #0
			ldy #0			
loop:		lda text,y
			cmp #$ff
			beq exit
			clc
			sta target,x
			adc #$40
			sta target+40,x
			inx
			adc #$40
			sta target,x
			adc #$40
			sta target+40,x
			inx
			iny
			jmp loop
exit:
			jmp *
			jmp BASIC						

text: 		.text "siemanerko !"	
			.byte $ff

//------------------------------------------------------------------------------------
			* = $2000 "Charset"
			.var charsetPic = LoadPicture("2x2char.gif", List().add($000000, $ffffff))   // <- Here we load a gif picture
			.fill $200, charsetPic.getSinglecolorByte(  2*(i>>3),   i&7) 				 // <- getSinglecolorByte gives a converted singlecolor byte  	
			.fill $200, charsetPic.getSinglecolorByte(  2*(i>>3), 8+(i&7)) 				 // (You can also get a multicolor byte or a raw value)
			.fill $200, charsetPic.getSinglecolorByte(1+2*(i>>3),    i&7) 
			.fill $200, charsetPic.getSinglecolorByte(1+2*(i>>3), 8+(i&7)) 
			