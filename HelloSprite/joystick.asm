dx        byte           0
dy        byte           0
fire      byte           $ff

take_action_according_to_joy1_state

          lda dx
          cmp JOY_DEC
          beq on_joy_up
          
          lda dx
          cmp JOY_INC
          beq on_joy_down
          

          lda dy
          cmp JOY_DEC
          beq on_joy_left
          
          lda dy
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
          bcs            not_up      ; 5 bits contain the switch closure
          dey                      ; information. if a switch is closed then it
not_up    lsr                      ; produces a zero bit. if a switch is open then
          bcs            not_down    ; it produces a one bit. The joystick dir-
          iny                      ; ections are right, left, forward, backward
not_down  lsr                      ; bit3=right, bit2=left, bit1=backward,
          bcs            not_left  ; bit0=forward and bit4=fire button.
          dex                      ; at rts time dx and dy contain 2's compliment
not_left  lsr                      ; direction numbers i.e. $ff=-1, $00=0, $01=1.
          bcs            not_right ; dx=1 (move right), dx=-1 (move left),
          inx                      ; dx=0 (no x change). dy=-1 (move up screen),
not_right lsr
          bcs            not_fire  ; dy=0 (move down screen), dy=0 (no y change).
          lda            JOY_FIRE
          sta            fire
not_fire
          stx            dx        ; the forward joystick position corresponds
          sty            dy        ; to move up the screen and the backward

          rts                      ; position to move down screen.
                                   ;
                                   ; at rts time the carry flag contains the fire
                                   ; button state. if c=1 then button not pressed.
                                   ; if c=0 then pressed.

clear_fire
          ldx            #$00
          sty            fire
          rts

              

JOY2_PTR  = $dc00
JOY1_PTR  = $dc01

JOY_NO_CHANGE = #$00
JOY_DEC = #$01
JOY_INC = #$ff

JOY_FIRE = #$01
