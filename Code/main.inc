

	#IFDEF __MAIN_ 1
	#ELSE

	#define __MAIN_ 1

	; init function
	extern HSIClockInit.w
	extern OperationInit.w
	extern LED_Driver_Init.w
    extern Button_Init.w
    extern Timer3Init.w

    ; 
    extern SendData2FK.w
    extern SendData2CS.w
    
    
    
    extern LED_Refresh.w

    ; interrupt handler
	extern Button_Interrupt_Handler.L
	extern Timer3_Interrupt_Handler.L

	#ENDIF










