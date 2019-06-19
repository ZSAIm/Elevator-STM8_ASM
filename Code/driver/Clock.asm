stm8/

	#include "STM8S105K4.inc"
	segment 'rom'
	INTEL

; ---------------------------------
; name  : void HSIClockInit()	- 16MHZ
; params: 
;
; return: 
; =================================
; void HSIClockInit()
; {
; 	...
; }
; ---------------------------------
.HSIClockInit.w
	push cc
	push A
HSIClockInit_start:

    ; => fHSI / 2 = 8Mhz
    ld A, CLK_CKDIVR
    and A, #11100111B
    or A, #00001000B
    ld CLK_CKDIVR, A

HSIClockInit_exit:
	pop A
	pop cc
	ret


















	end

