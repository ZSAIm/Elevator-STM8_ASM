
	#IFDEF __REQUEST_ 1
	#ELSE
	#define __REQUEST_ 1
    #include "Variable.inc"

    #ENDIF

    ; void PutNewTarget(const A opa_type, const X floor){}
    extern PutNewTarget.w

    ; A CheckQueue(const X target_floor){}
    extern CheckQueue.w

    extern IsQueueFull.w
    extern IsQueueEmpty.w

    ; X IncRotatePointer(X pointer)
    extern IncRotatePointer.w
    ; X DecRotatePointer(X pointer)
    extern DecRotatePointer


    extern GetNextTarget.w

    
    extern GoUp.w
    extern GoDown.w
    extern GoIdle.w
    extern OpenDoor.w
    extern CloseDoor.w

    extern LED_Refresh.w
