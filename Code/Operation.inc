

    #IFDEF __OPERATION_ 1
    
    #ELSE
    #define __OPERATION_ 1
    #include "Variable.inc"

    
    #ENDIF


    extern IsQueueEmpty.w

    ; void SetTimer3Handler(const X handler_pointer)
    extern SetTimer3Handler.w
    
    ; void ReloadTimer3()
    extern ReloadTimer3.w

    ; A CheckCurrentFloorReq()
    extern CheckCurrentFloorReq.w

    ; A IsReached()
    extern IsReached.w

    ; X GetNextTarget()
    extern GetNextTarget.w

    ; void StopTimer3Interrupt()
    extern StopTimer3Interrupt.w

    ; void GoNextTarget()
    extern GoNextTarget.w


    extern CheckLaunch.w

    extern IsAllReqDone.w

    ; extern IsTargetFloor.w

    ; extern PutAllTempTarget.w

    ; extern ClearTempTarget.w

    extern IsNextTargetDirection.w

    extern GetNextDirTargetPointer.w

    extern CheckCurrentFloorTarget.w

    extern GoCurrentTarget.w

    extern GetNearFloorReq.w

