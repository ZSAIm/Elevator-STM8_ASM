stm8/

	#include "Button.inc"
	segment 'rom'
	INTEL


; ---------------------------------
; name  : void Button_Init()
; params: 
;
; return: 
; =================================
; void Button_Init()
; {
; 	...
; }
; ---------------------------------
.Button_Init.w
	push cc
Button_Init_start:

Button_Init_Floor:
	;; PD7 - BTN_F1 - floor 8 down & floor 1 up
    bres BTN_F1
    bset PD_DDR, #7
    bset PD_CR1, #7
    bset PD_CR2, #7

    ;; PD1 - BTN_F2 - floor 2 down & up
    bres BTN_F2
    bset PD_DDR, #1
    bset PD_CR1, #1
    bset PD_CR2, #1

    ;; PD2 - BTN_F3 - floor 3 down & up
    bres BTN_F3
    bset PD_DDR, #2
    bset PD_CR1, #2
    bset PD_CR2, #2

    ;; PD3 - BTN_F4 - floor 4 down & up
    bres BTN_F4
    bset PD_DDR, #3
    bset PD_CR1, #3
    bset PD_CR2, #3

    ;; PD4 - BTN_F5 - floor 5 down & up
    bres BTN_F5
    bset PD_DDR, #4
    bset PD_CR1, #4
    bset PD_CR2, #4

    ;; PD5 - BTN_F6 - floor 6 down & up
    bres BTN_F6
    bset PD_DDR, #5
    bset PD_CR1, #5
    bset PD_CR2, #5

    ;; PD6 - BTN_F7 - floor 7 down & up
    bres BTN_F7
    bset PD_DDR, #6
    bset PD_CR1, #6
    bset PD_CR2, #6


    ;; PD0 - BTN_COL1 - floor button column 1
    ; bset BTN_COL1
    bres PD_DDR, #0
    bset PD_CR1, #0
    bres PD_CR2, #0

    ;; PC7 - BTN_COL2 - floor button column 2
    ; bset BTN_COL2
    bres PC_DDR, #7
    bset PC_CR1, #7
    bres PC_CR2, #7


Button_Init_KeyBoard:
	;; PC3 - KEYB_F12 - 1 & 2
    bres KEYB_F12
    bset PC_DDR, #3
    bset PC_CR1, #3
    bset PC_CR2, #3

    ;; PC4 - KEYB_F34 - 3 & 4
    bres KEYB_F34
    bset PC_DDR, #4
    bset PC_CR1, #4
    bset PC_CR2, #4

    ;; PC5 - KEYB_F56 - 5 & 6
    bres KEYB_F56
    bset PC_DDR, #5
    bset PC_CR1, #5
    bset PC_CR2, #5

    ;; PC6 - KEYB_F78 - 7 & 8
    bres KEYB_F78
    bset PC_DDR, #6
    bset PC_CR1, #6
    bset PC_CR2, #6

    ;; PA1 - KEYB_CONTROL - open & close
    bres KEYB_CONTROL
    bset PA_DDR, #1
    bset PA_CR1, #1
    bset PA_CR2, #1

    ;; PC1 - KEYB_COL1 - elevator keyboard column 1
    ; bset KEYB_COL1
    bres PC_DDR, #1
    bres PC_CR1, #1
    bres PC_CR2, #1

    ;; PC2 - KEYB_COL2 - elevator keyboard column 2
    ; bset KEYB_COL2
    bres PC_DDR, #2
    bres PC_CR1, #2
    bres PC_CR2, #2

Button_Init_interrupt:
	sim
	; PA2 INPUT INTERRUPT

	bres PA_DDR, #2
	bres PA_CR1, #2
	bres PA_CR2, #2
    
    
    ld A, EXTI_CR1
    and A, #11111100B
    or A, #00000011B
    ld EXTI_CR1, A
    
    ld A, ITC_SPR1
    and A, #00111111B
    ; and A, #00111111B
    or A, #01000000B
    ld ITC_SPR1, A
    
    bset PA_CR2, #2

    rim


Button_Init_exit:
	pop cc
	ret


; =================================
;name   : Button_Interrupt_Handler()
; params: 
;
; return: 
; =================================
.Button_Interrupt_Handler.L
    INTERRUPT Button_Interrupt_Handler
Button_Interrupt_Handler_start:
    bres PA_CR2, #2
    call CheckButtonDelay
    call CheckButtonDelay
	call CheckKeyboard
	cp A, #True
	jreq Button_Interrupt_Handler_launch
	call CheckFloorButton
Button_Interrupt_Handler_launch:
	ld A, B_STATUS
	cp A, #STATUS_IDLE
	jrne Button_Interrupt_Handler_exit
	call GoCurrentTarget
    jra Button_Interrupt_Handler_exit

    
    
Button_Interrupt_Handler_exit:
    call LED_Refresh
    bset PA_CR2, #2
    iret






; ---------------------------------
; name  : A CheckKeyboard()
; params: 
;
; return: A: True if keyboard button on, else False
; =================================
; A CheckKeyboard()
; {
; 	...
; }
; ---------------------------------
.CheckKeyboard.w
	push cc
CheckKeyboard_start:
	ld A, #True
	btjf KEYB_COL1,CheckKeyboard_COL1
	btjf KEYB_COL2,CheckKeyboard_COL2
	ld A, #False
	jra CheckKeyboard_exit
CheckKeyboard_COL1:
	call HandleKeyboard_COL1
	jra CheckKeyboard_exit
CheckKeyboard_COL2:
	call HandleKeyboard_COL2

CheckKeyboard_exit:
	call ResetKeyboardPin
	
	pop cc
	ret




; ---------------------------------
; name  : A CheckFloorButton()
; params: 
;
; return: True if floor button on, else False
; =================================
; A CheckFloorButton()
; {
; 	...
; }
; ---------------------------------
.CheckFloorButton.w
	push cc
CheckFloorButton_start:
	ld A, #True
	btjf BTN_COL1,CheckFloorButton_COL1
	btjf BTN_COL2,CheckFloorButton_COL2
	ld A, #False
	jra CheckFloorButton_exit
CheckFloorButton_COL1:
	call HandleFloorButton_COL1

	jra CheckFloorButton_exit
CheckFloorButton_COL2:
	call HandleFloorButton_COL2

CheckFloorButton_exit:
	call ResetFloorButtonPin

	pop cc
	ret


; ---------------------------------
; name  : void ResetFloorButtonPin()
; params: 
;
; return: 
; =================================
; void ResetFloorButtonPin()
; {
; 	...
; }
; ---------------------------------
ResetFloorButtonPin.w
	push cc
ResetFloorButtonPin_start:
	mov PD_ODR, #0
ResetFloorButtonPin_exit:
	pop cc
	ret



; ---------------------------------
; name  : void ResetKeyboardPin()
; params: 
;
; return: 
; =================================
; void ResetKeyboardPin()
; {
; 	...
; }
; ---------------------------------
ResetKeyboardPin.w
	push cc
ResetKeyboardPin_start:
	mov PC_ODR, #0
    bres KEYB_CONTROL
ResetKeyboardPin_exit:
	pop cc
	ret



; ---------------------------------
; name  : void HandleKeyboard_COL1()
; params: 
;
; return: 
; =================================
; void HandleKeyboard_COL1()
; {
; 	...
; }
; ---------------------------------
HandleKeyboard_COL1.w
	push cc
	push A
	pushw X
HandleKeyboard_COL1_start:
HandleKeyboard_COL1_OPEN:
	bset KEYB_CONTROL
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL1,HandleKeyboard_COL1_F1
	; nop
	call KeyboardOpen
	jra HandleKeyboard_COL1_exit
HandleKeyboard_COL1_F1:
	bset KEYB_F12
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL1,HandleKeyboard_COL1_F3
	ldw X, #1
	jra HandleKeyboard_COL1_put_exit
HandleKeyboard_COL1_F3:
	bset KEYB_F34
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL1,HandleKeyboard_COL1_F5
	ldw X, #3
	jra HandleKeyboard_COL1_put_exit
HandleKeyboard_COL1_F5:
	bset KEYB_F56
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL1,HandleKeyboard_COL1_F7
	ldw X, #5
	jra HandleKeyboard_COL1_put_exit
HandleKeyboard_COL1_F7:
	bset KEYB_F78
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL1,HandleKeyboard_COL1_exit
	ldw X, #7
	; jra HandleKeyboard_COL1_exit
HandleKeyboard_COL1_put_exit:
	call PutTargetFloor
	; call SetTempTarget
HandleKeyboard_COL1_exit:
	popw X
	pop A
	pop cc
	ret


; ---------------------------------
; name  : void HandleKeyboard_COL2()
; params: 
;
; return: 
; =================================
; void HandleKeyboard_COL2()
; {
; 	...
; }
; ---------------------------------
HandleKeyboard_COL2.w
	push cc
	push A
	pushw X
HandleKeyboard_COL2_start:
HandleKeyboard_COL2_CLOSE:
	bset KEYB_CONTROL
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL2,HandleKeyboard_COL2_F2
	; ldw X, #
	; nop
	call KeyboardClose
	jra HandleKeyboard_COL2_exit
HandleKeyboard_COL2_F2:
	bset KEYB_F12
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL2,HandleKeyboard_COL2_F4
	ldw X, #2
	jra HandleKeyboard_COL2_put_exit
HandleKeyboard_COL2_F4:
	bset KEYB_F34
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL2,HandleKeyboard_COL2_F6
	ldw X, #4
	jra HandleKeyboard_COL2_put_exit
HandleKeyboard_COL2_F6:
	bset KEYB_F56
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL2,HandleKeyboard_COL2_F8
	ldw X, #6
	jra HandleKeyboard_COL2_put_exit
HandleKeyboard_COL2_F8:
	bset KEYB_F78
	call CheckButtonDelay
    call CheckButtonDelay
	btjf KEYB_COL2,HandleKeyboard_COL2_exit
	ldw X, #8
HandleKeyboard_COL2_put_exit:
	call PutTargetFloor
	; call SetTempTarget
HandleKeyboard_COL2_exit:
	popw X
	pop A
	pop cc
	ret


; ---------------------------------
; name  : void KeyboardOpen()
; params: 
;
; return: 
; =================================
; void KeyboardOpen()
; {
; 	...
; }
; ---------------------------------
KeyboardOpen.w
	push cc
KeyboardOpen_start:
	ld A, B_STATUS
	cp A, #STATUS_OPEN
	jrne KeyboardOpen_exit
KeyboardOpen_reopen:
	call OpenDoor
KeyboardOpen_exit:
	pop cc
	ret


; ---------------------------------
; name  : void KeyboardClose()
; params: 
;
; return: 
; =================================
; void KeyboardClose()
; {
; 	...
; }
; ---------------------------------
KeyboardClose.w
	push cc
KeyboardClose_start:
	ld A, B_STATUS
	cp A, #STATUS_OPEN
	jrne KeyboardClose_exit
KeyboardClose_close:
	call CloseDoor
KeyboardClose_exit:
	pop cc
	ret



; ---------------------------------
; name  : void HandleFloorButton_COL1()	DOWN
; params: 
;
; return: 
; =================================
; void HandleFloorButton_COL1()
; {
; 	...
; }
; ---------------------------------
HandleFloorButton_COL1.w
	push cc
	push A
	pushw X
HandleFloorButton_COL1_start:
	ld A, #DIR_DOWN
HandleFloorButton_COL1_F8:
	bset BTN_F1
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F2
	ldw X, #8
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F2:
	bset BTN_F2
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F3
	ldw X, #2
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F3:
	bset BTN_F3
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F4
	ldw X, #3
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F4:
	bset BTN_F4
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F5
	ldw X, #4
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F5:
	bset BTN_F5
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F6
	ldw X, #5
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F6:
	bset BTN_F6
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_F7
	ldw X, #6
	jra HandleFloorButton_COL1_req_exit
HandleFloorButton_COL1_F7:
	bset BTN_F7
	call CheckButtonDelay
	btjf BTN_COL1,HandleFloorButton_COL1_exit
	ldw X, #7
HandleFloorButton_COL1_req_exit:
	call Request
HandleFloorButton_COL1_exit:
	popw X
	pop A
	pop cc
	ret


; ---------------------------------
; name  : void HandleFloorButton_COL2()	UP
; params: 
;
; return: 
; =================================
; void HandleFloorButton_COL2()
; {
; 	...
; }
; ---------------------------------
HandleFloorButton_COL2.w
	push cc
	push A
	pushw X
HandleFloorButton_COL2_start:
	ld A, #DIR_UP
HandleFloorButton_COL2_F1:
	bset BTN_F1
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F2
	ldw X, #1
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F2:
	bset BTN_F2
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F3
	ldw X, #2
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F3:
	bset BTN_F3
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F4
	ldw X, #3
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F4:
	bset BTN_F4
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F5
	ldw X, #4
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F5:
	bset BTN_F5
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F6
	ldw X, #5
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F6:
	bset BTN_F6
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_F7
	ldw X, #6
	jra HandleFloorButton_COL2_req_exit
HandleFloorButton_COL2_F7:
	bset BTN_F7
	call CheckButtonDelay
	btjf BTN_COL2,HandleFloorButton_COL2_exit
	ldw X, #7
HandleFloorButton_COL2_req_exit:
	call Request
HandleFloorButton_COL2_exit:
	popw X
	pop A
	pop cc
	ret



; ---------------------------------
; name  : void CheckButtonDelay()
; params: 
;
; return: 
; =================================
; void CheckButtonDelay()
; {
; 	...
; }
; ---------------------------------
CheckButtonDelay.w
	push cc
	pushw Y
CheckButtonDelay_start:
	
    ldw Y, #00FFH
    
CheckButtonDelay_loop:
    decw Y
    jrne CheckButtonDelay_loop
    
CheckButtonDelay_exit:
	popw Y
	pop cc
	ret




	end
