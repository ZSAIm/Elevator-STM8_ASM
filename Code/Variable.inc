
    #IFDEF __VARIABLE_ 1
    #ELSE
    
    #define MAX_FLOOR 8
    
    #define REQ_NULL 0
    #define REQ_DOWN 00000001B
    #define REQ_UP 00000010B
    #define REQ_UP_DOWN 0000011B
    
    #define False 0
    #define True 1
    

    #define TARGET_QUEUE_TOP 5FFH

    #define STATUS_MOV 1
    #define STATUS_IDLE 0
    #define STATUS_OPEN 2
    #define STATUS_CLOSE 3
    ; #define STATUS_DOWN 00000001B
    ; #define STATUS_UP 00000010B
    ; #define STATUS_STAY 0000011B

    #define DIR_NULL 00000000B
    #define DIR_DOWN 00000001B
    #define DIR_UP 00000010B

    #define INVALID_TARGET 0

    #include "STM8S105K4.inc"


    #define MOVING_TIME 2
    #define CLOSE_TIME 10
    #define OPEN_TIME 10
    ; #define BEEP_TIME 3


    #ENDIF
    

    extern B_FLOOR.b
    extern B_STATUS.b
    extern B_DIRECTION.b

    extern W_CUR_TARGET_PTR.b
    extern W_NEW_PTR.b

    extern FLOOR_TOP.w
    extern FLOOR_BOTTOM.w
    
    extern TARGET_QUEUE_BOTTOM.w


    extern TEMP_TARGET_FLOOR_BUTTOM.b
   	extern TEMP_TARGET_FLOOR_TOP.b

    
    
    extern W_TIMER3_HANDLER.b
    extern B_TIMER3_INT_COUNTER.b
