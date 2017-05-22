*=$0801

          WORD           $0d08 ;signature
          WORD           $baca
          BYTE           153, $20 ;print (space)
          BYTE           199 ; CHR$ command
          TEXT           "(14):"
          BYTE           $9e ;SYS command
          TEXT           "2069"
          BYTE           $00
