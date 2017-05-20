*=$1000

read_joy1_state
          lda            JOY1_PTR  
          ora            FIRE_PRESSED_MASK
          cmp            #$ff      
          beq            set_fire_pressed 

          lda            JOY1_PTR  
          ora            JOY1_RIGHT_MASK
          cmp            #$ff      
          beq            set_right_pressed 

;          lda            JOY1_PTR  
;          ora            JOY1_LEFT_MASK
;          cmp            #$ff      
;          beq            set_left_pressed 

;          lda            JOY1_PTR  
;          ora            JOY1_UP_MASK
;          cmp            #$ff      
;          beq            set_up_pressed

;          lda            JOY1_PTR  
;          ora            JOY1_DOWN_MASK
;          cmp            #$ff      
;          beq            set_down_pressed  

clr_previous_joy_status
          lda            JOY1_NO_OPERATION       
          sta            JOY_OPERATION
          rts
set_fire_pressed
          lda            JOY1_FIRE
          jmp store_operation

set_right_pressed
          lda            JOY1_RIGHT
          jmp store_operation

set_left_pressed
          lda            JOY1_LEFT
          jmp store_operation

set_up_pressed
          lda            JOY1_UP
          jmp store_operation

set_down_pressed
          lda            JOY1_DOWN

store_operation   
          sta            JOY_OPERATION
          rts


JOY2_PTR  = $dc00
JOY1_PTR  = $dc01

JOY1_NO_OPERATION = #$00
JOY1_FIRE = #$01
JOY1_LEFT = #$02
JOY1_RIGHT = #$03
JOY1_UP = #$04
JOY1_DOWN = #$05

FIRE_PRESSED_MASK = #$ef                  ;bit 5 of JOY1_PTR is fire ->  mask=11101111
JOY1_RIGHT_MASK = #$f7                    ;bit 6 of JOY1_PTR is fire ->  mask=11110111
JOY1_LEFT_MASK = #$fb                     ;bit 7 of JOY1_PTR is fire -> mask=11111011
JOY1_DOWN_MASK = #$fd                     ;bit 8 of JOY1_PTR is fire -> mask=11111101
JOY1_UP_MASK = #$fe                       ;bit 5 of JOY1_PTR is fire -> mask=11111110

JOY_OPERATION
          byte           0               ; 0 - nothing, 1-5 fire or move
