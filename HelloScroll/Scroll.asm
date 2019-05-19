//for KickAssembler
BasicUpstart2(initProg)

.const GETIN  =  $ffe4
.const SCNKEY =  $ff9f
.const SOFT_RESET = $fce2
.const SPACE = 32
.const CLRSCR = $ff81
	
.const textMemoryBank = $0400
.const screenControlRegister = $d016
.const memorySetupRegister = $d018
.const rasterLineCell = $d012

.const textLineWidth = 40
.const scrollLine = 24 * textLineWidth + textMemoryBank
.const memorySetup = %00010111 //Bits #0-#2: Horizontal raster scroll. #3: Screen width; 0 = 38 columns; 1 = 40 columns. #4: 1 = Multicolor mode on.
.const horizontalScroll = $c8
.const rasterLineForScroll = $ff - 255 //Raster line to generate interrupt at (bits #0-#7) - last textline of screen

//Changing raster to narrow bottom of the screen allows for smooth scrolling 13 is the height of single textline
.const finalRasterLine = $ff //Raster line to generate interrupt, ff = full screen

			*=$825
initProg:   jsr CLRSCR
mainProg: 	{
			sei
			lda #memorySetup
			sta memorySetupRegister

			// Wait for "raster scanner" to reach line $f2 (rasterLineForScroll) and set d016 (rasterLineCell)
mainLoop:
	        lda #rasterLineForScroll
			cmp rasterLineCell
			bne mainLoop
			jsr SCROLL

			// Wait for line $ff (finalRasterLine) and prepare next frame 
loop2:		lda #finalRasterLine
			cmp rasterLineCell
			bne loop2

			lda #horizontalScroll
			sta screenControlRegister
			jsr moveScroll
			
			jmp mainLoop

SCROLL:	
			lda #0									
			and #$07
			ora #$c0
			sta screenControlRegister
			rts			

moveScroll: 
			// Step d016
			dec SCROLL + 1
			lda SCROLL + 1
			and #$07
			cmp #$07
			bne exit
			
			// Move screen chars
			ldx #0
scrollLoop:
	        lda scrollLine + 1, x
			sta scrollLine, x
			inx
			cpx #textLineWidth - 1
			bne scrollLoop
			
			// Print new char
count:		ldx #0
			lda text, x
			sta scrollLine + textLineWidth - 1
			inx
							
			lda text, x			
			cmp endText
			bne over1
			ldx #0
over1:		stx count + 1
			
exit:		rts
				
quit:
	jmp SOFT_RESET			
	
text:		.text "SCROLLING!!! SCROLLING!!! SCROLLLLLLLING!!! Hello to everyone.      "
endText:	.byte $fe

#import "MusicIrq.asm"
}
