print_at        ;AC - char to print X -x position Y - y position

        
        sta  TXT_SCREEN_PTR,x
        rts


MESSAGE
          text           "Hold Joy1 fire to open mouth            "
          text           "Press "
EXIT_KEY  text           "x"
          text           " to exit."
STRING_TERMINATION
          text           "$" ; don't repeat this char within the message

print_message
          ldx            #$00      
loop      lda            MESSAGE,x
          cmp            STRING_TERMINATION
          beq            end_print 
          and            REDUCE_TO_UPPERCASE_FACTOR      
          sta            TXT_SCREEN_PTR,x
          inx
          jmp            loop      
end_print
          rts


REDUCE_TO_UPPERCASE_FACTOR = #$3f
TXT_SCREEN_PTR = $0400
TXT_SCREEN_BLOCK2 = $0400 + 240
TXT_SCREEN_BLOCK3 = $0400 + 480
TXT_SCREEN_BLOCK4 = $0400 + 720
TXT_SCREEN_BLOCK5 = $0400 + 960
