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
        MOVE.B  #14,D0  * print start address prompt message
        TRAP    #15
        
        LEA     ST_ADDR,A1 * load start address
        CLR.L   (A1)    * clear long at a1
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        
        JSR     IN_ADDR_TO_HEX  * convert address to hex
             
*        LEA     E_A_MSG,A1 * load end address prompt message
*        MOVE.B  #14,D0  * print end address prompt message
*        TRAP    #15
*        
*        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
*        TRAP    #15
        
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
        MOVEQ  #1,D2        * put 1 in D2
        LSL.L   D1,D2       * shift 1 to hex digit final postion
        MULU    D0,D2       
        ADD.L   D2,D3       * add to hex result
        SUBI    #4,D1       * subract one hex digit of bits from remaining length 
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
        MOVE.B  #14,D0          * dispay message
        TRAP    #15
        BRA     START           * return to start of program
        
****    VARS    ****
ST_ADDR DS.L    3   * allocate 3 longs for address ascii input needs 9 bytes to get 8 chars 
E_ADDR  DS.L    3   * and null terminator, allocating 12 bytes to account for this
        
****    CONST   ****
CR          EQU     $0D     * carraige return          
LF          EQU     $0A     * line feed 

****    MESSAGES    ****
ST_A_MSG    DC.B    'Valid address chars: 0123456789ABCDEF (uppercase only)',CR,LF  * start address message
            DC.B    'Enter start address:',0    
E_A_MSG     DC.B    'Enter end address',0    * end address message

ADR_IN_ERR  DC.B    'ERROR INVALID ADDRESS: input must be 0-8 hexidecimal digits long',CR,LF,0    * address input error message

            
		    END     START        * last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
