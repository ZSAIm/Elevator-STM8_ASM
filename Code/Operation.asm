stm8/

    #include "Operation.inc"
    segment 'rom'

    INTEL



; ---------------------------------
; name  : void OperationInit()
; params: 
;
; return: 
; =================================
; void OperationInit()
; {
; 	...
; }
; ---------------------------------
.OperationInit.w
	push cc
	; push A
	pushw X
OperationInit_start:
	mov B_FLOOR, #1
	mov B_STATUS, #STATUS_IDLE
	mov B_DIRECTION, #DIR_NULL

	ldw X, #TARGET_QUEUE_BOTTOM
	ldw W_CUR_TARGET_PTR, X
	ldw W_NEW_PTR, X

	ldw X, #GoIdle
	ldw W_TIMER3_HANDLER, X

	mov B_TIMER3_INT_COUNTER, #0

OperationInit_exit:
	popw X
	; pop A
	pop cc 
    ret












; ---------------------------------
; name  : void GoUp()
; params: 
;
; return: 
; =================================
; void GoUp()
; {
; 	...
; }
; ---------------------------------
.GoUp.w
	push cc
	pushw X
GoUp_start:
	ldw X, #GoUp_Handler
	call SetTimer3Handler
	mov B_STATUS, #STATUS_MOV
GoUp_exit:
	popw X
	pop cc 
    ret
    
    

; ---------------------------------
; name  : void GoDown()
; params: 
;
; return: 
; =================================
; void GoDown()
; {
; 	...
; }
; ---------------------------------
.GoDown.w
	push cc
	pushw X
GoDown_start:
	ldw X, #GoDown_Handler
	call SetTimer3Handler
	mov B_STATUS, #STATUS_MOV
GoDown_exit:
	popw X
	pop cc 
    ret



; ---------------------------------
; name  : void GoIdle()
; params: 
;
; return: 
; =================================
; void GoIdle()
; {
; 	...
; }
; ---------------------------------
.GoIdle.w
	push cc
	pushw X
GoIdle_start:
	ldw X, #GoIdle_Handler
	call SetTimer3Handler
	; call StopTimer3Interrupt
	mov B_STATUS, #STATUS_IDLE
GoIdle_exit:
	popw X
	pop cc
    ret







; ---------------------------------
; name  : void OpenDoor()
; params: 
;
; return: 
; =================================
; void OpenDoor()
; {
; 	...
; }
; ---------------------------------
.OpenDoor.w
	push cc
	pushw X
OpenDoor_start:
	ldw X, #OpenDoor_Handler
	call SetTimer3Handler
	mov B_STATUS, #STATUS_OPEN
OpenDoor_exit:
	popw X
	pop cc 
    ret



; ---------------------------------
; name  : void CloseDoor()
; params: 
;
; return: 
; =================================
; void CloseDoor()
; {
; 	...
; }
; ---------------------------------
.CloseDoor.w
	push cc
	pushw X
CloseDoor_start:
	ldw X, #CloseDoor_Handler
	call SetTimer3Handler
	mov B_STATUS, #STATUS_CLOSE
CloseDoor_exit:
	popw X
	pop cc 
    ret








; ---------------------------------
; name  : void ReachNextFloor_Handler()
; params: 
;
; return: 
; =================================
; void ReachNextFloor_Handler()
; {
; 	...
; }
; ---------------------------------
ReachNextFloor_Handler.w
	push cc
	push A
	pushw X
ReachNextFloor_start:

ReachNextFloor_is_target:
	call CheckCurrentFloorTarget
	cp A, #True
	jreq ReachNextFloor_reach
ReachNextFloor_check_floor:
	call CheckCurrentFloorReq
	cp A, #True
	jreq ReachNextFloor_reach_req
	jra ReachNextFloor_keep_going

ReachNextFloor_reach:
	call CheckCurrentFloorReq
ReachNextFloor_reach_req:
    call GetNextTarget
    cp A, #INVALID_TARGET
    jrne ReachNextFloor_open_door
ReachNextFloor_clear_cur_req:
	ld A, B_FLOOR
    dec A
	clrw X
	ld XL, A
	clr (FLOOR_BOTTOM,X)
ReachNextFloor_open_door:
    call OpenDoor
    jra ReachNextFloor_exit

ReachNextFloor_keep_going:
	call GoCurrentTarget

ReachNextFloor_exit:
	popw X
	pop A
	pop cc
	ret 




; ---------------------------------
; name  : void GoUp_Handler()
; params: 
;
; return: 
; =================================
; void GoUp_Handler()
; {
; 	...
; }
; ---------------------------------
GoUp_Handler.w
	push cc
	push A
GoUp_Handler_start:
	ld A, B_TIMER3_INT_COUNTER
	cp A, #MOVING_TIME
	jrmi GoUp_Handler_exit

	inc B_FLOOR

	call ReachNextFloor_Handler
	; cp A, #False
	; jreq GoUp_Handler_exit
; GoUp_Handler_keep_going:
	; call GoUp

GoUp_Handler_exit:
	pop A
	pop cc 
    ret



; ---------------------------------
; name  : void GoDown_Handler()
; params: 
;
; return: 
; =================================
; void GoDown_Handler()
; {
; 	...
; }
; ---------------------------------
GoDown_Handler.w
	push cc
	push A
GoDown_Handler_start:
	ld A, B_TIMER3_INT_COUNTER
	cp A, #MOVING_TIME
	jrmi GoDown_Handler_exit

	dec B_FLOOR

	call ReachNextFloor_Handler
	; cp A, #False
	; jreq GoDown_Handler_exit
; GoDown_Handler_keep_going:
	; call GoDown
GoDown_Handler_exit:
	pop A
	pop cc 
    ret


; ---------------------------------
; name  : void GoIdle_Handler()
; params: 
;
; return: 
; =================================
; void GoIdle_Handler()
; {
; 	...
; }
; ---------------------------------
GoIdle_Handler.w
	push cc
	push A
	pushw X
GoIdle_Handler_start:
	call IsAllReqDone
	cp A, #True
	jreq GoIdle_Handler_go_to_floor_1
GoIdle_Handler_check_req:
	call GetNearFloorReq
	cp A, #INVALID_TARGET
	jreq GoIdle_Handler_go_to_floor_1
	clrw X
	ld XL, A
	call CheckLaunch
	; call PutNewTarget
	
GoIdle_Handler_go_to_floor_1:
	ld A, B_TIMER3_INT_COUNTER
	cp A, #MOVING_TIME
	jrmi GoIdle_Handler_exit
    clr B_TIMER3_INT_COUNTER
    
	dec B_FLOOR
	jrne GoIdle_Handler_check_floor
	inc B_FLOOR
GoIdle_Handler_check_floor:
	ld A, B_FLOOR
	; compare with floor 1
	cp A, #1
	jrne GoIdle_Handler_go_down
GoIdle_Handler_stop_timer:
	; call StopTimer3Interrupt
	; jra GoIdle_Handler_exit
GoIdle_Handler_go_down:
	

GoIdle_Handler_exit:
	popw X
	pop A
	pop cc 
    ret





; ---------------------------------
; name  : void OpenDoor_Handler()
; params: 
;
; return: 
; =================================
; void OpenDoor_Handler()
; {
; 	...
; }
; ---------------------------------
OpenDoor_Handler.w
	push cc
	push A
OpenDoor_Handler_start:
	ld A, B_TIMER3_INT_COUNTER
	cp A, #OPEN_TIME
	jrmi OpenDoor_Handler_exit

	call CloseDoor
OpenDoor_Handler_exit:
	pop A
	pop cc 
    ret


; ---------------------------------
; name  : void CloseDoor_Handler()
; params: 
;
; return: 
; =================================
; void CloseDoor_Handler()
; {
; 	...
; }
; ---------------------------------
CloseDoor_Handler.w
	push cc
	push A
	pushw X
	pushw Y
CloseDoor_Handler_start:

CloseDoor_Handler_if_reach_cur:
	call IsReached
	cp A, #True
	jrne CloseDoor_Handler_keep_moving
CloseDoor_Handler_check_if_direction:
	call IsNextTargetDirection
	cp A, #True
	jreq CloseDoor_Handler_same_direction
CloseDoor_Handler_diff_direction:
	call GetNextDirTargetPointer
	cpw X, #INVALID_TARGET
	jreq CloseDoor_Handler_no_more_same
	; make it be current target
	ldw Y, X
	ldw Y, (Y)
	ldw W_CUR_TARGET_PTR, Y
	; clear it 
	ldw X, #INVALID_TARGET
	ldw (Y), X
	jra CloseDoor_Handler_keep_moving
CloseDoor_Handler_no_more_same:
CloseDoor_Handler_same_direction:
	call GetNextTarget
	cp A, #INVALID_TARGET
	jreq CloseDoor_go_idle
	call GoNextTarget
	jra CloseDoor_Handler_keep_moving

CloseDoor_Handler_keep_moving:
	call GoCurrentTarget

	jra CloseDoor_Handler_exit

; CloseDoor_go_idle_determine:
; 	call IsAllReqDone
; 	cp A, #True
; 	jreq CloseDoor_go_idle
; 	call GetNearFloorReq
; 	cp A, #INVALID_TARGET
; 	jreq CloseDoor_go_idle
; 	clrw X
; 	ld XL, A
; 	call GoCurrentTarget
	
	; jra CloseDoor_Handler_exit
CloseDoor_go_idle:
	call GoIdle
    call GoNextTarget

CloseDoor_Handler_exit:
	popw Y
	popw X
	pop A
	pop cc 
    ret


















    end


