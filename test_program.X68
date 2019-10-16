*-----------------------------------------------------------
* Title      :  TEST PROGRAM
* Written by :  Team nibble (NICK, SHELBY, AND ZOE)
* Date       :
* Description:  TEST program to dissasemble
*-----------------------------------------------------------
****************************************************
* This warning is normal when using 16bit addresses
* this is required to test absolute word addressing
* 
* WARNING: Forcing SHORT addressing disables range
* checking of extension word
****************************************************
	org $8000	* start at this address
START	NOP	* first instruction NOP for testing
	LEA $A000,A1	* init Address registers
	LEA $A0F0,A2
	MOVE.B #5,D0	* init data registers
	MOVE.B #15,D1


* Testing all EAs for MOVE.B
	MOVE.B	D0,D1	* Data register direct to Data register direct
	MOVE.B	D0,(A2)	* Data register direct to Address register indirect
	MOVE.B	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.B	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.B	D0,$A0F0.L	* Data register direct to Absolute Long Address
	MOVE.B	D0,$A0F0.W	* Data register direct to Absolute Word Address
	MOVE.B	(A1),D1	* Address register indirect to Data register direct
	MOVE.B	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.B	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.B	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.B	(A1),$A0F0.L	* Address register indirect to Absolute Long Address
	MOVE.B	(A1),$A0F0.W	* Address register indirect to Absolute Word Address
	MOVE.B	#$AA,D1	* Immediate addressing to Data register direct
	MOVE.B	#$AA,(A2)	* Immediate addressing to Address register indirect
	MOVE.B	#$AA,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.B	#$AA,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.B	#$AA,$A0F0.L	* Immediate addressing to Absolute Long Address
	MOVE.B	#$AA,$A0F0.W	* Immediate addressing to Absolute Word Address
	MOVE.B	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.B	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.B	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.B	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.B	(A1)+,$A0F0.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.B	(A1)+,$A0F0.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.B	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.B	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.B	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.B	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.B	-(A1),$A0F0.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.B	-(A1),$A0F0.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.B	$A000.L,D1	* Absolute Long Address to Data register direct
	MOVE.B	$A000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.B	$A000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.B	$A000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.B	$A000.L,$A0F0.L	* Absolute Long Address to Absolute Long Address
	MOVE.B	$A000.L,$A0F0.W	* Absolute Long Address to Absolute Word Address
	MOVE.B	$A000.W,D1	* Absolute Word Address to Data register direct
	MOVE.B	$A000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.B	$A000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.B	$A000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.B	$A000.W,$A0F0.L	* Absolute Word Address to Absolute Long Address
	MOVE.B	$A000.W,$A0F0.W	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.W
	MOVE.W	D0,D1	* Data register direct to Data register direct
	MOVE.W	D0,(A2)	* Data register direct to Address register indirect
	MOVE.W	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.W	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.W	D0,$A0F0.L	* Data register direct to Absolute Long Address
	MOVE.W	D0,$A0F0.W	* Data register direct to Absolute Word Address
	MOVE.W	(A1),D1	* Address register indirect to Data register direct
	MOVE.W	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.W	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.W	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.W	(A1),$A0F0.L	* Address register indirect to Absolute Long Address
	MOVE.W	(A1),$A0F0.W	* Address register indirect to Absolute Word Address
	MOVE.W	#$AA,D1	* Immediate addressing to Data register direct
	MOVE.W	#$AA,(A2)	* Immediate addressing to Address register indirect
	MOVE.W	#$AA,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.W	#$AA,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.W	#$AA,$A0F0.L	* Immediate addressing to Absolute Long Address
	MOVE.W	#$AA,$A0F0.W	* Immediate addressing to Absolute Word Address
	MOVE.W	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.W	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.W	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.W	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.W	(A1)+,$A0F0.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.W	(A1)+,$A0F0.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.W	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.W	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.W	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.W	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.W	-(A1),$A0F0.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.W	-(A1),$A0F0.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.W	$A000.L,D1	* Absolute Long Address to Data register direct
	MOVE.W	$A000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.W	$A000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.W	$A000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.W	$A000.L,$A0F0.L	* Absolute Long Address to Absolute Long Address
	MOVE.W	$A000.L,$A0F0.W	* Absolute Long Address to Absolute Word Address
	MOVE.W	$A000.W,D1	* Absolute Word Address to Data register direct
	MOVE.W	$A000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.W	$A000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.W	$A000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.W	$A000.W,$A0F0.L	* Absolute Word Address to Absolute Long Address
	MOVE.W	$A000.W,$A0F0.W	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.L
	MOVE.L	D0,D1	* Data register direct to Data register direct
	MOVE.L	D0,(A2)	* Data register direct to Address register indirect
	MOVE.L	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.L	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.L	D0,$A0F0.L	* Data register direct to Absolute Long Address
	MOVE.L	D0,$A0F0.W	* Data register direct to Absolute Word Address
	MOVE.L	(A1),D1	* Address register indirect to Data register direct
	MOVE.L	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.L	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.L	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.L	(A1),$A0F0.L	* Address register indirect to Absolute Long Address
	MOVE.L	(A1),$A0F0.W	* Address register indirect to Absolute Word Address
	MOVE.L	#$AA,D1	* Immediate addressing to Data register direct
	MOVE.L	#$AA,(A2)	* Immediate addressing to Address register indirect
	MOVE.L	#$AA,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.L	#$AA,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.L	#$AA,$A0F0.L	* Immediate addressing to Absolute Long Address
	MOVE.L	#$AA,$A0F0.W	* Immediate addressing to Absolute Word Address
	MOVE.L	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.L	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.L	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.L	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.L	(A1)+,$A0F0.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.L	(A1)+,$A0F0.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.L	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.L	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.L	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.L	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.L	-(A1),$A0F0.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.L	-(A1),$A0F0.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.L	$A000.L,D1	* Absolute Long Address to Data register direct
	MOVE.L	$A000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.L	$A000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.L	$A000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.L	$A000.L,$A0F0.L	* Absolute Long Address to Absolute Long Address
	MOVE.L	$A000.L,$A0F0.W	* Absolute Long Address to Absolute Word Address
	MOVE.L	$A000.W,D1	* Absolute Word Address to Data register direct
	MOVE.L	$A000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.L	$A000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.L	$A000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.L	$A000.W,$A0F0.L	* Absolute Word Address to Absolute Long Address
	MOVE.L	$A000.W,$A0F0.W	* Absolute Word Address to Absolute Word Address



	END	START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
