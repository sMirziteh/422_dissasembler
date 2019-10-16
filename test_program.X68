*-----------------------------------------------------------
* Title      :  TEST PROGRAM
* Written by :  Team nibble (NICK, SHELBY, AND ZOE)
* Date       :
* Description:  TEST program to dissasemble
*-----------------------------------------------------------
		ORG    $8000       * start far enough away from dissasembler program
START:  NOP

           
        MOVEA   #$D000,A1   * setup address registers with address for testing
        MOVEA   #$D004,A2
        
*   test MOVE operations
        MOVE.B  #55,D0      * test MOVE.B with immediate addressing and data register direct addressing
        MOVE.B  D0,$D000       * data register direct to absolute word
        MOVE.B  #99,$D004   * immediate to absolute word address
        MOVE.B  D0,D1  * data register to data register
        MOVE.B  $D004,D0    * absolute word to data register
        MOVE.B  $D004,$D000 * absolute word to absolute word
        MOVE.B  D0,(A1)     * data register to indirect address register
        MOVE.B  #$EF,(A2)   * Immediate to indirect AR
        MOVE.B  (A1),(A2)   * indirect to indirect
        MOVE.B  #55,(A1)+   * immediate to indirect AR post increment
        MOVE.B  #77,-(A1)   * immediate to indirect pre decrement
        MOVE.B  D0,(A1)+    * data register to indirect post increment
        MOVE.B  D1,-(A1)    * data register to inderect pre decrement
        MOVE.B  $D000,(A2)+ * absolute word to indirect post
        MOVE.B  $D000,-(A2) * Aboslute word to indirect pre
        MOVE.B  (A2)+,$D000 * Indirect post to absolute word
        MOVE.B  -(A2),$D000 * Indirect pre to absolute word
        MOVE.B  (A2)+,D1    * Indirect post to data register
        MOVE.B  -(A2),D1    * indirect pre to data register
        MOVE.B  (A1)+,(A2)+ * indirect post to indirect post
        MOVE.B  -(A1),-(A2) * indirect pre to indirect pre
        MOVE.B  -(A1),(A2)+ * indirect pre to indirect post
        MOVE.B  (A2)+,-(A1) * indirect post to indirect pre
        
        
		END    START      
  
                    

DATA    DC.B    "here is some random test data",0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
