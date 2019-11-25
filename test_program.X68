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
	LEA $4000,A1	* init Address registers
	LEA $4000,A2
	MOVE.L #$44444444,D0	* init data registers
	MOVE.L #$22222222,D1


* Testing all EAs for MOVE.B
	MOVE.B	D0,D1	* Data register direct to Data register direct
	MOVE.B	D0,(A2)	* Data register direct to Address register indirect
	MOVE.B	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.B	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.B	D0,$6000.L	* Data register direct to Absolute Long Address
	MOVE.B	D0,$6000.W	* Data register direct to Absolute Word Address
	MOVE.B	(A1),D1	* Address register indirect to Data register direct
	MOVE.B	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.B	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.B	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.B	(A1),$6000.L	* Address register indirect to Absolute Long Address
	MOVE.B	(A1),$6000.W	* Address register indirect to Absolute Word Address
	MOVE.B	#$44,D1	* Immediate addressing to Data register direct
	MOVE.B	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.B	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.B	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.B	#$44,$6000.L	* Immediate addressing to Absolute Long Address
	MOVE.B	#$44,$6000.W	* Immediate addressing to Absolute Word Address
	MOVE.B	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.B	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.B	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.B	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.B	(A1)+,$6000.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.B	(A1)+,$6000.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.B	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.B	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.B	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.B	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.B	-(A1),$6000.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.B	-(A1),$6000.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.B	$6000.L,D1	* Absolute Long Address to Data register direct
	MOVE.B	$6000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.B	$6000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.B	$6000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.B	$6000.L,$6000.L	* Absolute Long Address to Absolute Long Address
	MOVE.B	$6000.L,$6000.W	* Absolute Long Address to Absolute Word Address
	MOVE.B	$6000.W,D1	* Absolute Word Address to Data register direct
	MOVE.B	$6000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.B	$6000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.B	$6000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.B	$6000.W,$6000.L	* Absolute Word Address to Absolute Long Address
	MOVE.B	$6000.W,$6000.W	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.W
	MOVE.W	D0,D1	* Data register direct to Data register direct
	MOVE.W	D0,A2	* Data register direct to Address register direct
	MOVE.W	D0,(A2)	* Data register direct to Address register indirect
	MOVE.W	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.W	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.W	D0,$6000.L	* Data register direct to Absolute Long Address
	MOVE.W	D0,$6000.W	* Data register direct to Absolute Word Address
	MOVE.W	A1,D1	* Address register direct to Data register direct
	MOVE.W	A1,A2	* Address register direct to Address register direct
	MOVE.W	A1,(A2)	* Address register direct to Address register indirect
	MOVE.W	A1,(A2)+	* Address register direct to Address Register Indirect with post incrementing
	MOVE.W	A1,-(A2)	* Address register direct to Address Register Indirect with pre decrementing
	MOVE.W	A1,$6000.L	* Address register direct to Absolute Long Address
	MOVE.W	A1,$6000.W	* Address register direct to Absolute Word Address
	MOVE.W	(A1),D1	* Address register indirect to Data register direct
	MOVE.W	(A1),A2	* Address register indirect to Address register direct
	MOVE.W	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.W	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.W	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.W	(A1),$6000.L	* Address register indirect to Absolute Long Address
	MOVE.W	(A1),$6000.W	* Address register indirect to Absolute Word Address
	MOVE.W	#$44,D1	* Immediate addressing to Data register direct
	MOVE.W	#$44,A2	* Immediate addressing to Address register direct
	MOVE.W	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.W	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.W	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.W	#$44,$6000.L	* Immediate addressing to Absolute Long Address
	MOVE.W	#$44,$6000.W	* Immediate addressing to Absolute Word Address
	MOVE.W	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.W	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.W	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.W	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.W	(A1)+,$6000.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.W	(A1)+,$6000.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.W	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.W	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.W	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.W	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.W	-(A1),$6000.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.W	-(A1),$6000.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.W	$6000.L,D1	* Absolute Long Address to Data register direct
	MOVE.W	$6000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.W	$6000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.W	$6000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.W	$6000.L,$6000.L	* Absolute Long Address to Absolute Long Address
	MOVE.W	$6000.L,$6000.W	* Absolute Long Address to Absolute Word Address
	MOVE.W	$6000.W,D1	* Absolute Word Address to Data register direct
	MOVE.W	$6000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.W	$6000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.W	$6000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.W	$6000.W,$6000.L	* Absolute Word Address to Absolute Long Address
	MOVE.W	$6000.W,$6000.W	* Absolute Word Address to Absolute Word Address



* Testing all EAs for MOVE.L
	MOVE.L	D0,D1	* Data register direct to Data register direct
	MOVE.L	D0,A2	* Data register direct to Address register direct
	MOVE.L	D0,(A2)	* Data register direct to Address register indirect
	MOVE.L	D0,(A2)+	* Data register direct to Address Register Indirect with post incrementing
	MOVE.L	D0,-(A2)	* Data register direct to Address Register Indirect with pre decrementing
	MOVE.L	D0,$6000.L	* Data register direct to Absolute Long Address
	MOVE.L	D0,$6000.W	* Data register direct to Absolute Word Address
	MOVE.L	A1,D1	* Address register direct to Data register direct
	MOVE.L	A1,A2	* Address register direct to Address register direct
	MOVE.L	A1,(A2)	* Address register direct to Address register indirect
	MOVE.L	A1,(A2)+	* Address register direct to Address Register Indirect with post incrementing
	MOVE.L	A1,-(A2)	* Address register direct to Address Register Indirect with pre decrementing
	MOVE.L	A1,$6000.L	* Address register direct to Absolute Long Address
	MOVE.L	A1,$6000.W	* Address register direct to Absolute Word Address
	MOVE.L	(A1),D1	* Address register indirect to Data register direct
	MOVE.L	(A1),A2	* Address register indirect to Address register direct
	MOVE.L	(A1),(A2)	* Address register indirect to Address register indirect
	MOVE.L	(A1),(A2)+	* Address register indirect to Address Register Indirect with post incrementing
	MOVE.L	(A1),-(A2)	* Address register indirect to Address Register Indirect with pre decrementing
	MOVE.L	(A1),$6000.L	* Address register indirect to Absolute Long Address
	MOVE.L	(A1),$6000.W	* Address register indirect to Absolute Word Address
	MOVE.L	#$44,D1	* Immediate addressing to Data register direct
	MOVE.L	#$44,A2	* Immediate addressing to Address register direct
	MOVE.L	#$44,(A2)	* Immediate addressing to Address register indirect
	MOVE.L	#$44,(A2)+	* Immediate addressing to Address Register Indirect with post incrementing
	MOVE.L	#$44,-(A2)	* Immediate addressing to Address Register Indirect with pre decrementing
	MOVE.L	#$44,$6000.L	* Immediate addressing to Absolute Long Address
	MOVE.L	#$44,$6000.W	* Immediate addressing to Absolute Word Address
	MOVE.L	(A1)+,D1	* Address Register Indirect with post incrementing to Data register direct
	MOVE.L	(A1)+,(A2)	* Address Register Indirect with post incrementing to Address register indirect
	MOVE.L	(A1)+,(A2)+	* Address Register Indirect with post incrementing to Address Register Indirect with post incrementing
	MOVE.L	(A1)+,-(A2)	* Address Register Indirect with post incrementing to Address Register Indirect with pre decrementing
	MOVE.L	(A1)+,$6000.L	* Address Register Indirect with post incrementing to Absolute Long Address
	MOVE.L	(A1)+,$6000.W	* Address Register Indirect with post incrementing to Absolute Word Address
	MOVE.L	-(A1),D1	* Address Register Indirect with pre decrementing to Data register direct
	MOVE.L	-(A1),(A2)	* Address Register Indirect with pre decrementing to Address register indirect
	MOVE.L	-(A1),(A2)+	* Address Register Indirect with pre decrementing to Address Register Indirect with post incrementing
	MOVE.L	-(A1),-(A2)	* Address Register Indirect with pre decrementing to Address Register Indirect with pre decrementing
	MOVE.L	-(A1),$6000.L	* Address Register Indirect with pre decrementing to Absolute Long Address
	MOVE.L	-(A1),$6000.W	* Address Register Indirect with pre decrementing to Absolute Word Address
	MOVE.L	$6000.L,D1	* Absolute Long Address to Data register direct
	MOVE.L	$6000.L,(A2)	* Absolute Long Address to Address register indirect
	MOVE.L	$6000.L,(A2)+	* Absolute Long Address to Address Register Indirect with post incrementing
	MOVE.L	$6000.L,-(A2)	* Absolute Long Address to Address Register Indirect with pre decrementing
	MOVE.L	$6000.L,$6000.L	* Absolute Long Address to Absolute Long Address
	MOVE.L	$6000.L,$6000.W	* Absolute Long Address to Absolute Word Address
	MOVE.L	$6000.W,D1	* Absolute Word Address to Data register direct
	MOVE.L	$6000.W,(A2)	* Absolute Word Address to Address register indirect
	MOVE.L	$6000.W,(A2)+	* Absolute Word Address to Address Register Indirect with post incrementing
	MOVE.L	$6000.W,-(A2)	* Absolute Word Address to Address Register Indirect with pre decrementing
	MOVE.L	$6000.W,$6000.L	* Absolute Word Address to Absolute Long Address
	MOVE.L	$6000.W,$6000.W	* Absolute Word Address to Absolute Word Address



	END	START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
