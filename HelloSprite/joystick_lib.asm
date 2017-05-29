direction_x     byte           0
direction_y     byte           0
fire            byte           $ff

take_action_according_to_joy1_state

          lda direction_x
          cmp JOY_DEC
          beq on_joy_up
          
          lda direction_x
          cmp JOY_INC
          beq on_joy_down          

          lda direction_y
          cmp JOY_DEC
          beq on_joy_left
          
          lda direction_y 
          cmp JOY_INC
          beq on_joy_right

          lda fire
          cmp JOY_FIRE
          beq on_joy_fire

          jmp on_no_joy_operation   

read_joy1_state 
                    
          lda           JOY1_PTR     ; get input from port 2 only
          jsr           read_joy_state
          rts

read_joy_state
          jsr           clear_fire
          ldy            #0        ; this routine reads and decodes the                
          ldx            #0        ; joystick/firebutton input data in
          lsr                      ; the accumulator. this least significant
          bcs            not_down  ; 5 bits contain the switch closure
          dey                      ; information. if a switch is closed then it
not_down  lsr                      ; produces a zero bit. if a switch is open then
          bcs            not_left  ; it produces a one bit. The joystick dir-
          iny                      ; ections are right, left, forward, backward
not_left  lsr                      ; bit3=right, bit2=left, bit1=backward,
          bcs            not_right ; bit0=forward and bit4=fire button.
          dex                      ; at rts time direction_x and direction_y contain 2's compliment
not_right lsr                      ; direction numbers i.e. $ff=-1, $00=0, $01=1.
          bcs            not_up    ; direction_x=1 (move right), direction_x=-1 (move left),
          inx                      ; direction_x=0 (no x change). direction_y=-1 (move up screen),
not_up    lsr
          bcs            not_fire  ; direction_y=0 (move down screen), direction_y=0 (no y change).
          lda            JOY_FIRE
          sta            fire
not_fire
          stx            direction_y ; the forward joystick position corresponds
          sty            direction_x ; to move up the screen and the backward

          rts                        ; position to move down screen.

clear_fire
          ldx            #$00
          sty            fire
          rts

JOY2_PTR = $dc00
JOY1_PTR = $dc01

JOY_NO_CHANGE = #$00
JOY_DEC = #$ff
JOY_INC = #$01

JOY_FIRE = #$01
