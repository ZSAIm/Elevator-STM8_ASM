stm8/
	
	#include "Timer.inc"
	
	segment 'rom'
	INTEL


; ---------------------------------
; name  : void Timer3Init()
; params: 
;
; return: 
; =================================
; void Timer3Init()
; {
; 	...
; }
; ---------------------------------
.Timer3Init.w
	push cc
	push A
TimerInit_start:
	sim
    ; 16Mhz / 2^8 = 62500hz
    ; 8Mhz / 2^7 = 62500hz
    mov TIM3_PSCR, #7
    ; enable TIM3 - Peripheral clock gating
    ; bset CLK_PCKENR1, #6

    
    ; 62500hz / 62500 = 1hz => 1s
    ; 62500 = 0xF424

    mov TIM3_ARRH, #0F4H
    mov TIM3_ARRL, #024H

    ; TIMx_ARR register is not buffered througha preload register. It can be written directly
    ; bres TIM3_CR1, #7
    ; bset TIM3_CR1, #0
    mov TIM3_CR1, #04

    ; Clear TIM3 Counter
    mov TIM3_CNTRH, #00H
    mov TIM3_CNTRL, #00H

    bset TIM3_EGR, #0
    bres TIM3_SR1, #0

    ; enable Update interrupt
    bset TIM3_IER, #0
    bset TIM3_CR1, #0
    
    ld A, ITC_SPR4
    and A, #00111111B
    ; and A, #01111111B
    or A, #01000000B
    ld ITC_SPR4, A


    rim
    ; bset TIM3_IER, #0
TimerInit_exit:
	pop A
	pop cc
	ret




; =================================
;name   : Timer3_Interrupt_Handler()
; params: 
;
; return: 
; =================================
.Timer3_Interrupt_Handler.L
    INTERRUPT Timer3_Interrupt_Handler
Timer3_Interrupt_Handler_start:
    bres TIM3_SR1, #0
	inc B_TIMER3_INT_COUNTER
	call [W_TIMER3_HANDLER.w]
	call LED_Refresh
Timer3_Interrupt_Handler_exit:
    iret



; ---------------------------------
; name  : void StopTimer3Interrupt()
; params: 
;
; return: 
; =================================
; void StopTimer3Interrupt()
; {
; 	...
; }
; ---------------------------------
.StopTimer3Interrupt.w
	push cc
StopTimer3Interrupt_start:
	bres TIM3_IER, #0
StopTimer3Interrupt_exit:
	pop cc
	ret






; ; ---------------------------------
; ; name  : void SetTimer3Interval(const A second)
; ; params: A: interval (unit: second)
; ;
; ; return: 
; ; =================================
; ; void SetTimer3Interval(const A second)
; ; {
; ; 	...
; ; }
; ; ---------------------------------
; .SetTimer3Interval.w
; 	push cc
; 	push A
; SetTimer3Interval_start:
	

; SetTimer3Interval_exit:
; 	push A
; 	push cc
; 	ret


; ---------------------------------
; name  : void SetTimer3Handler(const X handler_pointer)
; params: X: Handler pointer => (var W_TIMER3_HANDLER)
;
; return: 
; =================================
; void SetTimer3Handler(const X handler_pointer)
; {
; 	...
; }
; ---------------------------------
.SetTimer3Handler.w
	push cc
SetTimer3Handler_start:
	ldw W_TIMER3_HANDLER, X
	mov B_TIMER3_INT_COUNTER, #0
	call ReloadTimer3
	bset TIM3_IER, #0
SetTimer3Handler_exit:
	pop cc
	ret




; ---------------------------------
; name  : void ReloadTimer3()
; params: 
;
; return: 
; =================================
; void ReloadTimer3()
; {
; 	...
; }
; ---------------------------------
.ReloadTimer3.w
	push cc
ReloadTimer3_start:
    ; Clear TIM3 Counter
    mov TIM3_CNTRH, #00H
    mov TIM3_CNTRL, #00H
ReloadTimer3_exit:
	pop cc
	ret














	end


