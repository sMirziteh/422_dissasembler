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
    

****************************************************
* This warning is normal when using 16bit addresses
* this is required to test absolute word addressing
* 
* WARNING: Forcing SHORT addressing disables range
* checking of extension word
****************************************************
*   test MOVE operations
        MOVE.B  #55,D0      * immediate addressing and data register direct addressing
        MOVE.B  D0,$D000.W  * data register direct to absolute word
        MOVE.B  D0,$D000.L  * data register direct to absolute long
        MOVE.B  #99,$D004.W * immediate to absolute word address
        MOVE.B  #99,$D004.L * immediate to absolute long address
        MOVE.B  D0,D1  * data register to data register
        MOVE.B  $D004.W,D0    * absolute word to data register
        MOVE.B  $D004.L,D0    * absolute long to data register
        MOVE.B  $D004.W,$D000.W * absolute word to absolute word
        MOVE.B  $D004.L,$D000.L * absolute long to absolute long
        MOVE.B  $D004.L,$D000.W * absolute Long to absolute word
        MOVE.B  $D004.W,$D000.L * absolute word to absolute long
        MOVE.B  D0,(A1)     * data register to indirect address register
        MOVE.B  #$EF,(A2)   * Immediate to indirect address register
        MOVE.B  (A1),(A2)   * indirect to indirect address registers
        MOVE.B  #55,(A1)+   * immediate to indirect post increment
        MOVE.B  #77,-(A1)   * immediate to indirect pre decrement
        MOVE.B  D0,(A1)+    * data register to indirect post increment
        MOVE.B  D1,-(A1)    * data register to inderect pre decrement
        MOVE.B  $D000.W,(A2)+ * absolute word to indirect post
        MOVE.B  $D000.W,-(A2) * Aboslute word to indirect pre
        MOVE.B  $D000.L,(A2)+ * absolute long to indirect post
        MOVE.B  $D000.L,-(A2) * Aboslute long to indirect pre
        MOVE.B  (A2)+,$D000.W * Indirect post to absolute word
        MOVE.B  -(A2),$D000.W * Indirect pre to absolute word
        MOVE.B  (A2)+,$D000.L * Indirect post to absolute long
        MOVE.B  -(A2),$D000.L * Indirect pre to absolute long
        MOVE.B  (A2)+,D1    * Indirect post to data register
        MOVE.B  -(A2),D1    * indirect pre to data register
        MOVE.B  (A1)+,(A2)+ * indirect post to indirect post
        MOVE.B  -(A1),-(A2) * indirect pre to indirect pre
        MOVE.B  -(A1),(A2)+ * indirect pre to indirect post
        MOVE.B  (A2)+,-(A1) * indirect post to indirect pre
        
        NOP
        
		END    START      
  
                    

DATA    DC.B    "here is some random test data",0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
