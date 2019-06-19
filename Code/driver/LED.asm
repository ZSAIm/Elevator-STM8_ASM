stm8/

	#include "LED.inc"

	segment 'rom'
	INTEL


; ---------------------------------
; name  : void LED_Driver_Init()
; params: 
;
; return: 
; =================================
; void LED_Driver_Init()
; {
; 	...
; }
; ---------------------------------
.LED_Driver_Init.w
	push cc
LED_Driver_Init_start:

LED_Driver_Init_Floor_Keyboard:
	;; PB3 - 74HC595(RCLK)
    bset LED_FK_RCLK
    bset PB_DDR, #3
    bset PB_CR1, #3
    bset PB_CR2, #3
    
    ;; PB4 - 74HC595(SRCLK)
    bset LED_FK_SRCLK
    bset PB_DDR, #4
    bset PB_CR1, #4
    bset PB_CR2, #4

    ;; PB5 - 74HC595(SER)
    bset LED_FK_SER
    bset PB_DDR, #5
    bset PB_CR1, #5
    bset PB_CR2, #5
    
    
LED_Driver_Init_Counter_Status:
    ;; PB2 - 74HC595(RCLK)
    bset LED_CS_RCLK
    bset PB_DDR, #2
    bset PB_CR1, #2
    bset PB_CR2, #2
    
    ;; PB1 - 74HC595(SRCLK)
    bset LED_CS_SRCLK
    bset PB_DDR, #1
    bset PB_CR1, #1
    bset PB_CR2, #1

    ;; PB0 - 74HC595(SER)
    bset LED_CS_SER
    bset PB_DDR, #0
    bset PB_CR1, #0
    bset PB_CR2, #0

LED_Driver_Init_Direction:
    ;; PE5 - LED_DIR_UP
    bres LED_DIR_UP
    bset PE_DDR, #5
    bset PE_CR1, #5
    bset PE_CR2, #5

    ;; PF4 - LED_DIR_DOWN
    bres LED_DIR_DOWN
    bset PF_DDR, #4
    bset PF_CR1, #4
    bset PF_CR2, #4



LED_Driver_Init_exit:
	pop cc
	ret





; ---------------------------------
; name  : void LED_Refresh()
; params: 
;
; return: 
; =================================
; void LED_Refresh()
; {
;   ...
; }
; ---------------------------------
.LED_Refresh.w
    push cc
    push A
    pushw X
LED_Refresh_start:

LED_Refresh_FK:
    call GetTargetsOneHot_Reverse
    ld XH, A

    ld A, B_FLOOR
    call Floor2OneHot_Reverse
    ld XL, A
    call SendData2FK
LED_Refresh_CS:
    call GetMiscOneHot
    ld XH, A

    call GetDownCount
    ;cp A, #0
    ;jreq LED_Refresh_CS_Count
    ;dec A
LED_Refresh_CS_Count:
    call GetDpyCode
    ld XL, A
    call SendData2CS
LED_Refresh_exit:
    popw X
    pop A
    pop cc
    ret



; ---------------------------------
; name  : A GetDownCount()
; params: 
;
; return: A: down counter
; =================================
; void GetDownCount()
; {
;   ...
; }
; ---------------------------------
GetDownCount.w
    push cc
GetDownCount_start:
    ld A, B_STATUS
    cp A, #STATUS_CLOSE
    jreq GetDownCount_close
    cp A, #STATUS_OPEN
    jreq GetDownCount_open
    cp A, #STATUS_MOV
    jreq GetDownCount_moving
    jra GetDownCount_Idle
GetDownCount_close:
    clr A
    jra GetDownCount_exit
GetDownCount_Idle:
    ld A, #10H
    jra GetDownCount_exit
GetDownCount_moving:
    ld A, #MOVING_TIME    
    jra GetDownCount_before_exit
GetDownCount_open:
    ld A, #OPEN_TIME
GetDownCount_before_exit:
    sub A, B_TIMER3_INT_COUNTER
GetDownCount_exit:
    pop cc
    ret



; ---------------------------------
; name  : A GetMiscOneHot()
; params: 
;
; return: A: misc one hot
; =================================
; void GetMiscOneHot()
; {
;   ...
; }
; ---------------------------------
GetMiscOneHot.w
    push cc
GetMiscOneHot_start:
    push #0

    ld A, B_STATUS
    cp A, #STATUS_IDLE
    jrne GetDownCount_LED_moving
GetDownCount_LED_idle:
    ld A, B_FLOOR
    cp A, #1
    jrne GetDownCount_LED_down
    jra GetDownCount_LED_door
GetDownCount_LED_moving:
    ld A, B_DIRECTION
    cp A, #DIR_DOWN
    jreq GetDownCount_LED_down
GetDownCount_LED_up:
    pop A
    or A, #10000000B
    push A
    jra GetDownCount_LED_door
GetDownCount_LED_down:
    pop A
    or A, #01000000B
    push A
GetDownCount_LED_door:
    ld A, B_STATUS
    cp A, #STATUS_OPEN
    jrne GetDownCount_misc_end
    pop A
    or A, #00100000B
    push A
GetDownCount_misc_end:
    pop A
GetMiscOneHot_exit:
    pop cc
    ret



; ---------------------------------
; name  : A GetDpyCode(A digital)
; params: A: digital              => 0 ~ 9
;
; return: A: display map
; =================================
; A GetDpyCode(A digital)
; {
;   ...
; }
; ---------------------------------
DPYCODE dc.b 3fH,06H,5bH,4fH,66H,6dH,7dH,07H,7fH,6fH,77H,7cH,39H,5eH,79H,71H
        dc.b 80H

GetDpyCode.w
    push cc
    pushw X
GetDpyCode_start:
    clrw X
    ld XL, A
    ld A, (DPYCODE,X)
    
GetDpyCode_exit:
    popw X
    pop cc
    ret


; ---------------------------------
; name  : A Floor2OneHot_Reverse(A floor)
; params: A: floor              
;
; return: A: current floor to one hot
; =================================
; A Floor2OneHot_Reverse(A floor)
; {
;   ...
; }
; ---------------------------------
Floor2OneHot_Reverse.w
    push cc
    pushw X
Floor2OneHot_start:
    dec A
    jrne Floor2OneHot_NOTzero
Floor2OneHot_zero:
    ld A, #10000000B
    jra Floor2OneHot_exit
Floor2OneHot_NOTzero:
    clrw X
    ld XL, A
    ld A, #10000000B
Floor2OneHot_loop:
    srl A
    decw X
    jrne Floor2OneHot_loop

Floor2OneHot_exit:
    popw X
    pop cc
    ret


; ---------------------------------
; name  : A GetTargetsOneHot_Reverse()
; params:             
;
; return: A: all targets one hot, reverse order
; =================================
; A GetTargetsOneHot_Reverse()
; {
;   ...
; }
; ---------------------------------
GetTargetsOneHot_Reverse.w
    push cc
    pushw X
GetTargetsOneHot_start:
    push #0

    ld A, #MAX_FLOOR
    ldw X, #0
GetTargetsOneHot_loop:
    incw X
    push A
    call CheckQueue
    cp A, #False
    pop A
    jreq GetTargetsOneHot_NOTlight
GetTargetsOneHot_light:
    scf
    jra GetTargetsOneHot_concat
GetTargetsOneHot_NOTlight:
    rcf
GetTargetsOneHot_concat:
    rlc (1,SP)
    dec A
    jrne GetTargetsOneHot_loop

    pop A
GetTargetsOneHot_exit:
    popw X
    pop cc
    ret




; ---------------------------------
; name  : void SendData2FK(const X data)    < from high bit to low bit> - [ QH(HIGH) - QA(LOW) ]
; params: X: data                   => 16 bits
;
; return: 
; =================================
; void SendData2FK(const X data)
; {
; 	...
; }
; ---------------------------------
.SendData2FK.W
	push cc
	push A
    pushw X
SendData2FK_start:

    ld A, #16
SendData2FK_loop:
    call Delay_74HC595
    call Delay_74HC595
    sllw X
    jrnc SendData2FK_data_zero
SendData2FK_data_one:	
    bset LED_FK_SER
    jra SendData2FK_lock_data
SendData2FK_data_zero:
    bres LED_FK_SER
SendData2FK_lock_data:
    call Delay_74HC595
    call Delay_74HC595
    ;bset LED_FK_SRCLK
    bres LED_FK_SRCLK
    call Delay_74HC595
    call Delay_74HC595
    ;bres LED_FK_SRCLK
    bset LED_FK_SRCLK
    call Delay_74HC595

    dec A
    jrne SendData2FK_loop
    ;bset LED_FK_RCLK
    call Delay_74HC595
    call Delay_74HC595
SendData2FK_activate_data:
    call Delay_74HC595
    
    bres LED_FK_RCLK    ; inverter
    call Delay_74HC595
    ;bres LED_FK_RCLK
    call Delay_74HC595
    call Delay_74HC595
    bset LED_FK_RCLK    ; inverter
    call Delay_74HC595
   
SendData2FK_exit:
    popw X
    pop A
    pop cc
    ret





; ---------------------------------
; name  : void SendData2CS(const X data)    < from high bit to low bit>
; params: X: data                   => 16 bits
;
; return: 
; =================================
; void SendData2CS(const X data)
; {
;   ...
; }
; ---------------------------------
.SendData2CS.W
    push cc
    push A
    pushw X
SendData2CS_start:

    ld A, #16
SendData2CS_loop:
    call Delay_74HC595
    call Delay_74HC595
    sllw X
    jrnc SendData2CS_data_zero
SendData2CS_data_one:   
    bset LED_CS_SER
    jra SendData2CS_lock_data
SendData2CS_data_zero:
    bres LED_CS_SER
SendData2CS_lock_data:
    ;bset LED_CS_SRCKL
    call Delay_74HC595
    call Delay_74HC595
    call Delay_74HC595
    bres LED_CS_SRCLK
    call Delay_74HC595
    call Delay_74HC595
    ;bres LED_CS_SRCKL
    bset LED_CS_SRCLK
    
    dec A
    jrne SendData2CS_loop
    ;bset LED_CS_RCLK
    call Delay_74HC595
    call Delay_74HC595
SendData2CS_activate_data:

    bres LED_CS_RCLK    ; inverter
    call Delay_74HC595
    call Delay_74HC595
    ;bres LED_CS_RCLK
    call Delay_74HC595
    bset LED_CS_RCLK    ; inverter
    call Delay_74HC595
   
SendData2CS_exit:
    popw X
    pop A
    pop cc
    ret



;***********************************************************
;name   : Delay_74HC595()
;fun    : 
;params : 
;         IN  : NULL
;         OUT : NULL
;***********************************************************
Delay_74HC595.W
    pushw Y
    ldw Y, #011H
    
Delay_74HC595_loop:
    decw Y
    jrne Delay_74HC595_loop
    popw Y

    ret











	end


