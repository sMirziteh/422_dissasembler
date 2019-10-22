*-----------------------------------------------------------
* Title      :  Dissasembler
* Written by :  Nick, Shelby, and Zoe
* Date       :
* Description:
*-----------------------------------------------------------
        ORG     $1000
		
****    MAIN LOOP   ****
START:  
        LEA ST_A_MSG,A1 * load start address prompt message
        JSR PRINT_A1    * print message
        
        LEA     ST_ADDR,A1 * load start address
        CLR.L   (A1)    * clear long at a1
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        
        JSR     IN_ADDR_TO_HEX  * convert start address to hex
             
        LEA     E_A_MSG,A1 * load end address prompt message
        JSR PRINT_A1       * print message
        
        LEA     E_ADDR,A1  * load end address
        CLR.L   (A1)    * clear long at end address
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        
        JSR     IN_ADDR_TO_HEX  * convert end address to hex
        
        * print converted addresses for testing purposes
        LEA     NEW_LINE,A1
        JSR     PRINT_A1
        
        LEA     TEST_MSG,A1
        JSR     PRINT_A1    
        MOVE.L  ST_ADDR,D1
        JSR     PRINT_D1_HEX
        
        LEA     NEW_LINE,A1
        JSR     PRINT_A1
        
        LEA     TEST_MSG,A1
        JSR     PRINT_A1    
        MOVE.L  E_ADDR,D1
        JSR     PRINT_D1_HEX
        
        LEA     NEW_LINE,A1
        JSR     PRINT_A1
        LEA     NEW_LINE,A1
        JSR     PRINT_A1
        * end test printing converted numbers

    
        BRA     START 


****    OP-CODES    ****



****       EA       ****


***       UTILS     ****

DONE    MOVE.B  #9,D0       * Trap task 9 halt simulator
        TRAP    #15
        
* Converts ASCII string containing chars 0-9 and A-F uppercase to hexidecimal number
* d1 is string length, will be changed
TO_HEX
        CLR.L   D2      * clear to hold digit magnitude
        CLR.L   D3      * clear to hold result
        SUBI    #1,D1    * subtract 1
        MULU    #4,D1   * multiply length by four to get length in binary
        MOVEA.L A1,A2   * save starting address
TO_HEX_INTERNAL:
        MOVE.B  (A1)+,D0     * Load char at A1 into D0
        BEQ     END_H       * GOTO end if byte is zero (null terminated)
        CMPI    #$39,D0     * compare char value to 39
        BLE     _0_9        * GOTO 0_9 if <= 39
A_F     SUBI.B  #$7,D0      * Subtract 7 from D0) for ASCII A-F
_0_9    SUBI.B  #$30,D0     * Subtract $30 to convert to hexidecimal
        MOVE.L  D0,D2        * put hex digit in D2
        LSL.L   D1,D2       * shift hex digit final postion    
        ADD.L   D2,D3       * add to hex result
        SUBI.L    #4,D1       * subract one hex digit of bits from remaining length 
        BRA     TO_HEX_INTERNAL   * convert next byte
END_H   MOVE.L  D3,(A2)     * save result back at starting address
        RTS


*   input address to hexadecimal
IN_ADDR_TO_HEX:
        CMP     #8,D1   * compare string input length to 8
        BGT     PADDR_IN_ERR    * if input greater than 8 bytes print input address error
        JSR     TO_HEX          * else convert to hex
        RTS
        
        
*   print address input error
PADDR_IN_ERR: 
        LEA     ADR_IN_ERR,A1   * load address unput error message 
        JMP     PRINT_A1
        BRA     START           * return to start of program

PRINT_A1:
        MOVE.B  #14,D0
        TRAP    #15
        RTS

*  print hex number contained in D1
PRINT_D1_HEX:
        MOVE.L  #16,D2  * put 16 in D2 for base 16
        MOVE.L  #15,D0  * trap task 15 for printing number of base
        TRAP    #15
        RTS
      
****    VARS    ****
ST_ADDR DS.L    3   * allocate 3 longs for address ascii input needs 9 bytes to get 8 chars 
E_ADDR  DS.L    3   * and null terminator, allocating 12 bytes to account for this
        
****    CONST   ****
CR          EQU     $0D     * carraige return          
LF          EQU     $0A     * line feed 

****    MESSAGES    ****
ST_A_MSG    DC.B    'Valid address chars: 0123456789ABCDEF (uppercase only)',CR,LF  * start address message
            DC.B    'Enter start address:',0    
E_A_MSG     DC.B    'Enter end address:',0    * end address message

ADR_IN_ERR  DC.B    'ERROR INVALID ADDRESS: input must be 0-8 hexidecimal digits long',CR,LF,0    * address input error message

TEST_MSG    DC.B    'CONVERTED ADDRESS IS: '  * test message for printing start and end addresses
NEW_LINE    DC.B    CR,LF,0
            
		    END     START        * last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
