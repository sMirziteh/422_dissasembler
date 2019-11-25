*-----------------------------------------------------------
* Title      :  TEST PROGRAM
* Written by :  Team nibble (NICK, SHELBY, AND ZOE)
* Date       :
* Description:  TEST program to dissasemble
*-----------------------------------------------------------

		org $8000	* start at this address
START	NOP	* first instruction NOP for testing
	    JSR     TEST_MOVE
        JSR     TEST_MOVEA  
        JSR     TEST_NOT
        NOP     * test nop
        JSR     TEST_MOVEM
        JSR     TEST_LEA
        JSR     TEST_ADDQ
        JSR     TEST_BRA
    
    SIMHALT  

TEST_MOVE:
    LEA $4000,A1	* init Address registers
	LEA $4000,A2
	MOVE.L #$44444444,D0	* init data registers
	MOVE.L #$22222222,D1
    
* Testing all EAs for MOVE.B
	MOVE.B	D0,D1	* Data register direct to Data register direct
	MOVE.B	D0,(A2)	* Data register direct to Address register indirect
	MOVE.B	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.B	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.B	D0,$00010000	* Data register direct to Absolute Long Address
	MOVE.B	D0,$7000	* Data register direct to Absolute Word Address
	MOVE.B	(A1),D1	* Address register indirect to Data register direct
	MOVE.B	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.B	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.B	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.B	(A1),$00010000	* Address register indirect to Absolute Long Address
	MOVE.B	(A1),$7000	* Address register indirect to Absolute Word Address
	MOVE.B	#$44,D1	* Immediate addressing to Data register direct
	MOVE.B	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.B	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.B	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.B	#$44,$00010000	* Immediate addressing to Absolute Long Address
	MOVE.B	#$44,$7000	* Immediate addressing to Absolute Word Address
	MOVE.B	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.B	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.B	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.B	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.B	(A1)+,$00010000	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.B	(A1)+,$7000	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.B	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.B	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.B	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.B	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.B	-(A1),$00010000	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.B	-(A1),$7000	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.B	$00010000,D1	* Absolute Long Address to Data register direct
	MOVE.B	$00010000,(A2)	* Absolute Long Address to Address register indirect
	MOVE.B	$00010000,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.B	$00010000,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.B	$00010000,$00010000	* Absolute Long Address to Absolute Long Address
	MOVE.B	$00010000,$7000	* Absolute Long Address to Absolute Word Address
	MOVE.B	$7000,D1	* Absolute Word Address to Data register direct
	MOVE.B	$7000,(A2)	* Absolute Word Address to Address register indirect
	MOVE.B	$7000,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.B	$7000,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.B	$7000,$00010000	* Absolute Word Address to Absolute Long Address
	MOVE.B	$7000,$7000	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.W
	MOVE.W	D0,D1	* Data register direct to Data register direct
	MOVE.W	D0,A2	* Data register direct to Address register direct
	MOVE.W	D0,(A2)	* Data register direct to Address register indirect
	MOVE.W	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.W	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.W	D0,$00010000	* Data register direct to Absolute Long Address
	MOVE.W	D0,$7000	* Data register direct to Absolute Word Address
	MOVE.W	A1,D1	* Address register direct to Data register direct
	MOVE.W	A1,A2	* Address register direct to Address register direct
	MOVE.W	A1,(A2)	* Address register direct to Address register indirect
	MOVE.W	A1,(A2)+	* Address register direct to Address Register Indirect with post incrementing
	MOVE.W	A1,-(A2)	* Address register direct to Address Register Indirect with pre decrementing
	MOVE.W	A1,$00010000	* Address register direct to Absolute Long Address
	MOVE.W	A1,$7000	* Address register direct to Absolute Word Address
	MOVE.W	(A1),D1	* Address register indirect to Data register direct
	MOVE.W	(A1),A2	* Address register indirect to Address register direct
	MOVE.W	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.W	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.W	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.W	(A1),$00010000	* Address register indirect to Absolute Long Address
	MOVE.W	(A1),$7000	* Address register indirect to Absolute Word Address
	MOVE.W	#$44,D1	* Immediate addressing to Data register direct
	MOVE.W	#$44,A2	* Immediate addressing to Address register direct
	MOVE.W	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.W	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.W	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.W	#$44,$00010000	* Immediate addressing to Absolute Long Address
	MOVE.W	#$44,$7000	* Immediate addressing to Absolute Word Address
	MOVE.W	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.W	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.W	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.W	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.W	(A1)+,$00010000	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.W	(A1)+,$7000	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.W	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.W	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.W	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.W	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.W	-(A1),$00010000	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.W	-(A1),$7000	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.W	$00010000,D1	* Absolute Long Address to Data register direct
	MOVE.W	$00010000,(A2)	* Absolute Long Address to Address register indirect
	MOVE.W	$00010000,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.W	$00010000,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.W	$00010000,$00010000	* Absolute Long Address to Absolute Long Address
	MOVE.W	$00010000,$7000	* Absolute Long Address to Absolute Word Address
	MOVE.W	$7000,D1	* Absolute Word Address to Data register direct
	MOVE.W	$7000,(A2)	* Absolute Word Address to Address register indirect
	MOVE.W	$7000,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.W	$7000,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.W	$7000,$00010000	* Absolute Word Address to Absolute Long Address
	MOVE.W	$7000,$7000	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.L
	MOVE.L	D0,D1	* Data register direct to Data register direct
	MOVE.L	D0,A2	* Data register direct to Address register direct
	MOVE.L	D0,(A2)	* Data register direct to Address register indirect
	MOVE.L	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.L	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.L	D0,$00010000	* Data register direct to Absolute Long Address
	MOVE.L	D0,$7000	* Data register direct to Absolute Word Address
	MOVE.L	A1,D1	* Address register direct to Data register direct
	MOVE.L	A1,A2	* Address register direct to Address register direct
	MOVE.L	A1,(A2)	* Address register direct to Address register indirect
	MOVE.L	A1,(A2)+	* Address register direct to Address Register Indirect with post incrementing
	MOVE.L	A1,-(A2)	* Address register direct to Address Register Indirect with pre decrementing
	MOVE.L	A1,$00010000	* Address register direct to Absolute Long Address
	MOVE.L	A1,$7000	* Address register direct to Absolute Word Address
	MOVE.L	(A1),D1	* Address register indirect to Data register direct
	MOVE.L	(A1),A2	* Address register indirect to Address register direct
	MOVE.L	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.L	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.L	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.L	(A1),$00010000	* Address register indirect to Absolute Long Address
	MOVE.L	(A1),$7000	* Address register indirect to Absolute Word Address
	MOVE.L	#$44,D1	* Immediate addressing to Data register direct
	MOVE.L	#$44,A2	* Immediate addressing to Address register direct
	MOVE.L	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.L	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.L	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.L	#$44,$00010000	* Immediate addressing to Absolute Long Address
	MOVE.L	#$44,$7000	* Immediate addressing to Absolute Word Address
	MOVE.L	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.L	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.L	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.L	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.L	(A1)+,$00010000	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.L	(A1)+,$7000	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.L	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.L	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.L	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.L	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.L	-(A1),$00010000	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.L	-(A1),$7000	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.L	$00010000,D1	* Absolute Long Address to Data register direct
	MOVE.L	$00010000,(A2)	* Absolute Long Address to Address register indirect
	MOVE.L	$00010000,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.L	$00010000,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.L	$00010000,$00010000	* Absolute Long Address to Absolute Long Address
	MOVE.L	$00010000,$7000	* Absolute Long Address to Absolute Word Address
	MOVE.L	$7000,D1	* Absolute Word Address to Data register direct
	MOVE.L	$7000,(A2)	* Absolute Word Address to Address register indirect
	MOVE.L	$7000,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.L	$7000,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.L	$7000,$00010000	* Absolute Word Address to Absolute Long Address
	MOVE.L	$7000,$7000	* Absolute Word Address to Absolute Word Address
	RTS


TEST_MOVEA:
    MOVE.L  #400,D1 * init d1 with data for moveA test
    * test all eas for movea
    MOVEA.W D1,A1
    MOVEA.W A1,A2
    MOVEA.W (A1),A3
    MOVEA.W (A1)+,A4
    MOVEA.W -(A1),A5
    MOVEA.W $3232,A6
    MOVEA.W $000AAAAA,A0
    MOVEA.W #$0444,A1
    
    MOVEA.L D1,A1
    MOVEA.L A1,A2
    MOVEA.L (A1),A3
    MOVEA.L (A1)+,A4
    MOVEA.L -(A1),A5
    MOVEA.L $3232,A6
    MOVEA.L $000AAAAA,A0
    MOVEA.L #$0444,A1

    RTS
    
TEST_NOT:
    LEA     $7000,A1 * init address for Not to act on
    * test all eas for NOT
    NOT.B   D1
    NOT.B   (A1)
    NOT.B   (A1)+
    NOT.B   -(A1)
    NOT.B   $7000
    NOT.B   $00010000
    
    NOT.W   D1
    NOT.W   (A1)
    NOT.W   (A1)+
    NOT.W   -(A1)
    NOT.W   $7000
    NOT.W   $00010000
    
    NOT.L   D1
    NOT.L   (A1)
    NOT.L   (A1)+
    NOT.L   -(A1)
    NOT.L   $7000
    NOT.L   $00010000
    RTS
    
TEST_MOVEM:
    LEA       $7000,A3 * init address register 
    * test long word
    MOVEM.L   D1,(A3)
    MOVEM.L   (A3),D1
    
    MOVEM.L   D1-D4/A4-A6,-(SP)
    MOVEM.L   (SP)+,D1-D4/A4-A6
    
    MOVEM.L   A0,$7000
    MOVEM.L   $7000,A0
    
    MOVEM.L   D7,$00010000
    MOVEM.L   $00010000,D7
    
    * test word
    MOVEM.W   D1,(A3)
    MOVEM.W   (A3),D1
    
    MOVEM.W   D1-D4/A4-A6,-(SP)
    MOVEM.W   (SP)+,D1-D4/A4-A6
    
    MOVEM.W   A0,$7000
    MOVEM.W   $7000,A0
    
    MOVEM.W   D7,$00010000
    MOVEM.W   $00010000,D7
    
    RTS
    

TEST_LEA:
    LEA     (A2),A1
    LEA     $7000,A3
    LEA     $00010000,A4
    RTS     

TEST_ADDQ:
    LEA     $7000,A5
    
    ADDQ    #2,A3 * when adding to address register entire register is used reguardless of size
    * test byte
    ADDQ.B  #1,D5
    ADDQ.B  #3,(A5)
    ADDQ.B  #4,(A5)+
    ADDQ.B  #5,-(A5)
    ADDQ.B  #6,$7000
    ADDQ.B  #7,$00010000

    * test word
    ADDQ.W  #1,D5
    ADDQ.W  #3,(A5)
    ADDQ.W  #4,(A5)+
    ADDQ.W  #5,-(A5)
    ADDQ.W  #6,$7000
    ADDQ.W  #7,$00010000
    
    * test long
    ADDQ.L  #1,D5
    ADDQ.L  #3,(A5)
    ADDQ.L  #4,(A5)+
    ADDQ.L  #5,-(A5)
    ADDQ.L  #6,$7000
    ADDQ.L  #7,$00010000
    
    RTS
    
    
TEST_BRA:
    * test branch always with 8,16, and 32bit displacement
    BRA.B _8BIT
RETURN_8BIT:
    BRA.W _16BIT
RETURN_16:
RETURN_32:
* cannot get 32 displacement to work
    RTS
    
_8BIT:
    BRA RETURN_8BIT
    
TEST_BCC:
    
    ORG $9000
_16BIT:
     BRA RETURN_16

               

	END	START
	
	


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
