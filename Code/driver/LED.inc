


	#IFDEF __LED_ 1
	#ELSE
	#define __LED_ 1

	;;;;;;	FK = Floor & Keyboard indicator
	; LED_FK_SER = PB5
	#define LED_FK_SER PB_ODR,#5
	; LED_FK_SRCLK = PB4
	#define LED_FK_SRCLK PB_ODR,#4
	; LED_FK_RCLK = PB3
	#define LED_FK_RCLK PB_ODR,#3

	;;;;;;	CS = Door Counter & Door Status	
	; LED_FK_SER = PB0
	#define LED_CS_SER PB_ODR,#0
	; LED_FK_SRCLK = PB1
	#define LED_CS_SRCLK PB_ODR,#1
	; LED_FK_RCLK = PB2
	#define LED_CS_RCLK PB_ODR,#2

	;;;;; Elevator Direction
	; LED_DIR_UP = PE5
	#define LED_DIR_UP PE_ODR,#5
	; LED_DIR_DOWN = PF4
	#define LED_DIR_DOWN PF_ODR,#4


	#include "STM8S105K4.inc"
	#include "Variable.inc"

	#ENDIF



	extern CheckQueue.w






