stm8/
    
    #include "Variable.inc"
    
    segment 'ram0'
    
    BYTES
 
.BR01.b ds.b 1
.BR02.b ds.b 1
.BR03.b ds.b 1
.BR04.b ds.b 1
.BR05.b ds.b 1
.BR06.b ds.b 1
.BR07.b ds.b 1
.BR08.b ds.b 1
.BR09.b ds.b 1




.B_FLOOR.b ds.b 1       ; floor = {0 ~ 7}
.B_STATUS.b ds.b 1      ; {Moving=1, Idle=0, opened=2}
.B_DIRECTION.b ds.b 1	; direction: {DOWN=1, UP=2, NULL=0}


.W_CUR_TARGET_PTR.b ds.w 1

.W_NEW_PTR.b ds.w 1


.W_TIMER3_HANDLER.b ds.w 1	; timer3 handler pointer
.B_TIMER3_INT_COUNTER.b ds.b 1	; timer3 interrupt counter (second counter)



.TEMP_TARGET_FLOOR_BUTTOM.b

TEMP_TARGET_FLOOR.b ds.b MAX_FLOOR


.TEMP_TARGET_FLOOR_TOP.b ds.b 1


    segment 'ram1'
    WORDS






; 
.FLOOR_BOTTOM.w
; bytes
_FLOOR_.w ds.b MAX_FLOOR

.FLOOR_TOP.w
    
    

.TARGET_QUEUE_BOTTOM.w

; TARGET_QUEUE_TOP = 0x5FF



	end
