*-----------------------------------------------------------
* Title      :  Dissasembler
* Written by :  Nick, Shelby, and Zoe
* Date       :
* Description:
*-----------------------------------------------------------
        ORG     $1000
		
****    MAIN LOOP   ****
START:  NOP
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
        
        MOVE.L  ST_ADDR,D1    * test print from string buffer
        LEA     STR_BUF,A4    * lead buffer address into a4
        JSR     HEX_TO_ASCII    * call conversion subroutine
        JSR     WRITE_NULL_A4   * terminate string
        JSR     PRINT_STR_BUF   * print from buffer
        
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
        
        JSR     OP_CODES
    
        BRA     START 


****    OP-CODES    ****
OP_CODES:
        MOVE.L  ST_ADDR,A5  * load starting address into a5
        MOVE.L  E_ADDR,A6   * load ending address into a6
        
OP_START:
        MOVE.L  STR_BUF,A4   * initialize string buffer pointer to start of string buffer
        
        MOVE.L  A5,D1   * load address from A5 into D1
        JSR     PRINT_D1_HEX * print address
        LEA     TAB,A1
        JSR     PRINT_A1
        
        MOVE.W (A5),D2 * load word of memory into D1
        
        
CHK_LFT_NIB:
        MOVE.L  D2,D3   * copy to d2
        
        ANDI.W  #Nib3Mask,D3 * clear all but left four bits                
        CMPI.W  #$4000,D3   * if nibble3 == 4 branch to that
        BEQ     OP_4 
        
print_data:
        LEA     DATA_MSG,A1 * Load template for data, will need to organize this better
        JSR     PRINT_A1
        MOVE.W  D2,D1   * load address contents into d1 for printing
        JSR     PRINT_D1_HEX * print memory word from d1
        
                       
        
CHK_OP_LOOP:    * print newline then check if op-code loop is done
        LEA     NEW_LINE,A1 * print newline
        JSR     PRINT_A1
        ADD.L   #2,A5   * increment current address pointer by 2 bytes 
        CMP.L   A6,A5  * loop if start is less than or equal to end
        BLE     OP_START
OP_DONE RTS


OP_4:   * could be nop, rts, stop, movem
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Nib2Mask,D3
        CMPI.W  #$0E00,D3  * if nibble 2 is E could be nop or rts
        BEQ     NOP_RTS
        
        BRA print_data  * return to print data
        
NOP_RTS: * could be NOP or RTS     
        MOVE.L  D2,D3       *copy instruction word
        ANDI.W  #Byte0Mask,D3 * isolate right most byte
        
        CMPI.B  #$71,D3     * test for NOP
        BEQ     load_NOP
        CMPI.B  #$75, D3    * test for RTS
        BEQ     load_RTS
            
        BRA     print_data  * return to op loop print data instruction not recognized
                
load_NOP:   * load ad print NOP neumonic return to op loop
        LEA     _NOP,A1
        JSR     PRINT_A1
        BRA     CHK_OP_LOOP
        
load_RTS:   * load and print RTS neumonic return to op loop
        LEA     _RTS,A1
        JSR     PRINT_A1
        BRA     CHK_OP_LOOP
       

****       EA       ****



***       UTILS     ****

DONE    MOVE.B  #9,D0       * Trap task 9 halt simulator
        TRAP    #15
        
* Converts ASCII string containing chars 0-9 and A-F uppercase to hexidecimal number
* returns result in D6
TO_HEX
        MOVEM   D0-D2/A1-A2,-(SP)   * save state of registers to be changed
        CLR.L   D2      * clear to hold digit magnitude
        CLR.L   D6      * clear to hold result
        SUBI    #1,D1    * subtract 1
        MULU    #4,D1   * multiply length by four to get length in binary
        
TO_HEX_INTERNAL:
        MOVE.B  (A1)+,D0     * Load char at A1 into D0
        BEQ     END_H       * GOTO end if byte is zero (null terminated)
        CMPI    #$39,D0     * compare char value to 39
        BLE     _0_9        * GOTO 0_9 if <= 39
A_F     SUBI.B  #$7,D0      * Subtract 7 from D0) for ASCII A-F
_0_9    ANDI.B  #$0F,D0     * AND with 00001111 to isolate left most 4 bits, converts to hex
        MOVE.L  D0,D2        * put hex digit in D2
        LSL.L   D1,D2       * shift hex digit final postion    
        ADD.L   D2,D6       * add to hex result
        SUBI.L    #4,D1       * subract one hex digit of bits from remaining length 
        BRA     TO_HEX_INTERNAL   * convert next byte
END_H   MOVEM (SP)+,D0-D2/A1-A2
        RTS

HEX_TO_ASCII: * write hex in d1 to a4 as ascii
        * may need to add case to handle sign extended shorts
        MOVEM   D2-D4,-(SP)
        MOVE.L  D1,D2   * copy input to working temp var
        ANDI.L  #$FFFF0000,D2   * mask for bits 31-16
        CMPI.L  #0,D2           * if masked value is 0 there is no value in long portion of register for unsigned ints
        BEQ     h_short         * if no value must be non sign extended short  
        * setup params for ling processing
        MOVE.L  #$F0000000,D3   * init mask for isolating first long hex most significand digit
        MOVE.L  #28,D4          * init shift value for first long hex MSD
        BRA     h_a_loop
        
h_short: * setup params for short processing
        MOVE.L  #$F000,D3   * init mask for isolating first short hex most significand digit
        MOVE.L  #12,D4      * init shift value for first short hex MSD
        
h_a_loop:
        CMPI.L  #0,D4   * compare shift value to 0
        BLT     h_a_dne * done if less than 0
        MOVE.L  D1,D2   * copy input to working temp var
        AND.L   D3,D2   * isolate digit
        LSR.L   D4,D2   * shift to rightmost position
        
        CMPI.L  #$A,D2   * compare to A
        BLT     h_a_low  * if less than A 0-9
        ADDI    #7,D2    * add an additional 7 to A-F     
h_a_low:
        ADDI    #$30,D2  * add $30 to convert to ascii
        MOVE.B  D2,(A4)+ * write digit to pointer location
        
        LSR.L   #4,D3   * shift mask to isolate next hex digit
        SUBI.L  #4,D4   * subtract shift for next digit
        BRA     h_a_loop    * return to loop start
h_a_dne MOVEM   (SP)+,D2-D4
        RTS
        


*   input address to hexadecimal saves output at A1
IN_ADDR_TO_HEX:
        MOVEM   D6,-(SP)
        CMPI    #8,D1   * compare string input length to 8
        BGT     PADDR_IN_ERR    * if input greater than 8 bytes print input address error
        JSR     TO_HEX          * else convert to hex
        MOVE.L  D6,(A1)
        MOVEM   (SP)+,D6
        RTS
        
        
*   print address input error
PADDR_IN_ERR: 
        LEA     ADR_IN_ERR,A1   * load address input error message 
        JMP     PRINT_A1
        BRA     START           * return to start of program

PRINT_A1:
        MOVEM   D0,-(SP) * save register state
        MOVE.B  #14,D0   * print A1
        TRAP    #15
        MOVEM   (SP)+,D0  *  restore register state
        RTS

WRITE_NULL_A4: * used to terminate a string in memory 
        MOVE.B  #0,(A4)+
        RTS

PRINT_STR_BUF: * prints string buffer contents to console
        MOVEM   D0/A1,-(SP)
        LEA     STR_BUF,A1  * load string buffer
        MOVE    #14,D0       * print contents
        TRAP    #15
        MOVEM   (SP)+,D0/A1
        RTS        

*  print hex number contained in D1
PRINT_D1_HEX:
        MOVEM   D0/D2,-(SP)
        MOVE.L  #16,D2  * put 16 in D2 for base 16
        MOVE.L  #15,D0  * trap task 15 for printing number of base
        TRAP    #15
        MOVEM   (SP)+,D0/D2
        RTS
      
****    VARS    ****
ST_ADDR DS.L    3   * allocate 3 longs for address ascii input needs 9 bytes to get 8 chars 
E_ADDR  DS.L    3   * and null terminator, allocating 12 bytes to account for this
STR_BUF DCB.B   81,0  * buffer to hold 80 chars + null terminator init to 0
        
****    CONST   ****
CR          EQU     $0D     * carraige return          
LF          EQU     $0A     * line feed
* masks for isolating nibbles with and 0 being least significant nibble
Nib3Mask    EQU     $F000 
Nib2Mask    EQU     $0F00
Nib1Mask    EQU     $00F0
Nib0Mask    EQU     $000F

Byte0Mask   EQU     $00FF
Byte1Mask   EQU     $FF00

****    Instructions    ****
_NOP    DC.B    'NOP',0
_RTS    DC.B    'RTS',0
_MOVEM  DC.B    'MOVEM',0

****    MESSAGES    ****
ST_A_MSG    DC.B    'Enter an address range in hexidecimal to be dissasembled',CR,LF * start address message
            DC.B    'Valid address chars: 0-1 A-F case insensitive',CR,LF  
            DC.B    'Enter start address:',0    
            
E_A_MSG     DC.B    'Enter end address:',0    * end address message

ADR_IN_ERR  DC.B    'ERROR INVALID ADDRESS: input must be 0-8 hexidecimal digits long',CR,LF,0    * address input error message

DATA_MSG    DC.B    'DATA   $',0
TAB         DC.B    '   ',0

TEST_MSG    DC.B    'CONVERTED ADDRESS IS: ',0  * test message for printing start and end addresses
NEW_LINE    DC.B    CR,LF,0
            
		    END     START        * last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
