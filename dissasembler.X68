*-----------------------------------------------------------
* Title      :  Dissasembler
* Written by :  Nick, Shelby, and Zoe
* Date       :
* Description:
*-----------------------------------------------------------
        ORG     $1000
		
****    MAIN LOOP   ****
INIT:   NOP     * line for testing
        JSR     RESET_BUF_PTR
        LEA     WELCOME,A1      * print welcome message
        JSR     WRITE_ASCII
        JSR     TERM_PNT_RST_BUF
        
START:  
        JSR     GET_CHOICE      * get choice from user to dissasemble or quit
        CMPI    #QUIT_PROG,D6
        BEQ     QUIT
        

INPUT_START:
        LEA     ST_A_MSG,A1     * load start address prompt message
        JSR     WRITE_ASCII     * write to string buffer
        JSR     TERM_PNT_RST_BUF * terminate string buffer and print reseting pointer at A4
        
        LEA     ST_ADDR,A1 * load start address
        CLR.L   (A1)    * clear long at a1
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        MOVE.B  D1,ST_LEN    * save start length to memory 
        
        JSR     IN_ADDR_TO_HEX  * convert start address to hex
             
        LEA     E_A_MSG,A1      * load end address prompt message
        JSR     WRITE_ASCII     * print message
        JSR     TERM_PNT_RST_BUF  * print and reset buffer no newline
        
        LEA     E_ADDR,A1  * load end address
        CLR.L   (A1)    * clear long at end address
        MOVE.B  #2,D0   * trap task 2 read a null terminated string from keyboard at A1 length at D1
        TRAP    #15
        MOVE.B  D1,E_LEN    * save end length to memory
        
        JSR     IN_ADDR_TO_HEX  * convert end address to hex
        
        JSR     CHK_ST_E_ADRS   * check addresses for errors
        CMPI.B  #1,D5           * if an error occured return to start
        BNE     ST_DIS          * branch to dissasembly if no errors
        JSR     WAIT_USR_INPUT    
        BRA     INPUT_START     * return to start
        
        * print converted addresses for testing purposes
        
ST_DIS  JSR     OP_CODES
        
        JSR     NL_TERM_PNT_RST_BUF * print newline after op codes
         
        BRA     START 


QUIT    MOVE.B	#9,D0
		TRAP	#15	* stop sim


****    OP-CODES    ****
OP_CODES:
        JSR     RESET_BUF_PTR   * reset string buffer pointer
        MOVE.L  ST_ADDR,A5  * load starting address into a5
        MOVE.L  E_ADDR,A6   * load ending address into a6
        
OP_START:          
        * write address and a tab to str buffer
        MOVE.L  A5,D1   * load address from A5 into D1
        MOVE.L  D1,CURRENT_ADDR * save backup of opcode word address
        MOVEQ   #32,D5   * set hex length to long for address printing
        JSR     WRITE_HEX_TO_ASCII
        JSR     WRITE_TAB_A4
        
        MOVE.W (A5),D2 * load word of memory into D1

        * clear ea mode and register values
        MOVE.B #0,SRC_REG
        MOVE.B #0,DEST_REG
        MOVE.B #0,SRC_MODE
        MOVE.B #0,DEST_MODE
        MOVE.L  #0,END_OP_CODE_PTR * clear end of op-code str buffer pointer
        MOVE.B  #0,EA_ERR_FLAG * clear ea error flag
        
CHK_LFT_NIB:
        MOVE.L  D2,D3   * copy to d2
        
        ANDI.W  #Nib3Mask,D3 * clear all but left four bits
        CMPI.W  #$1000,D3   * if nibble3 == 1, branch to move byte (1)
        BEQ     load_MOVE_B
        CMPI.W  #$2000,D3   * if nibble3 == 2, branch to that set (move.l, movea.l)
        BEQ     OP_2
        CMPI.W  #$3000,D3   * if nibble3 == 3, branch to that set (move.w, movea.w)
        BEQ     OP_3              
        CMPI.W  #$4000,D3   * if nibble3 == 4 branch to that set (not/nop/rts/jsr/movem/lea)
        BEQ     OP_4 
        CMPI.W  #$5000,D3   * if nibble3 == 5, branch to ADDQ (5)
        BEQ     ADDQ_
        CMPI.W  #$6000,D3   * if nibble3 == 6, branch to that set (bra, bcc)
        BEQ     OP_6
        CMPI.W  #$7000,D3   * if nibble3 == 7, branch to MOVEQ
        BEQ     load_MOVEQ
        CMPI.W  #$8000,D3   * if nibble3 == 8, branch to that set (divu, or)
        BEQ     OP_8
        CMPI.W  #$9000,D3   * if nibble3 == 9, branch to SUB
        BEQ     load_SUB
        CMPI.W  #$C000,D3   * if nibble3 == C, branch to that set (muls, and)
        BEQ     OP_C
        CMPI.W  #$D000,D3   * if nibble3 == D, branch to that set (add, adda)
        BEQ     OP_D
        CMPI.W  #$E000,D3   * if nibble3 == E, branch to that set (asl, asr, lsl, lsr)
        BEQ     OP_E
                       
OP_ERR  JSR     LOAD_DATA_STR_INTO_BUF   

DECODE_DONE:    * print newline then check if op-code loop is done
        JSR     NL_TERM_PNT_RST_BUF * write newline then print
        CMP.B   #-1,EA_ERR_FLAG
        BNE     NO_EA_ERROR
        MOVEA.L CURRENT_ADDR,A5 * reset curent address if ea error occurred
 NO_EA_ERROR:
        ADD.L   #2,A5   * increment current address pointer by 2 bytes 
        CMP.L   A6,A5  * loop if start is less than or equal to end
        BLE     OP_START
OP_DONE RTS

load_MOVE_B:    * load and print MOVE.B neumonic return to op loop
        LEA     _MOVE_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ	* save instruction size
        CLR     D3
        JSR     MOVE_EA
        **** EA CODE GOES HERE ****
        * must set unused mode/reg vars to 0
        JSR     BASE_EA_ERR_CHK * check globaly invalid eas
        JSR     DEST_AN_IM_INVALID * check specific invalid EAS
        BRA     DECODE_DONE
       
OP_2:   * could be MOVE.L or MOVEA.L
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate distinguishing bits 8-6
        CMPI.W  #$0040,D3        * if bits 8-6 are 001, instruction is MOVEA.L
        BEQ     load_MOVEA_L
        CMPI.W  #$0040,D3        * if bits 8-6 are NOT 001, instruction is MOVE.L
        BNE     load_MOVE_L
        
load_MOVEA_L:   * load and print MOVEA.L neumonic return to op loop
        LEA     _MOVEA_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ	* save instruction size
         **** EA CODE GOES HERE ****
        JSR     MOVE_EA

        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE

load_MOVE_L:    * load and print MOVE.L neumonic return to op loop
        LEA     _MOVE_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ	* save instruction size
        JSR     MOVE_EA
        JSR     BASE_EA_ERR_CHK * check globaly invalid eas
        JSR     DEST_AN_IM_INVALID * check specific invalid EAS
        BRA     DECODE_DONE
        
OP_3:   * could be MOVE.W or MOVEA.W
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate distinguishing bits 8-6
        CMPI.W  #$0040,D3        * if bits 8-6 are 001, instruction is MOVEA.W
        BEQ     load_MOVEA_W
        CMPI.W  #$0040,D3        * if bits 8-6 are NOT 001, instruction is MOVE.W
        BNE     load_MOVE_W
        
load_MOVEA_W:   * load and print MOVEA.W neumonic return to op loop
        LEA     _MOVEA_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ	* save instruction size
         **** EA CODE GOES HERE ****

        JSR     MOVE_EA
        JSR     SRC_GLOBAL_INVALID

        BRA     DECODE_DONE

load_MOVE_W:    * load and print MOVE.W neumonic return to op loop
        LEA     _MOVE_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ	* save instruction size
        JSR     MOVE_EA
        JSR     BASE_EA_ERR_CHK * check globaly invalid eas
        JSR     DEST_AN_IM_INVALID * check specific invalid EAS
        BRA     DECODE_DONE

OP_4:   * could be not, nop, rts, jsr, MOVEM.L, lea
        MOVE.L  D2,D3   * copy instruction word
        ANDI.W  #Nib2Mask,D3
        CMPI.W  #$0600,D3   * if nibble 2 is 6, instruction is NOT
        BEQ     NOT_

        CMPI.W  #$0E00,D3  * if nibble 2 is E could be nop or rts or jsr
        BEQ     NOP_RTS_JSR
        
        * try for LEA
        MOVE.L  D2,D3
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$01C0,D3       * if bits 8-6 are 111, instruction is LEA
        BEQ     load_LEA
        
        * try for MOVEM.W or MOVEM.L
        MOVE.L  D2,D3
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6 for size
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is MOVEM.W
        BEQ     load_MOVEM_W
        CMPI.W  #$00C0,D3       * if bits 8-6 are 011, instruction is MOVEM.L
        BEQ     load_MOVEM_L

        
        BRA     OP_ERR  * return to error decoding
        
NOT_:   * instruction is not, determine size
        MOVE.L  D2,D3
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$0000,D3       * if bits 8-6 are 000, instruction is NOT.B
        BEQ     load_NOT_B
        CMPI.W  #$0040,D3       * if bits 8-6 are 001, instruction is NOT.W
        BEQ     load_NOT_W
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is NOT.L
        BEQ     load_NOT_L
         
       
load_NOT_B:   * load and print NOT.B neumonic return to op loop
        LEA     _NOT_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     NOT_EA
        JSR     SRC_GLOBAL_INVALID * check globaly invalid eas bits 0-5
        JSR     SRC_AN_IM_INVALID * check specific invalid EAS bits 0-5
        BRA     DECODE_DONE
        
load_NOT_W:   * load and print NOT.W neumonic return to op loop
        LEA     _NOT_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     NOT_EA
        
        JSR     SRC_GLOBAL_INVALID * check globaly invalid eas bits 0-5
        JSR     SRC_AN_IM_INVALID * check specific invalid EAS bits 0-5
        BRA     DECODE_DONE
        
load_NOT_L:   * load and print NOT.L neumonic return to op loop
        LEA     _NOT_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ   * save instruction size
        JSR     NOT_EA
        
        JSR     SRC_GLOBAL_INVALID * check globaly invalid eas bits 0-5
        JSR     SRC_AN_IM_INVALID * check specific invalid EAS bits 0-5 
        BRA     DECODE_DONE

NOP_RTS_JSR: * could be NOP or RTS or JSR
        MOVE.L  D2,D3
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is JSR
        BEQ     load_JSR
    
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
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        BRA     DECODE_DONE
        
load_RTS:   * load and print RTS neumonic return to op loop
        LEA     _RTS,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        BRA     DECODE_DONE
        
load_LEA:   * load and print LEA neumonic return to op loop
        LEA     _LEA,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****

        JSR    LEA_EA

        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas
        JSR     SRC_PINC_PDEC_INVALID   * -(AN) invalid and (AN)+ invalid
        JSR     SRC_GLOBAL_INVALID

        BRA     DECODE_DONE
        
load_JSR:   * load and print JSR neumonic return to op loop
        LEA     _JSR,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     JSR_EA
        * check for invalid eas
        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas
        JSR     SRC_PINC_PDEC_INVALID    * -(AN) invalid and (AN)+ invalid
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_MOVEM_W:   * load and print MOVEM.W neumonic return to op loop
        LEA     _MOVEM_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
	    MOVE.B  #WORD,INST_SZ	* save instruction size
        JSR     MOVEM_EA
         * check for invalid eas
        MOVE.W  D2,D3  * copy full opcode to D3
        ANDI.W  #$0400,D3 * isolate direction bit
        BEQ     REG_MEM_W  * if zero register to memory else mem to reg
        JSR     SRC_AN_PDEC_INVALID * -(An) invalid for mem -> reg
        BRA     MAW_EA
REG_MEM_W:   
        JSR     SRC_AN_PINC_INVALID * (An)+ invalid for reg->mem
MAW_EA  JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas
        JSR     SRC_GLOBAL_INVALID
       
        BRA     DECODE_DONE
        
load_MOVEM_L:   * load and print MOVEM.L neumonic return to op loop
        LEA     _MOVEM_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ	* save instruction size
        JSR     MOVEM_EA
        *  check for invalid eas
        MOVE.W  D2,D3  * copy full opcode to D3
        ANDI.W  #$0400,D3 * isolate direction bit
        BEQ     REG_MEM_L * if zero register to memory else mem to reg
        JSR     SRC_AN_PDEC_INVALID * -(An) invalid for mem -> reg
        BRA     MAL_EA
REG_MEM_L:
        JSR     SRC_AN_PINC_INVALID * (An)+ invalid for reg->mem
MAL_EA  JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE

ADDQ_:  * instruction is addq, determine size
        MOVE.L  D2,D3
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$0000,D3       * if bits 8-6 are 000, instruction is ADDQ.B
        BEQ     load_ADDQ_B
        CMPI.W  #$0040,D3       * if bits 8-6 are 001, instruction is ADDQ.W
        BEQ     load_ADDQ_W
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is ADDQ.L
        BEQ     load_ADDQ_L           

load_ADDQ_B:  * load and print ADDQ.B neumonic return to op loop
        LEA     _ADDQ_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     ADDQ_EA
         *  check for invalid eas
        JSR     SRC_IM_INVALID
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
      
load_ADDQ_W:  * load and print ADDQ.W neumonic return to op loop
        LEA     _ADDQ_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     ADDQ_EA
         *  check for invalid eas
        JSR     SRC_IM_INVALID
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_ADDQ_L:  * load and print ADDQ.L neumonic return to op loop
        LEA     _ADDQ_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ
        JSR     ADDQ_EA
         *  check for invalid eas
        JSR     SRC_IM_INVALID
        JSR     SRC_GLOBAL_INVALID
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
        JSR     BRA_BCC_EA
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        BRA     DECODE_DONE
        
load_BEQ:   * load and print BEQ neumonic return to op loop
        LEA     _BEQ,A1
        JSR     WRITE_ASCII
        JSR     NEXT_MEM_WORD_TO_BUF
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     BRA_BCC_EA
        BRA     DECODE_DONE

load_BGT:   * load and print BGT neumonic return to op loop
        LEA     _BGT,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     BRA_BCC_EA
        BRA     DECODE_DONE
        
load_BLE:   * load and print BLE neumonic return to op loop
        LEA     _BLE,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     BRA_BCC_EA
        BRA     DECODE_DONE
        
load_MOVEQ: * load and print MOVEQ neumonic return to op loop
        LEA     _MOVEQ,A1
        JSR     WRITE_ASCII
        JSR     MOVEQ_EA
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        BRA     DECODE_DONE
        
OP_8:       * could be DIVU or OR
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit1Mask,D3   * mask, isolate distinguishing bits 8-6
        CMPI.W  #$00C0,D3       * if bits 8-6 are 011, instruction is DIVU
        BEQ     load_DIVU
        CMPI.W  #$00C0,D3       * if bits 8-6 are NOT 011, instruction is OR
        BNE     load_OR

load_DIVU:  * load and print DIVU neumonic return to op loop
        LEA     _DIVU,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
        JSR     DM_EA
        * EA error check
        JSR     SRC_AN_INVALID          
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_OR:    * load and print DIVU neuomnic return to op loop
        LEA     _OR,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
        JSR     OPMODE_EA
        * must set unused mode/reg vars to 0
        JSR     OR_AND_EA_INVALID
        BRA     DECODE_DONE

load_SUB:   * load and print SUB neumonic return to op loop
        LEA     _SUB,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
        JSR     OPMODE_EA
        JSR     SUB_ADD_EA_INVALID
        BRA     DECODE_DONE

OP_C:       * could be MULS or AND
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate distinguishing bits 8-6
        CMPI.W  #$01C0,D3       * if bits 8-6 are 111, instruction is MULS
        BEQ     load_MULS
        CMPI.W  #$01C0,D3       * if bits 8-6 are NOT 111, instruction is AND
        BNE     load_AND
        
load_MULS:  * load and print MULS neumonic return to op loop
        LEA     _MULS,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
         JSR    DM_EA
        * EA error check
        JSR     SRC_AN_INVALID          
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_AND:   * load and print AND neumonic return to op loop
        LEA     _AND,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
        JSR     OPMODE_EA
        
        JSR     OR_AND_EA_INVALID
        BRA     DECODE_DONE

OP_D:       * could be ADD or ADDA
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6 (opmode but distinguishes instr.)
        CMPI.W  #$00C0,D3       * if bits 8-6 are 011, instruction is ADDA
        BEQ     load_ADDA
        CMPI.W  #$01C0,D3       * if bits 8-6 are 111, instruction is also ADDA
        BEQ     load_ADDA
        BNE     load_ADD        * if bits 8-6 are not either, instruction is ADD
        
load_ADDA:  * load and print ADDA neumonic return to op loop
        LEA     _ADDA,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****

        JSR     OPMODE_EA
        * EA error check     
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE

load_ADD:   * load and print ADD neumonic return to op loop
        LEA     _ADD,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
         **** EA CODE GOES HERE ****
        JSR     OPMODE_EA
        * EA error check     
        JSR     SUB_ADD_EA_INVALID
        BRA     DECODE_DONE

OP_E:       * could be ASL, ASR, LSL, LSR (memory or register)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.L  #Bit1Mask,D3   * mask, isolate bits 8-6
        CMPI.W  #$00C0,D3   * if bits 8-6 are 011, instruction is MEMORY shift
        BEQ     MEMORY_shift
        CMPI.W  #$01C0,D3   * if bits 8-6 are 111, instruction is MEMORY shift
        BEQ     MEMORY_shift
        CMPI.W  #$01C0,D3   * if bits 8-6 are NOT 011 or 111, instruction is REG shift
        BNE     REG_shift        
        
MEMORY_shift:   * could be ASL, ASR, LSL, LSR (memory)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit0Mask,D3    * mask, isolate bits 11-9
        CMPI.W  #$0000,D3       * if bits 11-9 are 000, instruction is ASL or ASR (memory)
        BEQ     ASL_ASR_MEM
        CMPI.W  #$0200,D3       * if bits 11-9 are 001, instruction is LSL or LSR (memory)
        BEQ     LSL_LSR_MEM
        
ASL_ASR_MEM:    * could be ASL or ASR (memory)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$00C0,D3       * if bits 8-6 are 011, instruction is ASR memory
        BEQ     load_ASR_MEM
        CMPI.W  #$01C0,D3       * if bits 8-6 are 111, instruction is ASL memory
        BEQ     load_ASL_MEM
        
load_ASR_MEM:   * load and print ASR neumonic return to op loop
        LEA     _ASR,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     MEM_SHIFT_EA
        * EA error check
        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas     
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_ASL_MEM:   * load and print ASL neumonic return to op loop
        LEA     _ASL,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     MEM_SHIFT_EA
         * EA error check
        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas     
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE

LSL_LSR_MEM:    * could be LSL or LSR (memory) 
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit1Mask,D3    * mask, isolate bits 8-6
        CMPI.W  #$00C0,D3       * if bits 8-6 are 011, instruction is LSR memory
        BEQ     load_LSR_MEM
        CMPI.W  #$01C0,D3       * if bits 8-6 are 111, instruction is LSL memory
        BEQ     load_LSL_MEM 
        
load_LSR_MEM:   * load and print LSR neumonic return to op loop
        LEA     _LSR,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     MEM_SHIFT_EA
         * EA error check
        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas     
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE
        
load_LSL_MEM:   * load and print LSL neumonic return to op loop
        LEA     _LSL,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        JSR     MEM_SHIFT_EA
         * EA error check
        JSR     SRC_DN_AN_IM_INVALID    * DN, AN, #<data> invalid eas     
        JSR     SRC_GLOBAL_INVALID
        BRA     DECODE_DONE

REG_shift:      * could be ASL, ASR, LSL, LSR (register)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.W  #Bit2Mask,D3    * mask, isolate bits 5-3
        CMPI.W  #$0000,D3        * if bits 5-3 are 000, instruction is ASL or ASR (reg)
        BEQ     ASL_ASR_REG
        CMPI.W  #$0020,D3       * if bits 5-3 are 100, instruction is ASL or ASR (reg)
        BEQ     ASL_ASR_REG
        CMPI.W  #$0008,D3       * if bits 5-3 are 001, instruction is LSL or LSR (reg)
        BEQ     LSL_LSR_REG
        CMPI.W  #$0028,D3       * if bits 5-3 are 101, instruction is LSL or LSR (reg)
        BEQ     LSL_LSR_REG
        
ASL_ASR_REG:    * could be ASL or ASR (register)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.L  #Bit1Mask,D3    * mask, isolate bits 8-6
        
        CMPI.W  #$0000,D3       * if bits 8-6 are 000, instruction is ASR.B register
        BEQ     load_ASR_B_REG
        CMPI.W  #$0040,D3       * if bits 8-6 are 001, instruction is ASR.W register
        BEQ     load_ASR_W_REG
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is ASR.L register
        BEQ     load_ASR_L_REG
        
        CMPI.W  #$0100,D3       * if bits 8-6 are 100, instruction is ASL.B register
        BEQ     load_ASL_B_REG
        CMPI.W  #$0140,D3       * if bits 8-6 are 101, instruction is ASL.W register
        BEQ     load_ASL_W_REG
        CMPI.W  #$0180,D3       * if bits 8-6 are 110, instruction is ASL.L register
        BEQ     load_ASL_L_REG

load_ASR_B_REG:   * load and print ASR.B neumonic return to op loop
        LEA     _ASR_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE
        
load_ASR_W_REG:   * load and print ASR.W neumonic return to op loop
        LEA     _ASR_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE
        
load_ASR_L_REG:   * load and print ASR.L neumonic return to op loop
        LEA     _ASR_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE
        
load_ASL_B_REG:   * load and print ASL.B neumonic return to op loop
        LEA     _ASL_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE
        
load_ASL_W_REG:   * load and print ASL.W neumonic return to op loop
        LEA     _ASL_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE
        
load_ASL_L_REG:   * load and print ASL.L neumonic return to op loop
        LEA     _ASL_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ   * save instruction size
        JSR     AS_REG_EA
        BRA     DECODE_DONE

LSL_LSR_REG:    * could be LSL or LSR (register)
        MOVE.L  D2,D3       * copy instruction word
        ANDI.L  #Bit1Mask,D3    * mask, isolate bits 8-6
        
        CMPI.W  #$0000,D3       * if bits 8-6 are 000, instruction is LSR.B register
        BEQ     load_LSR_B_REG
        CMPI.W  #$0040,D3       * if bits 8-6 are 001, instruction is LSR.W register
        BEQ     load_LSR_W_REG
        CMPI.W  #$0080,D3       * if bits 8-6 are 010, instruction is LSR.L register
        BEQ     load_LSR_L_REG
        
        CMPI.W  #$0100,D3       * if bits 8-6 are 100, instruction is LSL.B register
        BEQ     load_LSL_B_REG
        CMPI.W  #$0140,D3       * if bits 8-6 are 101, instruction is LSL.W register
        BEQ     load_LSL_W_REG
        CMPI.W  #$0180,D3       * if bits 8-6 are 110, instruction is LSL.L register
        BEQ     load_LSL_L_REG

load_LSR_B_REG:   * load and print LSR.B neumonic return to op loop
        LEA     _LSR_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE
        
load_LSR_W_REG:   * load and print LSR.W neumonic return to op loop
        LEA     _LSR_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE
        
load_LSR_L_REG:   * load and print LSR.L neumonic return to op loop
        LEA     _LSR_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE
        
load_LSL_B_REG:   * load and print LSL.B neumonic return to op loop
        LEA     _LSL_B,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #BYTE,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE
        
load_LSL_W_REG:   * load and print LSL.W neumonic return to op loop
        LEA     _LSL_W,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #WORD,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE
        
load_LSL_L_REG:   * load and print LSL.L neumonic return to op loop
        LEA     _LSL_L,A1
        JSR     WRITE_ASCII
        JSR     SET_END_OP_CODE_PTR     * note mem location following op-code neumonic
        MOVE.B  #LONG,INST_SZ   * save instruction size
        JSR     LS_REG_EA
        BRA     DECODE_DONE

****       EA       ****

**** MOVE_EA FIRST EA COMMAND *********
MOVE_EA:
        MOVE.L  D2,D3           *copy instruction to D3 for register
        MOVE.L  D2,D4           *copy instruction to D4 for mode
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4 
******* MOVE_EA SECOND EA COMMAND **********
        MOVE.L  D2,D3           *copy instruction to D3 for register
        MOVE.L  D2,D4           *copy instruction to D4 for modE
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        ANDI.W  #Bit1Mask,D4    *mask to isolate 3-bit mode
        MOVE.B  #9, D5
        LSR     D5,D3 
        LSR.L   #6,D4
        MOVE.B  D4,DEST_MODE     * save destination ea mode to memory
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D4
        MULU   #6,D3
       
        LEA     EA_MODE,A1 
        JSR     (A1,D4)
        RTS

********** NOT_EA ***********
NOT_EA:
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA register
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source EA mode to memory
        MOVE.B  D3,SRC_REG      * save source EA register to memory
        MULU    #6,D4
        MULU    #6,D3
        
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        RTS
        
********** JSR_EA ***********
JSR_EA:
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA register
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source EA mode to memory
        MOVE.B  D3,SRC_REG      * save source EA register to memory
        MULU    #6,D4
        MULU    #6,D3
        
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        RTS
        
********** LEA_EA ***********
LEA_EA:
        MOVE.L  D2,D3 
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4 


        MOVE.L  D2,D3 
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        MOVE.B  #9, D5
        LSR     D5,D3 
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D3
        MOVE.W  #$0001,D4       *set mode to address register
        MULU    #6,D4


        LEA     EA_MODE,A1 
        JSR     (A1,D4)
        RTS
        
******** MOVEM_EA ***********
MOVEM_EA:
        MOVE.L  D2,D3
        ANDI.W  #Bit0Mask,D3    * mask to isolate bits 11-9 to get dr
        CMPI.W  #$0800,D3       * if bit 10 is 0, dr is register to memory
        BEQ     MOVEM_REG_EA
        CMPI.W  #$0C00,D3       * if bit 10 is 1, dr is memory to register
        BEQ     MOVEM_MEM_EA

****** MOVEM_REG_EA **********
MOVEM_REG_EA:
        CLR.L   D3
        CLR.L   D4
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA reg
        LSR     #3,D4
        MOVE.B  D4,SRC_MODE     * save mode to memory
        MOVE.B  D3,SRC_REG      * save register to memory
        MULU    #6,D4
        MULU    #6,D3
        * code for list goes here *
        LEA     _AR,A2
        LEA     _DR,A3
        JSR     NEXT_MEM_WORD_TO_D1     * get bit mask
        MOVE.W  D1,MOVEM_MASK           * save bit mask to memory
        CMP.B   #24,D4
        BEQ     MOVEM_PDEC
        MOVEQ.L #1,D0
        LEA     _DR,A2
        LEA     _AR,A3
        BRA     MOVEM_OTHER * set mem to reg for all modes other than -(An)
MOVEM_PDEC:
        MOVEQ.L #0,D0   * set to reg to mem
MOVEM_OTHER:
        JSR     REG_LOOP

        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        
        RTS


****** MOVEM_MEM_EA **********
MOVEM_MEM_EA: 
        CLR.L   D3
        CLR.L   D1
        CLR.L   D4 
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        JSR     NEXT_MEM_WORD_TO_D1     * get bit mask
        MOVE.W  D1,MOVEM_MASK           * save bit mask to memory

        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA reg
        LSR     #3,D4
        MOVE.B  D4,SRC_MODE     * save mode to memory
        MOVE.B  D3,SRC_REG      * save register to memory
        MULU    #6,D4
        MULU    #6,D3
        
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        
        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        
        LEA     _DR,A2
        LEA     _AR,A3
        MOVEQ.L #1,D0   * set to mem to reg
        JSR     REG_LOOP

        RTS

* load a2 with register type that corisponds with bits 0-7
* load a3 with register type that corisponds with bits 8-15
* d0 i is direction if 0 reg to mem  if 1 mem to reg        
REG_LOOP:
        MOVEM.L D2/D3/D4/D7,-(SP)
        CLR.L   D7
        MOVE.B  #0,D3
        MOVE.B  #16,D4         
        MOVE.W  MOVEM_MASK,D2                   * copy mask to d2
        JSR     COUNT_BITS_IN_WORD      * set reg count in d6
        * to do: loop for going through the register list mask *
REG_LOOP_START:
        CMP.B   D4,D3
        BGE     REG_LOOP_DONE
        BTST    D3,D2           * test ith bit of D1
        BEQ     REG_LOOP_INC
        MOVE.B  D3,D7           * copy bit num to d7
        SUB.B   #1,D6           * subract one from reg count
        CMP.B   #7,D3
        BGT     REG_TYPE_2
        MOVEA.L A2,A1           * load first label type
        BRA     REG_PRINT
REG_TYPE_2:
        MOVEA.L A3,A1           * load second label type
        * MEM TO REG
        SUB.B   #8,D7           * correct register number
        CMP.B   #1,D0
        BEQ     REG_NUM_PRINT
        * REG TO MEM   
        MOVE.B  #15,D7
        SUB.B   D3,D7
        BRA     REG_NUM_PRINT
REG_PRINT: 
        CMP.B   #1,D0
        BEQ     REG_NUM_PRINT   * if mem to reg skip reg num adjustment
        * REG TO MEM
        MOVE.B  #7,D7
        SUB.B   D3,D7
REG_NUM_PRINT:
        JSR     WRITE_ASCII
        CLR     D1
        MOVE.B  D7,D1           * copy reg num to d1        
        MOVE.B  #4,D5           * set to nibble    
        JSR     WRITE_HEX_TO_ASCII      * write register number
        CMP.B   #0,D6
        BEQ     REG_LOOP_DONE
        LEA     _SLASH,A1               * write slash if necessary
        JSR     WRITE_ASCII
REG_LOOP_INC:
        ADD.B   #1,D3
        BRA     REG_LOOP_START
REG_LOOP_DONE:
        MOVEM.L (SP)+,D2/D3/D4/D7
        RTS 
        


* input word in d1 output in d6     
COUNT_BITS_IN_WORD:
        MOVEM.L D3/D4,-(SP)
        CLR.L   D6
        MOVE.B  #0,D3
        MOVE.B  #16,D4

CB_LOOP_START:
        CMP.B   D4,D3
        BGE     CB_LOOP_DONE
        BTST    D3,D1           * test ith bit of D1
        BEQ     CB_LOOP_INC
        ADD.B   #1,D6   
CB_LOOP_INC:
        ADD.B   #1,D3
        BRA     CB_LOOP_START
CB_LOOP_DONE:
        MOVEM.L (SP)+,D3/D4
        RTS 
        
********* ADDQ_EA ************
ADDQ_EA:
        MOVE.L  D2,D3
        ANDI.W  #Bit0Mask,D3    * mask to isolate 3-bit data
        MOVE.B  #9,D5
        LSR     D5,D3
        MOVE.B  D3,DEST_REG     * save data to memory
        MULU    #6,D3
        
        LEA     _IMD,A1
        JSR     WRITE_ASCII
        LEA     EA_IMM,A1
        JSR     (A1,D3)
        
        CLR     D3
        
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA register
        LSR     #3,D4
        MOVE.B  D4,SRC_MODE      * save source register to memory
        MOVE.B  D3,SRC_REG    * save source mode to memory
        MULU    #6,D4
        MULU    #6,D3
        
        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        
        RTS
        
********** BRA_BCC_EA ************
BRA_BCC_EA:
        MOVE.L  D2,D3
        ANDI.W  #Byte0Mask,D3
        CMPI.W  #$0000,D3       * if last 8 bits are 00, write next word of memory
        BNE     BRA_LONG_EA
        JSR     NEXT_MEM_WORD_TO_BUF
        RTS
BRA_LONG_EA:
        CMPI.W  #$00FF,D3       * if last 8 bits are FF, write next long of memory
        BNE     BRA_8BIT_EA
        JSR     NEXT_MEM_LONG_TO_BUF
        RTS
BRA_8BIT_EA:                    * else 8 bit displacement
        CLR.L   D1
        MOVE.W  D3,D1
        MOVE.L  #8,D5           * set hex digit size to byte
        JSR     WRITE_HEX_TO_ASCII
        RTS

        
******** MOVEQ_EA ************
* kinda works *
MOVEQ_EA:
        MOVE.L  D2,D3
        ANDI.W  #Byte0Mask,D3
        
        LEA     _IMD,A1
        JSR     WRITE_ASCII
        LEA     _ABS,A1
        JSR     WRITE_ASCII
        
        CLR.L   D1
        MOVE.W  D3,D1
        MOVE.L  #2,D5
        JSR     WRITE_HEX_TO_ASCII
        
        CLR     D3
        
        MOVE.L  D2,D3
        ANDI.W  #Bit0Mask,D3
        MOVE.B  #9,D5
        LSR     D5,D3
        MOVE.B  D3,DEST_REG
        MULU    #6,D3
        
        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        LEA     _DR,A1
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        RTS

********* DM_EA ************
DM_EA:
        MOVE.L  D2,D3 
        MOVE.L  D2,D4
        MOVE.B  #WORD,INST_SZ   * divu and muls always word for ea
        
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4 

        MOVE.L  D2,D3 
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        MOVE.B  #9, D5
        LSR     D5,D3 
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D3
        LEA     _DR,A1 
        JSR WRITE_ASCII


        LEA     EA_REG,A1 
        JSR     (A1,D3)
        RTS 

****** 0PMODE_EA ************
OPMODE_EA:
        MOVE.L  D2,D4
        ANDI.W  #Bit1Mask,D4            *FIND OPMODE
        LSR.L   #6,D4
        MOVE.B  D4,DEST_MODE     * save destination ea mode to memory
        MULU    #6,D4 

        LEA     OPMODE,A1               *LOAD OPMODE TABLE
        JSR     (A1,D4)                 *JMP TO OPMODE TABLE


        CMP.B   #%1,D5                  *if flag == 1, <ea> V Dn - Dn
        BEQ     D_TO_EA
        CMP.B   #%11,D5                 *if flag == 2, <ea> - An
        BEQ     EA_TO_A
        CMP.B   #%1,D5                  *else, Dn V <ea> - <ea>
        BNE     EA_TO_D
        RTS
EA_TO_D:
        CLR     D3
        CLR     D4

        MOVE.L  D2,D3 
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4 

        MOVE.L  D2,D3 
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        MOVE.B  #9, D5
        LSR     D5,D3 
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D3
        LEA     _DR,A1 
        JSR WRITE_ASCII


        LEA     EA_REG,A1 
        JSR     (A1,D3)
        RTS

D_TO_EA:

        CLR     D3
        CLR     D4 

        MOVE.L  D2,D3 
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        MOVE.B  #9, D5
        LSR     D5,D3 
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D3
        LEA     _DR,A1 
        JSR WRITE_ASCII


        LEA     EA_REG,A1 
        JSR     (A1,D3)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4

        MOVE.L  D2,D3 
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        RTS

EA_TO_A:
        CLR     D3
        CLR     D4

        MOVE.L  D2,D3 
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    *mask to isolate 3-bit source mode
        ANDI.W  #Bit3Mask,D3    *mask to isolate 3-bit source register 
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source ea mode to memory
        MOVE.B  D3,SRC_REG      * save source register to memory
        MULU    #6,D4
        MULU    #6,D3

        LEA     EA_MODE,A1
        JSR     (A1,D4)
        LEA     _COMMA,A1
        JSR     WRITE_ASCII

        CLR     D3
        CLR     D4 

        MOVE.L  D2,D3 
        ANDI.W  #Bit0Mask,D3    *mask to isolate 3-bit register code
        MOVE.B  #9, D5
        LSR     D5,D3 
        MOVE.B  D3,DEST_REG      * save destination register to memory 
        MULU   #6,D3
        LEA     _AR,A1 
        JSR WRITE_ASCII


        LEA     EA_REG,A1 
        JSR     (A1,D3)
        RTS
        
******* ASR_MEM_EA ******
MEM_SHIFT_EA:
        MOVE.L  D2,D3
        MOVE.L  D2,D4
        ANDI.W  #Bit2Mask,D4    * mask to isolate 3-bit EA mode
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit EA register
        LSR.L   #3,D4
        MOVE.B  D4,SRC_MODE     * save source EA mode to mem
        MOVE.B  D3,SRC_REG      * save source EA reg to mem
        MULU    #6,D4
        MULU    #6,D3
        
        LEA     EA_MODE,A1
        JSR     (A1,D4)
        RTS
        
******* LS_REG_EA *******
LS_REG_EA:
        MOVE.L  D2,D3
        * determine shift count specification
        ANDI.L  #Bit2Mask,D3    * mask, isolate bits 5-3
        CMPI.W  #$0008,D3       * if bits 5-3 are 001, i/r is 0 and field is immediate byte
        BEQ     REG_IMM_EA
        CMPI.W  #$0028,D3       * if bits 5-3 are 101, i/r is 1 and field is register
        BEQ     REG_REG_EA
        
******* AS_REG_EA *******
AS_REG_EA:
        MOVE.L  D2,D3
        * determine shift count specification
        ANDI.L  #Bit2Mask,D3    * mask, isolate bits 5-3
        CMPI.W  #$0000,D3       * if bits 5-3 are 000, i/r is 0 and field is immediate byte
        BEQ     REG_IMM_EA
        CMPI.W  #$0020,D3       * if bits 5-3 are 001, i/r is 1 and field is register
        BEQ     REG_REG_EA
        
******* REG_IMM_EA ******
REG_IMM_EA:
        MOVE.L  D2,D3
        ANDI.W  #Bit0Mask,D3    * find shift count
        MOVE.B  #9,D5
        LSR     D5,D3
        MOVE.B  D3,DEST_REG     * save shift count to memory
        MULU    #6,D3
        
        LEA     _IMD,A1
        JSR     WRITE_ASCII
        LEA     EA_IMM,A1
        JSR     (A1,D3)
        
        CLR     D3
        
        MOVE.L  D2,D3
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit register
        MOVE.B  D3,SRC_REG      * save register to memory
        MULU    #6,D3
        
        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        LEA     _DR,A1
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        
        RTS
        
****** REG_REG_EA *******
REG_REG_EA:
        MOVE.L  D2,D3
        ANDI.W  #Bit0Mask,D3    * mask to isolate 3-bit register w/shift count
        MOVE.B  #9,D5
        LSR     D5,D3
        MOVE.B  D3,DEST_REG     * save register to memory
        MULU    #6,D3
        
        LEA     _DR,A1
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        
        CLR     D3
        
        MOVE.L  D2,D3
        ANDI.W  #Bit3Mask,D3    * mask to isolate 3-bit register
        MOVE.B  D3,SRC_REG      * save register to memory
        MULU    #6,D3
        
        LEA     _COMMA,A1
        JSR     WRITE_ASCII
        LEA     _DR,A1
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        
        RTS

******* OPMODE **********
OPMODE:
        JMP     OM000
        JMP     OM001
        JMP     OM010
        JMP     OM011
        JMP     OM100
        JMP     OM101
        JMP     OM110
        JMP     OM111

OM000:
        LEA     _B,A1
        JSR     WRITE_ASCII
        CLR     D5
        RTS   
OM001:
        LEA     _W,A1
        JSR     WRITE_ASCII
        CLR     D5

        RTS   
OM010:
        LEA     _L,A1
        JSR     WRITE_ASCII
        CLR     D5

        RTS   
OM011:
        LEA     _W,A1
        JSR     WRITE_ASCII
        MOVE.B  #%11,D5
        RTS   
OM100:
        LEA     _B,A1
        JSR     WRITE_ASCII
        MOVE.B  #%1,D5

        RTS   
OM101:
        LEA     _W,A1
        JSR     WRITE_ASCII
        MOVE.B  #%1,D5

        RTS   
OM110:
        LEA     _L,A1
        JSR     WRITE_ASCII
        MOVE.B  #%1,D5

        RTS   
OM111:
        LEA     _L,A1
        JSR     WRITE_ASCII
        MOVE.B  #%11,D5
        RTS   
 
        


******** JUMP TABLE FOR EA MODES *********
EA_MODE:
        JMP     EA000
        JMP     EA001
        JMP     EA010
        JMP     EA011
        JMP     EA100
        JMP     EA101
        JMP     EA110
        JMP     EA111

EA000:
        LEA     _DR,A1 
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        RTS     
EA001:
        LEA     _AR,A1 
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        RTS     
EA010:
        LEA     _IND_AR1,A1 
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        LEA     _IND_AR2,A1
        JSR     WRITE_ASCII
        RTS     
    
EA011:
        LEA     _AR_POST1,A1 
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        LEA     _AR_POST2,A1
        JSR     WRITE_ASCII
        RTS
     
    
EA100:
        LEA     _AR_PRE1,A1 
        JSR     WRITE_ASCII
        LEA     EA_REG,A1
        JSR     (A1,D3)
        LEA     _AR_PRE2,A1
        JSR     WRITE_ASCII
        RTS   

EA101:  RTS

EA110:  RTS

EA111:  	
		DIVU	#6,D3	* divide register num by 6 to undo jmp table multiplication
		
		CMP	#0,D3	* if reg 0 load word from mem
		BNE	EA111_R1
		LEA	_ABS,A1
		JSR	WRITE_ASCII		* write $ to buffer
		JSR	NEXT_MEM_WORD_TO_BUF
		RTS
EA111_R1:
		CMP	#1,D3	* if reg 1 load long from mem
		BNE	EA111_R4
		LEA	_ABS,A1
		JSR	WRITE_ASCII		* write $ to buffer
		JSR	NEXT_MEM_LONG_TO_BUF
		RTS
EA111_R4:		
		CMP	#%100,D3  * if reg 4 load immediate value
		* will need to know instruction size to propperly grab this
		BNE	EA_MODE_DONE    * EA error if not equal to one of the valid modes
		JSR	ADD_IMMEDIATE_TO_BUF
EA_MODE_DONE:
		RTS
		

********* JUMP TABLE FOR REGISTERS ******
EA_REG:
        JMP     REG000
        JMP     REG001
        JMP     REG010
        JMP     REG011
        JMP     REG100
        JMP     REG101
        JMP     REG110
        JMP     REG111

REG000:
        LEA     _ZERO,A1 
        JSR     WRITE_ASCII
        RTS   
REG001:
        LEA     _ONE,A1 
        JSR     WRITE_ASCII
        RTS   
REG010:
        LEA     _TWO,A1 
        JSR     WRITE_ASCII
        RTS   
REG011:
        LEA     _THREE,A1 
        JSR     WRITE_ASCII
        RTS   
REG100:
        LEA     _FOUR,A1 
        JSR     WRITE_ASCII
        RTS   
REG101:
        LEA     _FIVE,A1 
        JSR     WRITE_ASCII
        RTS   
REG110:
        LEA     _SIX,A1 
        JSR     WRITE_ASCII
        RTS   
REG111:
        LEA     _SEVEN,A1 
        JSR     WRITE_ASCII
        RTS   
  
********* JUMP TABLE FOR IMMEDIATE VALUE ******
EA_IMM:
        JMP     IMM000
        JMP     IMM001
        JMP     IMM010
        JMP     IMM011
        JMP     IMM100
        JMP     IMM101
        JMP     IMM110
        JMP     IMM111

IMM000:
        LEA     _EIGHT,A1 
        JSR     WRITE_ASCII
        RTS   
IMM001:
        LEA     _ONE,A1 
        JSR     WRITE_ASCII
        RTS   
IMM010:
        LEA     _TWO,A1 
        JSR     WRITE_ASCII
        RTS   
IMM011:
        LEA     _THREE,A1 
        JSR     WRITE_ASCII
        RTS   
IMM100:
        LEA     _FOUR,A1 
        JSR     WRITE_ASCII
        RTS   
IMM101:
        LEA     _FIVE,A1 
        JSR     WRITE_ASCII
        RTS   
IMM110:
        LEA     _SIX,A1 
        JSR     WRITE_ASCII
        RTS   
IMM111:
        LEA     _SEVEN,A1 
        JSR     WRITE_ASCII
        RTS   
 
***      EA ERRORS      ***

* invalid codes for all instructions
BASE_EA_ERR_CHK:
        MOVEM.L D6-D7,-(SP)
        JSR LOAD_SRC_EA_D6_D7
        JSR GLOBAL_INVALID_EAS
        JSR LOAD_DEST_EA_D6_D7
        JSR GLOBAL_INVALID_EAS
        MOVEM.L (SP)+,D6-D7
        RTS
     
* write error to string buffer and move on to next instruction
EA_ERR:
        MOVEM.L D0/A1,-(SP)
        MOVE.L  END_OP_CODE_PTR,D0      * load end of opcode pointer
        CMPI.L  #0,D0                   * if ptr is 0 use existing str buf value
        BEQ     LOAD_EA_ERR_MSG
        MOVEA.L D0,A4                   * reset string buffer pointer to end of opcode neumonic 
        * load error message to buffer
LOAD_EA_ERR_MSG:
        LEA     EA_ERR_MSG,A1
        JSR     WRITE_ASCII
        MOVE.B  #-1,EA_ERR_FLAG
        MOVEM.L (SP)+,D0/A1
        RTS


LOAD_SRC_EA_D6_D7:
        CLR.L   D6
        CLR.L   D7
        * load source modes and registers
        MOVE.B  SRC_MODE,D6
        MOVE.B  SRC_REG,D7
        RTS

LOAD_DEST_EA_D6_D7:
        CLR.L   D6
        CLR.L   D7
        * load destination modes and registers
        MOVE.B  DEST_MODE,D6
        MOVE.B  DEST_REG,D7
        RTS

*** EA ERROR groups ***

* load d6 with mode, d7 with register
GLOBAL_INVALID_EAS:
        JSR DAN_EA_CHK    * error on (d16,An)
        JSR DANXN_EA_CHK  * error on (d8,An,Xn)
        JSR DPC_EA_CHK    * error on (d16,PC)
        JSR DPCXN_EA_CHK  * error on (d8,PC,Xn)
        JSR MODE_7_EA_CHK * error on invalid mode 7 reg values
        RTS

* SRC bits 0-5 
SRC_GLOBAL_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     GLOBAL_INVALID_EAS
        MOVEM.L (SP)+,D6-D7
        RTS

* destination (bits 6-11) address register and imediate mode are invalid eas
DEST_AN_IM_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_DEST_EA_D6_D7
        JSR     IM_DATA_EA_CHK
        JSR     AN_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* source (bits 0-5) address register and imediate mode are invalid eas
SRC_AN_IM_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     IM_DATA_EA_CHK
        JSR     AN_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* error for  DN, AN, or Imediate modes for source ea bits 0-5
SRC_DN_AN_IM_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     IM_DATA_EA_CHK
        JSR     AN_EA_CHK
        JSR     DN_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* error for -(AN) in source mode bits 3-5
SRC_AN_PDEC_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     AN_PDEC_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* error for (AN)+ in source mode bits 3-5
SRC_AN_PINC_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     AN_PINC_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* -(AN) invalid and (AN)+ invalid bits 3-5
SRC_PINC_PDEC_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     AN_PINC_EA_CHK
        JSR     AN_PDEC_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

* error for  Imediate modes for source ea bits 0-5
SRC_IM_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     IM_DATA_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

SRC_AN_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     AN_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS

SRC_DN_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_SRC_EA_D6_D7
        JSR     DN_EA_CHK
        MOVEM.L (SP)+,D6-D7
        RTS


SUB_ADD_EA_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_DEST_EA_D6_D7
        CMP.B   #0,D6
        BLT     SUB_ERR   * if opmode < 0 bad data
        CMP.B   #4,D6
        BGE     SUB_DN_EA  * if opmode >= 4 check if less than 7       
        * EA -> DN
        JSR     SRC_GLOBAL_INVALID
        BRA     SUB_EA_IN_DONE
SUB_DN_EA:
        CMP.B   #7,D6
        BGE     SUB_ERR  * if opcode >= 7 error
        * DN -> EA
        JSR     SRC_DN_AN_IM_INVALID
        JSR     SRC_GLOBAL_INVALID
        BRA     SUB_EA_IN_DONE

SUB_ERR JSR     EA_ERR
SUB_EA_IN_DONE:
        MOVEM.L (SP)+,D6-D7
        RTS

OR_AND_EA_INVALID:
        MOVEM.L D6-D7,-(SP)
        JSR     LOAD_DEST_EA_D6_D7
        CMP.B   #0,D6
        BLT     OR_ERR   * if opmode < 0 bad data
        CMP.B   #4,D6
        BGE     OR_DN_EA  * if opmode >= 4 check if less than 7       
        * EA -> DN
        JSR     SRC_AN_INVALID
        JSR     SRC_GLOBAL_INVALID
        BRA     OR_EA_IN_DONE
OR_DN_EA:
        CMP.B   #7,D6
        BGE     OR_ERR  * if opcode >= 7 error
        * DN -> EA
        JSR     SRC_DN_AN_IM_INVALID
        JSR     SRC_GLOBAL_INVALID
        BRA     OR_EA_IN_DONE

OR_ERR  JSR     EA_ERR
OR_EA_IN_DONE:
        MOVEM.L (SP)+,D6-D7
        RTS

*** Checks for individual EA modes

* prints ea error to buffer if DN mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
DN_EA_CHK:
        CMP.B #%000,D6
        BNE   END_DN_EA_CHK
        JSR   EA_ERR
END_DN_EA_CHK:
        RTS

* prints ea error to buffer if AN mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
AN_EA_CHK:
        CMP.B #%001,D6
        BNE   END_AN_EA_CHK
        JSR   EA_ERR
END_AN_EA_CHK:
        RTS      

* prints ea error to buffer if (AN) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
AN_IND_EA_CHK:
        CMP.B #%010,D6
        BNE   END_AN_IND_EA_CHK
        JSR   EA_ERR
END_AN_IND_EA_CHK:
        RTS      

* prints ea error to buffer if (AN)+ mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
AN_PINC_EA_CHK:
        CMP.B #%011,D6
        BNE   END_AN_PINC_EA_CHK
        JSR   EA_ERR
END_AN_PINC_EA_CHK:
        RTS      

* prints ea error to buffer if -(AN) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
AN_PDEC_EA_CHK:
        CMP.B #%100,D6
        BNE   END_AN_PDEC_EA_CHK
        JSR   EA_ERR
END_AN_PDEC_EA_CHK:
        RTS      

* prints ea error to buffer if XXXX.W mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
ABS_WRD_EA_CHK:
        CMP.B #%111,D6
        BNE   END_ABS_WRD_EA_CHK
        CMP.B #%000,d7
        BNE   END_ABS_WRD_EA_CHK
        JSR   EA_ERR
END_ABS_WRD_EA_CHK:
        RTS      

* prints ea error to buffer if XXXX.L mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
ABS_LNG_EA_CHK:
        CMP.B #%111,D6
        BNE   END_ABS_LNG_EA_CHK
        CMP.B #%001,d7
        BNE   END_ABS_LNG_EA_CHK
        JSR   EA_ERR
END_ABS_LNG_EA_CHK:
        RTS   

* prints ea error to buffer if #<data> mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
IM_DATA_EA_CHK:
        CMP.B #%111,D6
        BNE   END_IM_DATA_EA_CHK
        CMP.B #%100,d7
        BNE   END_IM_DATA_EA_CHK
        JSR   EA_ERR
END_IM_DATA_EA_CHK:
        RTS   

* prints ea error to buffer if (d16,An) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
DAN_EA_CHK:
        CMP.B #%101,D6
        BNE   END_DAN_EA_CHK
        JSR   EA_ERR
END_DAN_EA_CHK:
        RTS   

* prints ea error to buffer if (d8,An,Xn) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
DANXN_EA_CHK:
        CMP.B #%110,D6
        BNE   END_DANXN_EA_CHK
        JSR   EA_ERR
END_DANXN_EA_CHK:
        RTS

* prints ea error to buffer if (d16,PC) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
DPC_EA_CHK:
        CMP.B #%111,D6
        BNE   END_DPC_EA_CHK
        CMP.B #%010,d7
        BNE   END_DPC_EA_CHK
        JSR   EA_ERR
END_DPC_EA_CHK:
        RTS   

* prints ea error to buffer if (d8,PC,Xn) mode detected
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
DPCXN_EA_CHK:
        CMP.B #%111,D6
        BNE   END_DPCXN_EA_CHK
        CMP.B #%011,d7
        BNE   END_DPCXN_EA_CHK
        JSR   EA_ERR
END_DPCXN_EA_CHK:
        RTS      

* throws errors for register modes that do not exist for mode 7
* takes mode in on d6 and reg in on d7 sets EA_ERR_FLAG
MODE_7_EA_CHK:
        CMP.B #%111,D6
        BNE   END_MODE_7_EA_CHK
        CMP.B #%101,d7
        BEQ   M7_ERR
        CMP.B #%110,d7
        BEQ   M7_ERR
        CMP.B #%111,d7
        BEQ   M7_ERR
        BRA   END_MODE_7_EA_CHK
M7_ERR  JSR   EA_ERR
END_MODE_7_EA_CHK:
        RTS

***       UTILS     ****

ADD_IMMEDIATE_TO_BUF:
		MOVEM.L	D1/A1,-(SP)
		MOVE.B	INST_SZ,D1	* load instruction size
		CMPI.B	#BYTE,D1
		BEQ	IN_IM_W		* if byte goto word since behavior is the same
     	        CMPI.B  #WORD,D1
		BNE	CMP_IM_L	* if not equal to word branch compare to long
IN_IM_W:
		LEA	_IMD,A1		* print next mem word as imediate data to buffer
		JSR	WRITE_ASCII
                LEA	_ABS,A1		
		JSR	WRITE_ASCII
		JSR	NEXT_MEM_WORD_TO_BUF
		MOVEM.L (SP)+,D1/A1
		RTS
CMP_IM_L:
		CMPI.B  #LONG,D1
		LEA	_IMD,A1      * print next mem long as imediate data to buffer
		JSR	WRITE_ASCII
                LEA	_ABS,A1	
                JSR	WRITE_ASCII
		JSR     NEXT_MEM_LONG_TO_BUF
		MOVEM.L (SP)+,D1/A1
		RTS

* read next word of memory to str_buffer advancing current pointer
NEXT_MEM_WORD_TO_BUF:
		MOVEM.L	D1/D5,-(SP)
		ADDA.L	#2,A5	* advance pointer
		MOVE.W	(A5),D1	* load next word of memory
		MOVEQ.L #0,D5	* set hex length to word
		JSR 	WRITE_HEX_TO_ASCII
		MOVEM.L (SP)+,D1/D5
		RTS

* read next word of memory to D1 advancing current pointer
NEXT_MEM_WORD_TO_D1:
		ADDA.L	#2,A5	* advance pointer
		MOVE.W	(A5),D1	* load next word of memory
		RTS

* read next Long of memory to str_buffer advancing current pointer
NEXT_MEM_LONG_TO_BUF:
		MOVEM.L	D1/D5,-(SP)
		ADDA.L	#2,A5 * advance pointer
		MOVE.L	(A5),D1
		ADDA.L	#2,A5 * advance pointer again to account for long
		MOVEQ.L #32,D5	* set hex length to long
		JSR 	WRITE_HEX_TO_ASCII
		MOVEM.L (SP)+,D1/D5
		RTS

* prompts user for choice
* sets d6 to valid choice
GET_CHOICE: 
        MOVEM.L   D0/D1/A1,-(SP)
HC_INT_LP:
        JSR     RESET_BUF_PTR   * move a4 to start of string buffer
        LEA     CHOICE_PROMPT,A1
        JSR     WRITE_ASCII
        JSR     TERM_PNT_RST_BUF
        MOVE.B  #4,D0   * read a number from keyboard into d1
        TRAP    #15
CHOICE_1:
        CMPI    #DISSASEMBLE ,D1
        BEQ     CHOICE_DNE    
CHOICE_2:
        CMPI    #QUIT_PROG,D1
        BEQ     CHOICE_DNE    
CHOICE_ERR:
        LEA     INV_CHOICE,A1
        JSR     WRITE_ASCII
        JSR     TERM_PNT_RST_BUF
        JSR     WAIT_USR_INPUT
        BRA     HC_INT_LP
        
CHOICE_DNE:
        MOVE.B  D1,D6
        MOVEM.L   (SP)+,D0/D1/A1
        RTS               

* prompt user to press enter to continue
WAIT_USR_INPUT:            
        MOVEM.L   D0/D1/A1,-(SP)
        LEA     ENT_TO_CONT,A1  * load and print prompt
        JSR     PRINT_A1
        MOVEQ.L #5,D0   * read in a char from keyboard
        TRAP    #15
        MOVEM.L   (SP)+,D0/D1/A1
        RTS

LOAD_DATA_STR_INTO_BUF: * expects address to be in a5
        MOVEM.L   D1,-(SP)
        JSR     RESET_BUF_PTR
        MOVE.L  A5,D1
        MOVEQ   #32,D5   * set hex length to long for address
        JSR     WRITE_HEX_TO_ASCII * write memory address to buffer
        JSR     WRITE_TAB_A4    * wrtie a tab
        LEA     DATA_MSG,A1     * Load template for data
        JSR     WRITE_ASCII     * write 'DATA    $' to buffer
        MOVE.W  (A5),D1   * load address contents of memory to d1 for printing
        MOVEQ   #0,D5   * set hex length to word for memory contents
        JSR     WRITE_HEX_TO_ASCII * save to buffer
        MOVEM.L   (SP)+,D1
        RTS

DONE    MOVE.B  #9,D0       * Trap task 9 halt simulator
        TRAP    #15
        
* Converts ASCII string containing chars 0-9 and A-F uppercase to hexidecimal number
* returns result in D6
TO_HEX
        MOVEM.L   D0-D2/A1-A2,-(SP)   * save state of registers to be changed
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
END_H   MOVEM.L (SP)+,D0-D2/A1-A2
        RTS


*   input address to hexadecimal saves output at A1
IN_ADDR_TO_HEX:
        MOVEM.L   D6,-(SP)
        JSR     TO_HEX          * else convert to hex
        MOVE.L  D6,(A1)
        MOVEM.L   (SP)+,D6
        RTS

* check start and end addresses for errors
CHK_ST_E_ADRS: * sets D5 to 1 if an error has ocurred
        MOVEM.L   D1/D4,-(SP)
        MOVEQ   #0,D5       * clear error flag
        MOVE.L  ST_ADDR,D2  * load start address
        MOVE.L  E_ADDR,D3   * load end address
        
LEN_CHK:                    * check address length
        MOVE.B  ST_LEN,D1   * load start and end address lengths
        MOVE.B  E_LEN,D4
        
        CMPI.B  #8,D1       * check if start addr length is less than or equal to 8
        BLE     E_LEN_CHK   * check end address if no length error
        JSR     PLEN_ERR    * print length error message
        MOVEQ   #1,D5       * set error flag
        BRA     ODD_CHK     * skip end length check if start failed
E_LEN_CHK:
        CMPI.B  #8,D4
        BLE     ODD_CHK     * if no error skip to odd checking
        JSR     PLEN_ERR    * print length error message
        MOVEQ   #1,D5       * set error flag

ODD_CHK:                    * check if start address is odd
        BTST.L  #0,D2       * test start addres LSB to see if even
        BEQ     S_GT_E
        JSR     PODD_ERR    * print odd start address error
        MOVEQ   #1,D5       * set error flag
        
S_GT_E:                     * start address greater than or less than end
        CMP.L   D3,D2      * check if end is greater than or equal to start
        BLE     CHK_SEA_DONE   * skip to end if no error
        JSR     PS_GT_ERR   * print start greater than end error
        MOVEQ   #1,D5       * set error flag
      
CHK_SEA_DONE:
        MOVEM.L   (SP)+,D1/D4
        RTS             
        
*   print address length input error
PLEN_ERR:
        MOVEM.L   A1,-(SP) 
        LEA     ADR_LEN_ERR,A1   * load address input error message 
        JSR     PRINT_A1
        MOVEM.L   (SP)+,A1
        RTS         

PODD_ERR: * print start address odd error
        MOVEM.L   A1,-(SP) 
        LEA     ADR_ODD_ERR,A1
        JSR     PRINT_A1
        MOVEM.L   (SP)+,A1
        RTS

PS_GT_ERR: * print start address greater than end address error
        MOVEM.L   A1,-(SP) 
        LEA     ADR_S_GT_E,A1
        JSR     PRINT_A1
        MOVEM.L   (SP)+,A1
        RTS

 
PRINT_A1:
        MOVEM.L   D0,-(SP) * save register state
        MOVE.B  #14,D0   * print A1
        TRAP    #15
        MOVEM.L   (SP)+,D0  *  restore register state
        RTS

****************************************************
* Subroutines for printing and writing to and from
* the string buffer at A4
****************************************************        

* d5 is a flag for hex value length d5==32 long is used
* d5 == 8 byte is used
* d5 == 4 nibble
* any other value short is used        
WRITE_HEX_TO_ASCII: * write hex in d1 to a4 as ascii
        * may need to add case to handle sign extended shorts
        MOVEM.L   D2-D4,-(SP)
        MOVE.L  D1,D2   * copy input to working temp var
        CMPI.L  #32,D5           * if masked value is 0 there is no value in long portion of register for unsigned ints
        BEQ     h_long         * if 32 long
        CMPI.L  #8,D5          * if 8 byte 
        BEQ     h_byte
        CMPI.L  #4,D5          * if 4 nibble 
        BEQ     h_nibble
        BRA     h_short         * else short
h_long: * setup params for long processing
        MOVE.L  #$F0000000,D3   * init mask for isolating first long hex most significand digit
        MOVE.L  #28,D4          * init shift value for first long hex MSD
        BRA     h_a_loop
h_short: * setup params for short processing
        MOVE.L  #$0000F000,D3   * init mask for isolating first short hex most significand digit
        MOVE.L  #12,D4      * init shift value for first short hex MSD
        BRA     h_a_loop
h_byte: * setup params for byte processing
        MOVE.L  #$000000F0,D3   * init mask for isolating first byte hex most significand digit
        MOVE.L  #4,D4      * init shift value for first byte hex MSD    
        BRA     h_a_loop    
h_nibble: * setup params for nibble processing
        MOVE.L  #$0000000F,D3   * init mask for isolating first nibble hex most significand digit
        MOVE.L  #0,D4      * init shift value for first nibble hex MSD    

        
        
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
h_a_dne MOVEM.L   (SP)+,D2-D4
        RTS

WRITE_ASCII:    * copies null terminated string from A1 to A4 without null
        MOVEM.L   D1/A1,-(SP)
w_a_loop:
        MOVE.B  (A1)+,D1    * load value at A1
        BEQ     w_a_done    * if 0(null) is moved copy is done
        MOVE.B  D1,(A4)+    * else copy value to A4
        BRA     w_a_loop
w_a_done:
        MOVEM.L   (SP)+,D1/A1
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

* writes current string buffer pointer address to end_op_code_ptr
SET_END_OP_CODE_PTR:
        MOVE.L  A4,END_OP_CODE_PTR
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
        MOVEM.L   D0/A1,-(SP)
        LEA     STR_BUF,A1  * load string buffer
        MOVE    #14,D0       * print contents
        TRAP    #15
        MOVEM.L   (SP)+,D0/A1
        RTS

RESET_BUF_PTR:  * sets a4 to start of string buffer
        MOVEA   #STR_BUF,A4
        RTS        

****    VARS    ****
ST_ADDR DS.L    3   * allocate 3 longs for address ascii input needs 9 bytes to get 8 chars 
E_ADDR  DS.L    3   * and null terminator, allocating 12 bytes to account for this

END_OP_CODE_PTR:
        DCB.L   1,0 * pointer to end of opcode neumonic in the string buffer, used for ea errors

CURRENT_ADDR:
        DCB.L   1,0 * BACKUP FOR CURRENT ADDRESS POINTER

ST_LEN  DCB.B   1,0 * var to track start address length
E_LEN   DC.B    1,0 * var to track end address length
STR_BUF DCB.B   241,0  * buffer to hold 240 chars + null terminator. 3 80 char lines
INST_SZ	DCB.B	1,0		* used to store instuction size

******************
* IMPORTANT NOTE *
******************
* EA MODE and REGISTER variables *
* name src and dest is based off of move op-code so make sure you are looking
* at the right bits, name is mapped to bit range NOT ea name in manual
DEST_MODE: * always bits 6-8 inclusive in op-code
        DCB.B   1,0     * var for destination ea mode 
DEST_REG:  * always bits 9-11 inclusive in op-code
        DCB.B   1,0     * var to save destination register in
SRC_MODE:  * always bits 3-5 inclusive in op-code
        DCB.B   1,0     * var for source ea mode
SRC_REG:   * always bits 0-2 inclusive in op-code
        DCB.B   1,0     * var to save source register in  

EA_ERR_FLAG:  * bits 6-8 inclusive in op-code
        DCB.B   1,0     * var for ea error status

MOVEM_MASK:
        DCB.W   1,0     * var to hold bit mask for movem registers
         
****    CONST   ****
CR          EQU     $0D     * carraige return          
LF          EQU     $0A     * line feed
SPACE       EQU     $20     * ascii space
TAB         EQU     $09     * ascii tab character
DISSASEMBLE EQU     $01     * dissasemble choice number
QUIT_PROG   EQU     $02     * quit choice number
BYTE		EQU		%01
WORD		EQU		%11
LONG		EQU		%10

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
_NOT_B  DC.B    'NOT.B ',0
_NOT_W  DC.B    'NOT.W ',0
_NOT_L  DC.B    'NOT.L ',0
_NOP    DC.B    'NOP ',0
_RTS    DC.B    'RTS ',0
_MOVEM_W DC.B   'MOVEM.W ',0
_MOVEM_L DC.B   'MOVEM.L ',0
_MOVE_B DC.B    'MOVE.B ',0
_MOVE_L DC.B    'MOVE.L ',0
_MOVE_W DC.B    'MOVE.W ',0
_MOVEA_L DC.B   'MOVEA.L ',0
_MOVEA_W DC.B   'MOVEA.W ',0
_JSR    DC.B    'JSR ',0
_LEA    DC.B    'LEA ',0
_ADDQ_B DC.B    'ADDQ.B ',0
_ADDQ_W DC.B    'ADDQ.W ',0
_ADDQ_L DC.B    'ADDQ.L ',0
_BRA    DC.B    'BRA ',0
_BEQ    DC.B    'BEQ ',0
_BGT    DC.B    'BGT ',0
_BLE    DC.B    'BLE ',0
_MOVEQ  DC.B    'MOVEQ ',0
_DIVU   DC.B    'DIVU ',0
_OR     DC.B    'OR',0
_B   DC.B    '.B ',0
_W   DC.B    '.W ',0
_L   DC.B    '.L ',0
_SUB    DC.B    'SUB',0
_MULS   DC.B    'MULS.W ',0
_AND    DC.B    'AND',0
_ADD    DC.B    'ADD',0
_ADDA   DC.B    'ADDA',0
_ASL    DC.B    'ASL ',0
_ASR    DC.B    'ASR ',0
_LSL    DC.B    'LSL ',0
_LSR    DC.B    'LSR ',0
_ASL_B  DC.B    'ASL.B ',0
_ASL_W  DC.B    'ASL.W ',0
_ASL_L  DC.B    'ASL.L ',0
_ASR_B  DC.B    'ASR.B ',0
_ASR_W  DC.B    'ASR.W ',0
_ASR_L  DC.B    'ASR.L ',0
_LSL_B  DC.B    'LSL.B ',0
_LSL_W  DC.B    'LSL.W ',0
_LSL_L  DC.B    'LSL.L ',0
_LSR_B  DC.B    'LSR.B ',0
_LSR_W  DC.B    'LSR.W ',0
_LSR_L  DC.B    'LSR.L ',0

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
_SLASH          DC.B    '/',0

****    Numbers    ****
_ZERO   DC.B    '0',0
_ONE    DC.B    '1',0
_TWO    DC.B    '2',0
_THREE  DC.B    '3',0
_FOUR   DC.B    '4',0
_FIVE   DC.B    '5',0
_SIX    DC.B    '6',0
_SEVEN  DC.B    '7',0
_EIGHT  DC.B    '8',0
_COMMA  DC.B    ',',0

****    MODE CMP VALUES    ****
cDR             EQU     $0000
cAR             EQU     $0040
cIND_AR         EQU     $0080
cAR_POST        EQU     $00C0
cAR_PRE         EQU     $0100
cABS            EQU     $01C0

****    MESSAGES    ****

WELCOME     DC.B    '*********************************************',CR,LF
            DC.B    '* Welcome to EASY 68K Disasembler by Nibble *',CR,LF
            DC.B    '*********************************************',CR,LF,0
            
CHOICE_PROMPT:
            DC.B    'Enter a number to make a choice:',CR,LF
            DC.B    '1: Dissasemble an Address Range',CR,LF
            DC.B    '2: Exit Program',CR,LF,0
       
INV_CHOICE  DC.B    'ERROR: INVALID selection',CR,LF,0

ENT_TO_CONT DC.B    CR,LF,'Press enter to continue...',CR,LF,0

ST_A_MSG    DC.B    CR,LF,'Enter an address range in hexidecimal to be dissasembled',CR,LF * start address message
            DC.B    'Valid address chars: 0-1 A-F case insensitive',CR,LF  
            DC.B    'Enter start address:',0    
            
E_A_MSG     DC.B    'Enter end address:',0    * end address message

ADR_LEN_ERR DC.B    CR,LF,'ERROR INVALID ADDRESS: Input must be 0-8 hexidecimal digits long',CR,LF,0    * address input error message

ADR_ODD_ERR DC.B    CR,LF,'ERROR INVALID ADDRESS: Start address must be even',CR,LF,0  * odd input address error message
            
ADR_S_GT_E  DC.B    CR,LF,'ERROR INVALID ADDRESS: Start address must come before end address',CR,LF,0 * start greater than end address error msg

HEX_ERR     DC.B    CR,LF,'ERROR INVALID ADDRESS: Input must be 0-1 A-F case insensitive',CR,LF,0

EA_ERR_MSG  DC.B    'ERROR: INVALID EFFECTIVE ADDRESS',0      * error message for invalid eas

DATA_MSG    DC.B    'DATA   $',0

TEST_MSG    DC.B    'CONVERTED ADDRESS IS: ',0  * test message for printing start and end addresses
            
		    END     INIT        * last line of source



 


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
