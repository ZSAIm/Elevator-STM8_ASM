stm8/

    #include "Request.inc"
    
    segment 'rom'

    INTEL


; ---------------------------------
; name  : void Request(const A opa_type, const X src_floor)
; params: A: operation type => {REQ_NULL, REQ_DOWN, REQ_UP, REQ_UP_DOWN}
;         X: source floor   => {floor=0~7}
;
; return: 
; =================================
; void Request(const A opa_type, const X src_floor)
; {
;	if(CheckQueue(A, X) == False){
; 		PutNewTarget()
;	}
;
;	
; }
; ---------------------------------
.Request.w
	push cc
	push A
	pushw X
Request_start:
	
	push A
	call IsQueueFull
	cp A, #True
	pop A
	jreq Request_exit

	; if(IsQueueFull() == False){
	; 	request_floor_addr = &bottom_floor + request_floor - 1
	; 	Y = request_floor_addr

	decw X
	pushw X
	ldw Y, #FLOOR_BOTTOM
	addw Y, (1,SP)
    popw X

    ; 	*request_floor_addr = opa_type | *request_floor_addr
    or A, (Y)
    ld (Y), A

    ld A, B_STATUS
    cp A, #STATUS_IDLE
    jrne Request_exit
Request_launch:
	popw X
	call CheckLaunch
	pushw X
Request_exit:
    popw X
    pop A
	pop cc
    ret


; ---------------------------------
; name  : void CheckLaunch(const X src_floor)
; params: X: request floor
;
; return: 
; =================================
; void CheckLaunch(const X src_floor)
; {	
; }
; ---------------------------------
.CheckLaunch.w
	push cc
	push A
	pushw Y
	pushw X
CheckLaunch_start:
	clrw Y
	ld A, B_FLOOR
	ld YL, A
	pushw Y
	cpw X, (1,SP)
	popw Y
	jrne CheckLaunch_direction
	call OpenDoor
	jra CheckLaunch_exit
CheckLaunch_direction:
	jrmi CheckLaunch_godown
CheckLaunch_goup:
	call GoUp
	mov B_DIRECTION, #DIR_UP
	jra CheckLaunch_putnew_exit
CheckLaunch_godown: 
	call GoDown
	mov B_DIRECTION, #DIR_DOWN
CheckLaunch_putnew_exit:
	popw X

	call PutNewTarget
	pushw X
CheckLaunch_exit:
	popw X
    popw Y
    pop A
	pop cc
    ret

; ---------------------------------
; name  : void GoCurrentTarget()
; params: X: request floor
;
; return: 
; =================================
; void GoCurrentTarget()
; {	
; }
; ---------------------------------
.GoCurrentTarget.w
	push cc
	push A
	pushw Y
	pushw X
GoCurrentTarget_start:
	ldw X, W_CUR_TARGET_PTR
    ld A, (X)
    cp A, #INVALID_TARGET
    jrne GoCurrentTarget_determine_direction
GoCurrentTarget_is_target_empty:
	call GetNextTarget
	cp A, #INVALID_TARGET
	jreq GoCurrentTarget_goidle_determin
	call GoNextTarget
GoCurrentTarget_determine_direction:
    clrw X
    ld XL, A

	clrw Y
	ld A, B_FLOOR
	ld YL, A
	pushw Y
	cpw X, (1,SP)
	popw Y
; 	; jrne GoCurrentTarget_direction
; 	; call OpenDoor
; 	; jra GoCurrentTarget_exit
; GoCurrentTarget_direction:
	jrmi GoCurrentTarget_godown
    jra GoCurrentTarget_goup
GoCurrentTarget_goidle_determin:
    call GoIdle
	mov B_DIRECTION, #DIR_NULL
    jra GoCurrentTarget_exit
GoCurrentTarget_goup:
	call GoUp
	mov B_DIRECTION, #DIR_UP
	jra GoCurrentTarget_exit
GoCurrentTarget_godown: 
	call GoDown
	mov B_DIRECTION, #DIR_DOWN
GoCurrentTarget_exit:
	popw X
    popw Y
    pop A
	pop cc
    ret


; ---------------------------------
; name  : void GoNextTarget()
; params: 
;
; return: 
; =================================
; void GoNextTarget()
; {	
; }
; ---------------------------------
.GoNextTarget.w
	push cc
	push A
	pushw X
GoNextTarget_start:
	
	ldw X, W_CUR_TARGET_PTR
	clr (X)
GoNextTarget_loop:
	call IncRotatePointer
    cpw X, W_NEW_PTR
    jreq GoNextTarget_inc_ptr
    ld A, (X)
    cp A, #INVALID_TARGET
    jreq GoNextTarget_loop
GoNextTarget_inc_ptr:
	ldw W_CUR_TARGET_PTR, X
GoNextTarget_exit:
    popw X
    pop A
	pop cc
    ret






; ; ---------------------------------
; ; name  : void PutAllTempTarget()
; ; params: 
; ;
; ; return: 
; ; =================================
; ; void PutAllTempTarget()
; ; {
; ; }
; ; ---------------------------------
; .PutAllTempTarget.w
; 	push cc
; 	push A
; 	pushw X
; PutAllTempTarget_start:
; 	ldw X, #MAX_FLOOR
	
; PutAllTempTarget_loop:
; 	decw X
;     jreq PutAllTempTarget_exit
; 	ld A, (TEMP_TARGET_FLOOR_BUTTOM,X)
; 	cp A, #True
; 	jrne PutAllTempTarget_next
; PutAllTempTarget_put:
; 	incw X
; 	call PutTargetFloor
; 	decw X
; PutAllTempTarget_next:
; 	jrne PutAllTempTarget_loop
; PutAllTempTarget_exit:
; 	popw X
; 	pop A
; 	pop cc
;     ret


; ; ---------------------------------
; ; name  : A CheckTempTarget(const X floor)
; ; params: 
; ;
; ; return: A
; ; =================================
; ; A CheckTempTarget()
; ; {
; ; }
; ; ---------------------------------
; .CheckTempTarget.w
; 	push cc
; 	pushw X
; CheckTempTarget_start:
	

; CheckTempTarget_True:

; CheckTempTarget_False:

; CheckTempTarget_exit:
; 	popw X
; 	pop cc
;     ret

; ; ---------------------------------
; ; name  : void SetTempTarget(const X floor)
; ; params: 
; ;
; ; return: 
; ; =================================
; ; void SetTempTarget(const X floor)
; ; {
; ; }
; ; ---------------------------------
; .SetTempTarget.w
; 	push cc
; 	push A
; PutAllTarget_start:
;     decw X
; 	; ld A, #TEMP_TARGET_FLOOR_BUTTOM
; 	ld A, #True
; 	ld (TEMP_TARGET_FLOOR_BUTTOM,X), A
;     incw X
; PutAllTarget_exit:
; 	pop A
; 	pop cc
;     ret


; ; ---------------------------------
; ; name  : void ClearTempTarget()
; ; params: 
; ;
; ; return: 
; ; =================================
; ; void ClearTempTarget()
; ; {
; ; }
; ; ---------------------------------
; .ClearTempTarget.w
; 	push cc
; 	pushw X
; ClearTempTarget_start:
; 	ldw X, #TEMP_TARGET_FLOOR_BUTTOM
; ClearTempTarget_loop:
; 	clr (X)
; 	incw X
; 	cpw X, #TEMP_TARGET_FLOOR_TOP
; 	jrne ClearTempTarget_loop
; ClearTempTarget_exit:
; 	popw X
; 	pop cc
;     ret






; ---------------------------------
; name  : void PutTargetFloor(const X target_floor)
; params: X: target_floor     => {floor=0~7}
;
; return: 
; =================================
; void PutTargetFloor(const A opa_type, const X floor)
; {
;	if(IsQueueFull() == False || IsQueueEmpty() == True){
;		PutNewTarget(x);
;	}
; }
; ---------------------------------
.PutTargetFloor.w
	push cc
PutTargetFloor_start:
	call IsQueueFull
	cp A, #True
	jreq PutTargetFloor_exit

	call IsQueueEmpty
	cp A, #True
	jreq PutTargetFloor_put

	; CheckQueue(X)
    call CheckQueue
    cp A, #True
    jreq PutTargetFloor_exit
PutTargetFloor_put:
	call PutNewTarget
PutTargetFloor_exit:
	pop cc
    ret




; ---------------------------------
; name  : A GetFloorReq(const X floor)
; params: X: floor 				=> {floor=0~MAX_FLOOR}
;
; return: A: request operation 	=> {REQ_NULL, REQ_DOWN, REQ_UP, REQ_UP_DOWN}
; =================================
; A GetFloorReq(const X floor)
; {
; 	request_floor_addr = &bottom_floor + request_floor - 1;
; 	return *request_floor_addr;
; }
; ---------------------------------
.GetFloorReq.w
	push cc
	pushw X
GetFloorReq_start:
	decw X
    ld A, (FLOOR_BOTTOM,X)
GetFloorReq_exit:
    popw X
	pop cc
    ret


; ---------------------------------	!!!! error prone !!!!! - < it may change floor request, clear when match >
; name  : A CheckCurrentFloorReq()
; params: 
;
; return: A: check if request of current floor matchs direction	=> {True, False}
; =================================
; A CheckCurrentFloorReq()
; {
; }
; --------------------------------- 
.CheckCurrentFloorReq.w
	push cc
	pushw X
CheckCurrentFloorReq_start:
	ld A, B_FLOOR
	clrw X
	ld XL, A
	call GetFloorReq
	push A
	and A, B_DIRECTION
	pop A
	jreq CheckCurrentFloorReq_False
CheckCurrentFloorReq_True:
	push A
	ld A, B_DIRECTION
	xor A, #0FFH
	and A, (1,SP)
    decw X
	ld (FLOOR_BOTTOM,X), A
    pop A
	ld A, #True
	jra CheckCurrentFloorReq_exit
CheckCurrentFloorReq_False:
	ld A, #False
CheckCurrentFloorReq_exit:
    popw X
	pop cc
    ret


; ---------------------------------	!!!! error prone !!!!! - < it may change floor request, clear when match >
; name  : A CheckCurrentFloorTarget()
; params: 
;
; return: A: check if there are targets matching current direction. mask when match => {True, False}
; =================================
; A CheckCurrentFloorTarget()
; {
; }
; --------------------------------- 
.CheckCurrentFloorTarget.w
	push cc
	pushw X
CheckCurrentFloorTarget_start:
	ldw X, W_CUR_TARGET_PTR
	ld A, B_FLOOR
	cp A, (X)
	jreq CheckCurrentFloorTarget_True_only
CheckCurrentFloorTarget_loop:
	cp A, (X)
	jreq CheckCurrentFloorTarget_True
	call IncRotatePointer
	cpw X, W_NEW_PTR
	jrne CheckCurrentFloorTarget_loop
CheckCurrentFloorTarget_False:
	ld A, #False
	jra CheckCurrentFloorTarget_exit
CheckCurrentFloorTarget_True:
	ld A, #INVALID_TARGET
	ld (X), A
CheckCurrentFloorTarget_True_only:
	ld A, #True
CheckCurrentFloorTarget_exit:
    popw X
	pop cc
    ret


; ---------------------------------
; name  : A IsNextTargetDirection()
; params: 
;
; return: A: check if next target floor is in current direction => {True, False}
; =================================
; A IsNextTargetDirection()
; {
; }
; --------------------------------- 
.IsNextTargetDirection.w
	push cc
	pushw X
IsNextTargetDirection_start:

	call GetNextTarget
	clrw X
	ld XL, A
	; X <= Next Target

	ld A, [W_CUR_TARGET_PTR.w]
	push A
	push #00

	ld A, B_DIRECTION
	cp A, #DIR_UP
	jreq IsNextTargetDirection_up
IsNextTargetDirection_down:
	cpw X, (1,SP)
	jrmi IsNextTargetDirection_True
IsNextTargetDirection_up:
	cpw X, (1,SP)
	jrmi IsNextTargetDirection_False
	
IsNextTargetDirection_True:
	ld A, #True
	jra IsNextTargetDirection_exit
IsNextTargetDirection_False:
	ld A, #False
IsNextTargetDirection_exit:
	popw X

    popw X
	pop cc
    ret




; ---------------------------------
; name  : X GetNextDirTargetPointer()
; params: 
;
; return: X: next same direction target pointer
; =================================
; X GetNextDirTargetPointer()
; {
; }
; --------------------------------- 
.GetNextDirTargetPointer.w
	push cc
	push A
GetNextDirTargetPointer_start:
	; call GetNextTarget
	; X <= Next Target
	ld A, B_FLOOR
	push A
	push #00

	ldw X, W_CUR_TARGET_PTR


	ld A, B_DIRECTION
	cp A, #DIR_DOWN
	jreq GetNextDirTargetPointer_down_loop
	
GetNextDirTargetPointer_up_loop:
	call IncRotatePointer
	cpw X, W_NEW_PTR
	jreq GetNextDirTargetPointer_invalid
	pushw X
	ldw X, (X)
	cpw X, (1,SP)
	popw X
	jrmi GetNextDirTargetPointer_up_loop
	jra GetNextDirTargetPointer_target


GetNextDirTargetPointer_down_loop:
	call IncRotatePointer
	cpw X, W_NEW_PTR
	jreq GetNextDirTargetPointer_invalid
	pushw X
	ldw X, (X)
	cpw X, (1,SP)
	popw X
	jrpl GetNextDirTargetPointer_down_loop
	jra GetNextDirTargetPointer_target
GetNextDirTargetPointer_invalid:
	ldw X, #INVALID_TARGET
GetNextDirTargetPointer_target:

GetNextDirTargetPointer_exit:
	; pop temp word
	pop A
	pop A

    pop A
	pop cc
    ret








; ; ---------------------------------
; ; name  : A IsTargetFloor(const X floor)
; ; params: 
; ;
; ; return: A: if current is a target => {True, False}
; ; =================================
; ; A IsTargetFloor(const X floor)
; ; {
; ; }
; ; --------------------------------- 
; .IsTargetFloor.w
; 	push cc
; 	pushw X
; IsTargetFloor_start:
; 	ldw X, W_CUR_TARGET_PTR
; 	ld A, B_FLOOR

; IsTargetFloor_loop:
; 	cp A, (X)
; 	jreq IsTargetFloor_True
; 	call IncRotatePointer
; 	cpw X, W_NEW_PTR
; 	jrne IsTargetFloor_loop
; IsTargetFloor_False:
; 	ld A, #False
; 	jra IsTargetFloor_exit
; IsTargetFloor_True:
; 	ld A, #True

; IsTargetFloor_exit:
; 	popw X
; 	pop cc
; 	ret



; ---------------------------------
; name  : A IsReached()
; params: 
;
; return: A: request reached ? => {True, False}
; =================================
; A IsReached()
; {
; }
; ---------------------------------
.IsReached.w
	push cc
	; pushw X
IsReached_start:
	; ldw X, W_CUR_TARGET_PTR
	; call DecRotatePointer
	ld A, [W_CUR_TARGET_PTR.w]
	cp A, B_FLOOR
	jrne IsReached_False
IsReached_True:
	ld A, #True
	jra IsReached_exit
IsReached_False:
	ld A, #False
IsReached_exit:
    ; popw X
	pop cc
    ret



; ---------------------------------
; name  : A IsAllReqDone()
; params: 
;
; return: A: 
; =================================
; A IsAllReqDone()
; {
; }
; ---------------------------------
.IsAllReqDone.w
	push cc
	pushw X
IsAllReqDone_start:
	ldw X, #MAX_FLOOR
IsAllReqDone_loop:
	call GetFloorReq
	cp A, #REQ_NULL
	jrne IsAllReqDone_False
	decw X
	jrne IsAllReqDone_loop
IsAllReqDone_True:
	ld A, #True
	jra IsAllReqDone_exit
IsAllReqDone_False:
	ld A, #False
IsAllReqDone_exit:
    popw X
	pop cc
    ret



; ---------------------------------
; name  : A GetNearFloorReq()
; params: 
;
; return: A: 
; =================================
; A GetNearFloorReq()
; {
; }
; ---------------------------------
.GetNearFloorReq.w
	push cc
	pushw X
	; pushw Y
GetNearFloorReq_start:
; 	clrw X
; 	ld A, B_FLOOR
; 	cp A, #1

; 	jrne GetNearFloorReq_other_floor
; GetNearFloorReq_floor_1:
; GetNearFloorReq_floor_1_loop:
; 	inc A
; 	cp A, #MAX_FLOOR
; 	jreq GetNearFloorReq_invalid
; 	ld XL, A
; 	call GetFloorReq
; 	cp A, #REQ_NULL
; 	jreq GetNearFloorReq_floor_1_loop
; 	jra GetNearFloorReq_return_req
; GetNearFloorReq_other_floor:
    clrw X
	push #0
GetNearFloorReq_other_floor_loop:
GetNearFloorReq_other_floor_check_overflow:
	ld A, B_FLOOR
	add A, (1,SP)
	cp A, #MAX_FLOOR
	jrmi GetNearFloorReq_other_floor_up
	ld A, B_FLOOR
	sub A, (1,SP)
	cp A, #1
	jrpl GetNearFloorReq_other_floor_up
	jra GetNearFloorReq_invalid
GetNearFloorReq_other_floor_up:
	inc (1,SP)
	ld A, B_FLOOR
	add A, (1,SP)
	cp A, #MAX_FLOOR
	jrugt GetNearFloorReq_other_floor_down
	ld XL, A
	call GetFloorReq
	cp A, #REQ_NULL
	jrne GetNearFloorReq_return_req_other_floor
GetNearFloorReq_other_floor_down:
	ld A, B_FLOOR
	sub A, (1,SP)
	cp A, #1
	jrmi GetNearFloorReq_other_floor_loop
	ld XL, A
	call GetFloorReq
	cp A, #REQ_NULL
	jrne GetNearFloorReq_return_req_other_floor
	jra GetNearFloorReq_other_floor_loop

GetNearFloorReq_return_req_other_floor:
	pop A
GetNearFloorReq_return_req:
	; ld A, #True
	ld A, XL
	jra GetNearFloorReq_exit
GetNearFloorReq_invalid:
	pop A
	ld A, #INVALID_TARGET
GetNearFloorReq_exit:
	; popw Y
    popw X
	pop cc
    ret










    end



