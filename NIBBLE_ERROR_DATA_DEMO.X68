*-----------------------------------------------------------
* Title      : DATA and EA ERROR demo
* Written by : TEAM NIBBLE (Nick, Shelby, Zoe)
* Date       :
* Description: when testing dissassemble address range $6000-$603A
*-----------------------------------------------------------
		ORG    $600C
TEST_AD EQU    $7000
		
START:  NOP
        MOVEM.L A0-A2/D0-D2,-(SP)
        MOVE.W  #$400,D0
        LEA     TEST_AD,A1
        AND.W   D0,(A1)
        JSR     TEST_SUB
        MOVEA.L #TEST_AD,A2
        MOVE.W  D1,(A2,D0)   * unsupported EA
        BRA     START            
		
		MOVE.B	#9,D0
		TRAP	#15	* stop sim

	
TEST_SUB:   
        MOVE.B  D2,(A1)+
        OR.W    #4,D3
        RTS    
    	
        ORG     $6000	
TEST_DATA:
        DC.L    $00000000
        DC.L    $00000000
        DC.L    $0000000
        
        
		END    START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
