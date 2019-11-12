*-----------------------------------------------------------
* Title      :  Dissasembler
* Written by :  Nick, Shelby, and Zoe
* Date       :
* Description:
*-----------------------------------------------------------
        ORG     $1000
		
****    MAIN LOOP   ****
START:  NOP
        JSR     RESET_BUF_PTR   * move a4 to start of string buffer

        LEA     ST_A_MSG,A1     * load start address prompt message
        JSR     WRITE_ASCII     * write to string buffer
        JSR     TERM_PNT_RST_BUF * terminate string buffer and print reseting pointer at A4
        
        LEA     ST_ADDR,A1 * load start address
        CLR.L   (A1)    * clear long at a1
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        
        JSR     IN_ADDR_TO_HEX  * convert start address to hex
             
        LEA     E_A_MSG,A1      * load end address prompt message
        JSR     WRITE_ASCII     * print message
        JSR     TERM_PNT_RST_BUF  * print and reset buffer no newline
        
        LEA     E_ADDR,A1  * load end address
        CLR.L   (A1)    * clear long at end address
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        
        JSR     IN_ADDR_TO_HEX  * convert end address to hex
        
        * print converted addresses for testing purposes
        
        JSR     RESET_BUF_PTR         * move a4 to start of string buffer
        
        JSR     WRITE_NL_A4           * write newline to buffer
        
        LEA     TEST_MSG,A1
        JSR     WRITE_ASCII
        
        MOVE.L  ST_ADDR,D1    * test print from string buffer
        JSR     WRITE_HEX_TO_ASCII    * call conversion subroutine

        JSR     WRITE_NL_A4           * write newline to buffer
        
        LEA     TEST_MSG,A1
        JSR     WRITE_ASCII           * copy test_msg to buffer  
        
        MOVE.L  E_ADDR,D1             * write end address to buffer
        JSR     WRITE_HEX_TO_ASCII
        

        JSR     WRITE_NL_A4           * write newline to buffer
        JSR     NL_TERM_PNT_RST_BUF   * print buffer contents
        
        * end test printing converted numbers
        
        JSR     OP_CODES
    
        BRA     START 


****    OP-CODES    ****
OP_CODES:
        JSR     RESET_BUF_PTR   * reset string buffer pointer
        MOVE.L  ST_ADDR,A5  * load starting address into a5
        MOVE.L  E_ADDR,A6   * load ending address into a6
        
OP_START:
        * write address and a tab to str buffer
        MOVE.L  A5,D1   * load address from A5 into D1
        JSR     WRITE_HEX_TO_ASCII
        JSR     WRITE_TAB_A4
        
        MOVE.W (A5),D2 * load word of memory into D1
        
        
CHK_LFT_NIB:
        MOVE.L  D2,D3   * copy to d3
        
        ANDI.W  #Nib3Mask,D3 * clear all but left four bits
        CMPI.W  #$1000,D3   * if nibble3 == 1, branch to move byte (1)
        BEQ     load_MOVE_B
        CMPI.W  #$2000,D3   * if nibble3 == 2, branch to move long (2)
        BEQ     load_MOVE_L * will need to account for MOVEA
        CMPI.W  #$3000,D3   * if nibble3 == 3, branch to move word (3)
        BEQ     load_MOVE_W * will need to account for MOVEA        
        CMPI.W  #$4000,D3   * if nibble3 == 4 branch to that set
        BEQ     OP_4 
        CMPI.W  #$5000,D3   * if nibble3 == 5, branch to ADDQ (5)
        BEQ     load_ADDQ
        CMPI.W  #$6000,D3   * if nibble3 == 6, branch to that set
        BEQ     OP_6
                       
OP_ERR  JSR     LOAD_DATA_STR_INTO_BUF
        

DECODE_DONE:    * print newline then check if op-code loop is done
        JSR     NL_TERM_PNT_RST_BUF * write newline then print
        ADD.L   #2,A5   * increment current address pointer by 2 bytes 
        CMP.L   A6,A5  * loop if start is less than or equal to end
        BLE     OP_START
OP_DONE RTS

load_MOVE_B:    * load and print MOVE.B neumonic return to op loop
        LEA     _MOVE_B,A1
        JSR     WRITE_ASCII
        CLR     D3
        JSR     MOVE_EA
        BRA     DECODE_DONE

load_MOVE_L:    * load and print MOVE.L neumonic return to op loop
        LEA     _MOVE_L,A1
        JSR     WRITE_ASCII
        JSR     MOVE_EA
        BRA     DECODE_DONE
        
load_MOVE_W:    * load and print MOVE.W neumonic return to op loop
        LEA     _MOVE_W,A1
        JSR     WRITE_ASCII
        JSR     MOVE_EA
        BRA     DECODE_DONE

OP_4:   * could be not, nop, rts, jsr, movem, lea
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Nib2Mask,D3
        CMPI.W  #$0600,D3   * if nibble 2 is 6, instruction is NOT
        BEQ     load_NOT
        CMPI.W  #$0E00,D3  * if nibble 2 is E could be nop or rts
        BEQ     NOP_RTS
        * will need more subroutines for jsr, movem, lea
        
        BRA     OP_ERR  * return to error decoding
        
load_NOT:   * load and print NOT neumonic return to op loop
        LEA     _NOT,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE

NOP_RTS: * could be NOP or RTS     
        MOVE.L  D2,D3       *copy instruction word
        ANDI.W  #Byte0Mask,D3 * isolate right most byte
        
        CMPI.B  #$71,D3     * test for NOP
        BEQ     load_NOP
        CMPI.B  #$75, D3    * test for RTS
        BEQ     load_RTS
            
        BRA     OP_ERR  * return to error decoding

load_NOP:   * load and print NOP neumonic return to op loop
        LEA     _NOP,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE
        
load_RTS:   * load and print RTS neumonic return to op loop
        LEA     _RTS,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE

load_ADDQ:  * load and print ADDQ neumonic return to op loop
        LEA     _ADDQ,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE
        
OP_6:   * could be BRA, BEQ, BGT, BLE
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Nib2Mask,D3
        CMPI.W  #$0000,D3   * if nibble 2 is 0, instruction is BRA
        BEQ     load_BRA
        CMPI.W  #$0700,D3   * if nibble 2 is 7, instruction is BEQ
        BEQ     load_BEQ
        CMPI.W  #$0E00,D3   * if nibble 2 is E, instruction is BGT
        BEQ     load_BGT
        CMPI.W  #$0F00,D3   * if nibble 2 is F, instruction is BLE
        BEQ     load_BLE
        
load_BRA:   * load and print BRA neumonic return to op loop
        LEA     _BRA,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE
        
load_BEQ:   * load and print BEQ neumonic return to op loop
        LEA     _BEQ,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE

load_BGT:   * load and print BGT neumonic return to op loop
        LEA     _BGT,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE
        
load_BLE:   * load and print BLE neumonic return to op loop
        LEA     _BLE,A1
        JSR     WRITE_ASCII
        BRA     DECODE_DONE


****       EA       ****
MOVE_EA:
        MOVE.W  D2,D3           *copy instruction to D3 for register
        LSR.W   #6,D3
        ANDI.W  #$0007,D3
        MULU    #$6,D3 
        LEA     EATABLE,A0 
        JSR     00(A0,D3)

*         ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
*         JSR     DEA_MODE        *JMP to check for opmode
*         CLR     D3
*         MOVE.L  D2,D3
*         ANDI.W  #Bit1Mask,D3    *mask to isolate 3-bit opmode
*         JSR     DEA_REG          *JMP to check for reg #
*         CLR     D3
* MV_SRC:

EATABLE:
        JMP     DN_MODE
        JMP     BAD_DATA


BAD_DATA:
        BRA     DECODE_DONE
DN_MODE:
        BRA     DECODE_DONE
        
*         RTS

* DEA_MODE:
*         CMP.W   #cDR,D3         *000?
*         BEQ     DR_MODE         *branch to load Dn to buffer
*         CMP.W   #cAR,D3         *001?
*         BEQ     AR_MODE         *branch to load An to buffer
*         CMP.W   #cIND_AR,D3     *010?
*         BEQ     INDAR_MODE      *branch to load (An) to buffer
*         CMP.W   #cAR_POST,D3    *011?
*         BEQ     INDAR_POST_MODE *branch to load (An)+ to buffer 
*         CMP.W   #cAR_PRE,D3     *100?
*         BEQ     INDAR_PREC_MODE *branch to load -(An) to buffer
*         CMP.W   #cABS,D3        *111?
*         BEQ     ABS_MODE        *branch to load xxx.w/l to buffer
*         JSR     LOAD_MODE_ERR   *JMP to load error
*         RTS


* DEA_REG:
*         CMP.W   #$0E00,D3       *111
*         BEQ     SEV             *branch to load 7 to buffer
*         CMP.W   #$0C00,D3       *110
*         BEQ     SIX             *branch to load 6 to buffer
*         CMP.W   #$0A00,D3       *101
*         BEQ     FIVE            *branch to load 5 to buffer
*         CMP.W   #$0800,D3       *100
*         BEQ     FOUR            *branch to load 4 to buffer
*         CMP.W   #$0600,D3       *011
*         BEQ     THR             *branch to load 3 to buffer
*         CMP.W   #$0400,D3       *010
*         BEQ     TWO             *branch to load 2 to buffer
*         CMP.W   #$0200,D3       *001
*         BEQ     ONE             *branch to load 1 to buffer
*         CMP.W   #$0000,D3       *000
*         BEQ     ZER             *branch to load 0 to buffer
*         JSR     LOAD_REG_ERR    *branch to load error
*         RTS


***       UTILS     ****

LOAD_DATA_STR_INTO_BUF: * expects address to be in a5
        MOVEM   D1,-(SP)
        JSR     RESET_BUF_PTR
        MOVE.L  A5,D1
        JSR     WRITE_HEX_TO_ASCII * write memory address to buffer
        JSR     WRITE_TAB_A4    * wrtie a tab
        LEA     DATA_MSG,A1     * Load template for data
        JSR     WRITE_ASCII     * write 'DATA    $' to buffer
        MOVE.W  (A5),D1   * load address contents of memory to d1 for printing
        JSR     WRITE_HEX_TO_ASCII * save to buffer
        MOVEM   (SP)+,D1
        RTS

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

****************************************************
* Subroutines for printing and writing to and from
* the string buffer at A4
****************************************************        
        
WRITE_HEX_TO_ASCII: * write hex in d1 to a4 as ascii
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

WRITE_ASCII:    * copies null terminated string from A1 to A4 without null
        MOVEM   D1/A1,-(SP)
w_a_loop:
        MOVE.B  (A1)+,D1    * load value at A1
        BEQ     w_a_done    * if 0(null) is moved copy is done
        MOVE.B  D1,(A4)+    * else copy value to A4
        BRA     w_a_loop
w_a_done:
        MOVEM   (SP)+,D1/A1
        RTS

WRITE_NULL_A4: * used to terminate a string in memory 
        MOVE.B  #0,(A4)+
        RTS
        
WRITE_SPC_A4: * writes an ascii space at a4
        MOVE.B  #SPACE,(A4)+
        RTS 

WRITE_NL_A4: * writes a newline at a4
        MOVE.B  #CR,(A4)+
        MOVE.B  #LF,(A4)+
        RTS
        
WRITE_TAB_A4:
        MOVE.B  #TAB,(A4)+
        RTS   

NL_TERM_PNT_RST_BUF: * write newline, null then print contents then reset bufffer
        JSR     WRITE_NL_A4
        JSR     WRITE_NULL_A4
        JSR     PRINT_STR_BUF
        JSR     RESET_BUF_PTR
        RTS
        
TERM_PNT_RST_BUF: * write null then print contents then reset bufffer pointer
        JSR     WRITE_NULL_A4
        JSR     PRINT_STR_BUF
        JSR     RESET_BUF_PTR
        RTS
        
PRINT_STR_BUF: * prints string buffer contents to console
        MOVEM   D0/A1,-(SP)
        LEA     STR_BUF,A1  * load string buffer
        MOVE    #14,D0       * print contents
        TRAP    #15
        MOVEM   (SP)+,D0/A1
        RTS

RESET_BUF_PTR:  * sets a4 to start of string buffer
        MOVEA   #STR_BUF,A4
        RTS        

****    VARS    ****
ST_ADDR DS.L    3   * allocate 3 longs for address ascii input needs 9 bytes to get 8 chars 
E_ADDR  DS.L    3   * and null terminator, allocating 12 bytes to account for this
STR_BUF DCB.B   241,0  * buffer to hold 240 chars + null terminator. 3 80 char lines
         
****    CONST   ****
CR          EQU     $0D     * carraige return          
LF          EQU     $0A     * line feed
SPACE       EQU     $20     * ascii space
TAB         EQU     $09     * ascii tab character

* masks for isolating nibbles with and 0 being least significant nibble
Nib3Mask    EQU     $F000 
Nib2Mask    EQU     $0F00
Nib1Mask    EQU     $00F0
Nib0Mask    EQU     $000F

Bit0Mask    EQU     $0E00
Bit1Mask    EQU     $01C0
Bit2Mask    EQU     $0038
Bit3Mask    EQU     $0007

Byte0Mask   EQU     $00FF
Byte1Mask   EQU     $FF00

****    Instructions    ****
_NOT    DC.B    'NOT',0
_NOP    DC.B    'NOP',0
_RTS    DC.B    'RTS',0
_MOVEM  DC.B    'MOVEM',0
_MOVE_B DC.B    'MOVE.B',0
_MOVE_L DC.B    'MOVE.L',0
_MOVE_W DC.B    'MOVE.W',0
_ADDQ   DC.B    'ADDQ',0
_BRA    DC.B    'BRA',0
_BEQ    DC.B    'BEQ',0
_BGT    DC.B    'BGT',0
_BLE    DC.B    'BLE',0

****    Modes    ****
_DR             DC.B   'D',0
_AR             DC.B   'A',0
_IND_AR1        DC.B   '(A',0
_IND_AR2        DC.B   ')',0
_AR_POST1       DC.B   '(A',0
_AR_POST2       DC.B   ')+',0
_AR_PRE1        DC.B   '-(A',0
_AR_PRE2        DC.B   ')',0
_ABS            DC.B    '$',0
_IMD            DC.B    '#',0

****    Numbers    ****
_ZERO   DC.B    '0',0
_ONE    DC.B    '1',0
_TWO    DC.B    '2',0
_THREE  DC.B    '3',0
_FOUR   DC.B    '4',0
_FIVE   DC.B    '5',0
_SIX    DC.B    '6',0
_SEVEN  DC.B    '7',0

****    MODE CMP VALUES    ****
cDR             EQU     $0000
cAR             EQU     $0040
cIND_AR         EQU     $0080
cAR_POST        EQU     $00C0
cAR_PRE         EQU     $0100
cABS            EQU     $01C0

****    MESSAGES    ****
ST_A_MSG    DC.B    'Enter an address range in hexidecimal to be dissasembled',CR,LF * start address message
            DC.B    'Valid address chars: 0-1 A-F case insensitive',CR,LF  
            DC.B    'Enter start address:',0    
            
E_A_MSG     DC.B    'Enter end address:',0    * end address message

ADR_IN_ERR  DC.B    'ERROR INVALID ADDRESS: input must be 0-8 hexidecimal digits long',CR,LF,0    * address input error message

DATA_MSG    DC.B    'DATA   $',0

TEST_MSG    DC.B    'CONVERTED ADDRESS IS: ',0  * test message for printing start and end addresses
            
		    END     START        * last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
