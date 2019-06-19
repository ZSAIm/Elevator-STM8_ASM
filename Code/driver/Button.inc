

	#IFDEF __BUTTON_ 1
	#ELSE
	#define __BUTTON_ 1

	; button down interrupt
	#define KEY_INT PA_IDR,#2



	;;;;;;;;	Floor Button
	; floor 8 down & floor 1 up
	#define BTN_F1 PD_ODR,#7
	; floor 2 down & up
	#define BTN_F2 PD_ODR,#1
	; floor 3 down & up
	#define BTN_F3 PD_ODR,#2
	; floor 4 down & up
	#define BTN_F4 PD_ODR,#3
	; floor 5 down & up
	#define BTN_F5 PD_ODR,#4
	; floor 6 down & up
	#define BTN_F6 PD_ODR,#5
	; floor 7 down & up
	#define BTN_F7 PD_ODR,#6


	; floor button column 1
	#define BTN_COL1 PD_IDR,#0
	; floor button column 2
	#define BTN_COL2 PC_IDR,#7



	;;;;;;;; 	Elevator Keyboard
	; 1 & 2
	#define KEYB_F12 PC_ODR,#3
	; 3 & 4
	#define KEYB_F34 PC_ODR,#4
	; 5 & 6
	#define KEYB_F56 PC_ODR,#5
	; 7 & 8
	#define KEYB_F78 PC_ODR,#6
	; open & close
	#define KEYB_CONTROL PA_ODR,#1


	; elevator keyboard column 1
	#define KEYB_COL1 PC_IDR,#1
	; elevator keyboard column 2
	#define KEYB_COL2 PC_IDR,#2


	#include "STM8S105K4.inc"
	#include "Variable.inc"


	extern Request.w
	extern PutTargetFloor.w
	extern SetTempTarget.w
	extern LED_Refresh.w

	extern OpenDoor.w
	extern CloseDoor.w

	extern GoCurrentTarget.w

	#ENDIF




















