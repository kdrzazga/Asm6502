set_colors
          lda            BLACK     
          sta            BORDER_COLOR_PTR
          sta            BACKGROUND_COLOR_PTR

          lda            YELLOW    
          sta            TXT_COLOR_PTR

          rts

BLACK     = #$00
WHITE     = #$01
GRAY      = #$02
LIGHT_GRAY = #$0F
YELLOW    = #$07

BORDER_COLOR_PTR = $d020
BACKGROUND_COLOR_PTR = $d021
TXT_COLOR_PTR = $0286
TXT_SCREEN_PTR = $0400

COMMODORE_KEY_BLOCKER = $0291 ; bit7 only = 0
