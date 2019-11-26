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
        JSR     TEST_BCC
        JSR     TEST_MOVEQ
        JSR     TEST_DIVU
        JSR     TEST_OR
        JSR     TEST_SUB
        JSR     TEST_MULS
        JSR     TEST_AND
        JSR     TEST_ADD
        JSR     TEST_ADDA
        JSR     TEST_ASR_ASL_REG
        JSR     TEST_ASL_ASR_MEM
        JSR     TEST_LSR_LSL_REG
        JSR     TEST_LSL_LSR_MEM
    
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
    * test lea with different eas annd registers
    LEA     (A6),A0
    LEA     $7000,A1
    LEA     $00010000,A2
    LEA     (A4),A3
    LEA     $7000,A4
    LEA     $00010000,A5
    LEA     (A2),A6

    RTS     

TEST_ADDQ:
    LEA     $7000,A5
    LEA     $7000,A2
    LEA     $7000,A6

    ADDQ    #2,A3 * when adding to address register entire register is used reguardless of size
    * test byte
    ADDQ.B  #1,D1
    ADDQ.B  #3,(A5)
    ADDQ.B  #4,(A5)+
    ADDQ.B  #5,-(A5)
    ADDQ.B  #6,$7000
    ADDQ.B  #7,$00010000

    * test word
    ADDQ.W  #1,D5
    ADDQ.W  #3,(A2)
    ADDQ.W  #4,(A2)+
    ADDQ.W  #5,-(A2)
    ADDQ.W  #6,$7000
    ADDQ.W  #7,$00010000
    
    * test long
    ADDQ.L  #1,D3
    ADDQ.L  #3,(A6)
    ADDQ.L  #4,(A6)+
    ADDQ.L  #5,-(A6)
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
* label to branch to for 8 bit displacement   
_8BIT:
    BRA RETURN_8BIT
  
TEST_BCC:
    * test branch instructions 
    * CCR is set so branch is not taken
    MOVE.B  #$FF,D1
    BCS     _8BIT
    BVS     _8BIT
    BEQ     _8BIT
    BGE     _8BIT
    BGT     _8BIT
    BPL     _8BIT
    BLS     _8BIT
    
    BCS     _16BIT
    BVS     _16BIT
    BEQ     _16BIT
    BGE     _16BIT
    BGT     _16BIT
    BPL     _16BIT
    BLS     _16BIT
    
    LSL.B   #1,D1
    BCC     _8BIT
    BHI     _8BIT
    
    BCC     _16BIT
    BHI     _16BIT
    
    MOVE.B  #0,D1
    BMI     _8BIT
    BNE     _8BIT  
    
    BMI     _16BIT
    BNE     _16BIT 
    
    MOVE.B  #$7F,D1
    ADD.B   #$7F,D1
    BVC     _8BIT
    BLE     _8BIT
    BLT     _8BIT
    
    BVC     _16BIT
    BLE     _16BIT
    BLT     _16BIT

    
    RTS

TEST_MOVEQ:
    * test moveq with different values and registers
    MOVEQ   #0,D0  
    MOVEQ   #08,D1  
    MOVEQ   #$0B,D2  
    MOVEQ   #$0F,D3  
    MOVEQ   #$12,D4  
    MOVEQ   #$70,D5  
    MOVEQ   #$AB,D6
    MOVEQ   #$FE,D7
    
    RTS      

TEST_DIVU:
    LEA     $7000,A3
    LEA     $7000,A2
    LEA     $7002,A1
    
    DIVU    D7,D0
    DIVU    (A1),D1
    DIVU    (A2)+,D2
    DIVU    -(A3),D3
    DIVU    $7000,D4
    DIVU    $00010000,D5
    DIVU    #123,D6
    
    RTS

TEST_OR:
    * test or with different opmodes eas and registers
    * init address registers
    LEA     $7000,A6
    LEA     $7002,A2
    LEA     $7000,A0
    
    * test byte
    OR.B    D7,D0
    OR.B    (A6),D1
    OR.B    (A0)+,D2
    OR.B    -(A2),D3
    OR.B    $7004,D4
    OR.B    $00010000,D5
    OR.B    #$1A,D6

    OR.B    D7,$00010000
    OR.B    D6,$7000
    OR.B    D5,-(A2)
    OR.B    D4,(A0)+
    OR.B    D4,(A6)
    
    * test word
    LEA     $7000,A6
    LEA     $7002,A2
    LEA     $7000,A0
    
    OR.W    D7,D0
    OR.W    (A6),D1
    OR.W    (A0)+,D2
    OR.W    -(A2),D3
    OR.W    $7004,D4
    OR.W    $00010000,D5
    OR.W    #$310,D6

    OR.W    D7,$00010000
    OR.W    D6,$7000
    OR.W    D5,-(A2)
    OR.W    D4,(A0)+
    OR.W    D4,(A6)

    * test long        
    LEA     $7000,A6
    LEA     $7002,A2
    LEA     $7000,A0
    
    OR.L    D7,D0
    OR.L    (A6),D1
    OR.L    (A0)+,D2
    OR.L    -(A2),D3
    OR.L    $7004,D4
    OR.L    $00010000,D5
    OR.L    #$A001A,D6

    OR.L    D7,$00010000
    OR.L    D6,$7000
    OR.L    D5,-(A2)
    OR.L    D4,(A0)+
    OR.L    D4,(A6)
    
    RTS
    
TEST_SUB:
    LEA     $7000,A1
    LEA     $7002,A0
    LEA     $7000,A5
	LEA		$7000,A4
    
    * test long
    
    SUB.L    D7,D0
	SUB.L    A5,D7
    SUB.L    (A4),D1
    SUB.L    (A1)+,D2
    SUB.L    -(A0),D3
    SUB.L    $7004,D4
    SUB.L    $00010000,D5
    SUB.L    #$10FF01,D6

    SUB.L    D7,$00010000
    SUB.L    D6,$7000
    SUB.L    D5,-(A0)
    SUB.L    D4,(A1)+
    SUB.L    D4,(A4)
    
    * test word
    
    SUB.W    D7,D0
	SUB.W    A5,D7
    SUB.W    (A4),D1
    SUB.W    (A1)+,D2
    SUB.W    -(A0),D3
    SUB.W    $7004,D4
    SUB.W    $00010000,D5
    SUB.W    #$10AA,D6

    SUB.W    D7,$00010000
    SUB.W    D6,$7000
    SUB.W    D5,-(A0)
    SUB.W    D4,(A1)+
    SUB.W    D4,(A4)
    
    * test byte
    
    SUB.B    D7,D0
    SUB.B    (A4),D1
    SUB.B    (A1)+,D2
    SUB.B    -(A0),D3
    SUB.B    $7004,D4
    SUB.B    $00010000,D5
    SUB.B    #$27,D6

    SUB.B    D7,$00010000
    SUB.B    D6,$7000
    SUB.B    D5,-(A0)
    SUB.B    D4,(A1)+
    SUB.B    D4,(A4)

    RTS
    
TEST_MULS:
    LEA     $7002,A5
    LEA     $7000,A4
	LEA		$7000,A3
    
    MULS.W    D7,D6
    MULS.W    (A4),D5
    MULS.W    (A3)+,D4
    MULS.W    -(A5),D3
    MULS.W    $7004,D2
    MULS.W    $00010000,D1
    MULS.W    #$10B,D0

    RTS
    
TEST_AND:

    * test and with different opmodes eas and registers
    * init address registers
    LEA     $7000,A0
    LEA     $7002,A1
    LEA     $7000,A2
    
    * test byte
    AND.B    D7,D0
    AND.B    (A0),D1
    AND.B    (A2)+,D2
    AND.B    -(A1),D3
    AND.B    $7004,D4
    AND.B    $00010000,D5
    AND.B    #$1A,D6

    AND.B    D7,$00010000
    AND.B    D6,$7000
    AND.B    D5,-(A1)
    AND.B    D4,(A2)+
    AND.B    D4,(A0)
    
        * test word
    LEA     $7000,A3
    LEA     $7002,A4
    LEA     $7000,A5
    
    AND.W    D7,D0
    AND.W    (A3),D1
    AND.W    (A5)+,D2
    AND.W    -(A4),D3
    AND.W    $7004,D4
    AND.W    $00010000,D5
    AND.W    #$310,D6

    AND.W    D7,$00010000
    AND.W    D6,$7000
    AND.W    D5,-(A4)
    AND.W    D4,(A5)+
    AND.W    D4,(A3)
    
    * test long        
    LEA     $7000,A3
    LEA     $7002,A6
    LEA     $7000,A5
    
    AND.L    D7,D0
    AND.L    (A3),D1
    AND.L    (A5)+,D2
    AND.L    -(A6),D3
    AND.L    $7004,D4
    AND.L    $00010000,D5
    AND.L    #$A501A,D6

    AND.L    D7,$00010000
    AND.L    D6,$7000
    AND.L    D5,-(A6)
    AND.L    D4,(A5)+
    AND.L    D4,(A3)
    
    RTS
    
TEST_ADD:
    LEA     $7000,A1
    LEA     $7002,A0
    LEA     $7000,A5
	LEA		$7000,A4
    
    * test long
    
    ADD.L    D7,D0
	ADD.L    A5,D7
    ADD.L    (A4),D1
    ADD.L    (A1)+,D2
    ADD.L    -(A0),D3
    ADD.L    $7004,D4
    ADD.L    $00010000,D5
    ADD.L    #$10FF01,D6

    ADD.L    D7,$00010000
    ADD.L    D6,$7000
    ADD.L    D5,-(A0)
    ADD.L    D4,(A1)+
    ADD.L    D4,(A4)
    
    * test word
    
    ADD.W    D7,D0
	ADD.W    A5,D7
    ADD.W    (A4),D1
    ADD.W    (A1)+,D2
    ADD.W    -(A0),D3
    ADD.W    $7004,D4
    ADD.W    $00010000,D5
    ADD.W    #$10AA,D6

    ADD.W    D7,$00010000
    ADD.W    D6,$7000
    ADD.W    D5,-(A0)
    ADD.W    D4,(A1)+
    ADD.W    D4,(A4)
    
    * test byte
    
    ADD.B    D7,D0
    ADD.B    (A4),D1
    ADD.B    (A1)+,D2
    ADD.B    -(A0),D3
    ADD.B    $7004,D4
    ADD.B    $00010000,D5
    ADD.B    #$27,D6

    ADD.B    D7,$00010000
    ADD.B    D6,$7000
    ADD.B    D5,-(A0)
    ADD.B    D4,(A1)+
    ADD.B    D4,(A4)

    RTS

TEST_ADDA:
    * init data to even addresses
    LEA     $7000,A0
    LEA     $7004,A1
    LEA     $7050,A2
    LEA     $7050,A3
    LEA     $7050,A4
    LEA     $7050,A5
    LEA     $7050,A6
    
    * init even value at address
    MOVE.L  #$222,$7050
    
    * test long
    ADDA.L    D5,A0
	ADDA.L    A0,A3
    ADDA.L    (A3),A1
    ADDA.L    (A2)+,A4
    ADDA.L    -(A6),A5
    ADDA.L    $7050,A6
    ADDA.L    $00010000,A5
    ADDA.L    #$AAA,A2
    
    * reset to even addresses
    LEA     $7000,A0
    LEA     $7004,A1
    LEA     $7050,A2
    LEA     $7050,A3
    LEA     $7050,A4
    LEA     $7050,A5
    LEA     $7050,A6
    
    * test word
    ADDA.W    D5,A0
	ADDA.W    A0,A3
    ADDA.W    (A3),A1
    ADDA.W    (A2)+,A4
    ADDA.W    -(A6),A5
    ADDA.W    $7050,A6
    ADDA.W    $00010000,A5
    ADDA.W    #$AAA,A2
    
    RTS

TEST_LSR_LSL_REG:
    * test lsl byte imediate
    LSR.B   #1,D0
    LSR.B   #2,D1
    LSR.B   #3,D2
    LSR.B   #4,D3
    LSR.B   #5,D4
    LSR.B   #6,D5
    LSR.B   #7,D6
    LSR.B   #8,D7
    
    LSL.B   #1,D0
    LSL.B   #2,D1
    LSL.B   #3,D2
    LSL.B   #4,D3
    LSL.B   #5,D4
    LSL.B   #6,D5
    LSL.B   #7,D6
    LSL.B   #8,D7
    
    * test lsl lsr byte register
    
    LSR.B   D0,D7
    LSR.B   D1,D0
    LSR.B   D2,D1
    LSR.B   D3,D2
    LSR.B   D4,D3
    LSR.B   D5,D4
    LSR.B   D6,D5
    LSR.B   D7,D6
    
    LSL.B   D0,D7
    LSL.B   D1,D0
    LSL.B   D2,D1
    LSL.B   D3,D2
    LSL.B   D4,D3
    LSL.B   D5,D4
    LSL.B   D6,D5
    LSL.B   D7,D6
    
    * test word and long no need to test all different registers for each size
    LSR.W   D0,D1
    LSL.W   D2,D3

    LSR.L   D0,D1
    LSL.L   D2,D3
    
    RTS

TEST_LSL_LSR_MEM:
    LEA   $7000,A1
    LEA   $7000,A6
    LEA   $7000,A3
    
    LSR   (A1)
    LSR   (A6)+
    LSR   -(A3)
    LSR   $7000
    LSR   $00010000
    
    LEA   $7000,A0
    LEA   $7000,A5
    LEA   $7000,A2
        
    LSL   (A0)
    LSL   (A5)+
    LSL   -(A2)
    LSL   $7000
    LSL   $00010000
       
    RTS
    
TEST_ASR_ASL_REG:
    * test ASL byte imediate
    ASR.B   #1,D0
    ASR.B   #2,D1
    ASR.B   #3,D2
    ASR.B   #4,D3
    ASR.B   #5,D4
    ASR.B   #6,D5
    ASR.B   #7,D6
    ASR.B   #8,D7
    
    ASL.B   #1,D0
    ASL.B   #2,D1
    ASL.B   #3,D2
    ASL.B   #4,D3
    ASL.B   #5,D4
    ASL.B   #6,D5
    ASL.B   #7,D6
    ASL.B   #8,D7
    
    * test ASL ASR byte register
    
    ASR.B   D0,D7
    ASR.B   D1,D0
    ASR.B   D2,D1
    ASR.B   D3,D2
    ASR.B   D4,D3
    ASR.B   D5,D4
    ASR.B   D6,D5
    ASR.B   D7,D6
    
    ASL.B   D0,D7
    ASL.B   D1,D0
    ASL.B   D2,D1
    ASL.B   D3,D2
    ASL.B   D4,D3
    ASL.B   D5,D4
    ASL.B   D6,D5
    ASL.B   D7,D6
    
    * test word and long no need to test all different registers for each size
    ASR.W   D0,D1
    ASL.W   D2,D3

    ASR.L   D0,D1
    ASL.L   D2,D3
    
    RTS

TEST_ASL_ASR_MEM:
    LEA   $7000,A1
    LEA   $7000,A6
    LEA   $7000,A3
    
    ASR   (A1)
    ASR   (A6)+
    ASR   -(A3)
    ASR   $7000
    ASR   $00010000
    
    LEA   $7000,A0
    LEA   $7000,A5
    LEA   $7000,A2
        
    ASL   (A0)
    ASL   (A5)+
    ASL   -(A2)
    ASL   $7000
    ASL   $00010000
       
    RTS

    
    
    ORG $9000
    * label to branch to for 16 bit displacement  
_16BIT:
     BRA RETURN_16
     
    
	END	START
	
	



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
