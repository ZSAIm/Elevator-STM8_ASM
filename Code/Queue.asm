stm8/

	#include "Queue.inc"

	segment 'rom'
	INTEL

; ---------------------------------
; name  : void PutNewTarget(const X target_floor)
; params: X: target floor     => {floor=0~7}
;
; return: 
; =================================
; void PutNewTarget(const X target_floor)
; {
;	if(IsQueueFull() == False){
;		req_queue[W_NEW_PTR] = opa_type;
;	}
; }
; ---------------------------------
.PutNewTarget.w
	push cc
	push A
    pushw X
PutNewTarget_start:
    ld A, XL
    ld [W_NEW_PTR.w], A
	; ldw [W_NEW_PTR.w], X
	ldw X, W_NEW_PTR
	call IncRotatePointer
	ldw W_NEW_PTR, X
PutNewTarget_exit:
    popw X
    pop A
	pop cc
	ret



; ---------------------------------
; name  : A GetNextTarget()
; params: 
;
; return: A: next target
; =================================
; A GetNextTarget()
; {
; 	...
; }
; ---------------------------------
.GetNextTarget.w
	push cc
	pushw X
	; pushw Y
GetNextTarget_start:

	call IsQueueEmpty
	cp A, #True
	jreq GetNextTarget_invalid
    
    ldw X, W_CUR_TARGET_PTR
GetNextTarget_loop:
	call IncRotatePointer
    cpw X, W_NEW_PTR
    jreq GetNextTarget_invalid

    ; ldw W_CUR_TARGET_PTR, X
    ld A, (X)
    cp A, #INVALID_TARGET
    jreq GetNextTarget_loop
    jra GetNextTarget_exit
    

GetNextTarget_invalid:
	; return #INVALID_TARGET
	ld A, #INVALID_TARGET

GetNextTarget_exit:
	; popw Y
	popw X
	pop cc
	ret




; ---------------------------------
; name  : A CheckQueue(const X target_floor)
; params: X: target floor     => {floor=0~7}
;
; return: A: is request in queue already => {True, False}
; =================================
; A CheckQueue(const X target_floor)
; {
; 	...
; }
; ---------------------------------
.CheckQueue.w
	push cc
	; pushw Y
	pushw X
CheckQueue_start:
	
	; current_req == target_floor
	pushw X
	; ldw X, W_CUR_TARGET_PTR
    ldw X, W_CUR_TARGET_PTR
    ld A, (X)
    clrw X
    ld XL, A
	; ldw X, [W_CUR_TARGET_PTR.w]
	; ldw X, (X)
	cpw X, (1,SP)
	popw X
	jreq CheckQueue_exist


	; ldw Y, X
	; X = inc_ptr
	ld A, XL
	ldw X, W_CUR_TARGET_PTR
	; A = target floor
	; ld A, YL

CheckQueue_match_loop:
	call IncRotatePointer
	cpw X, W_NEW_PTR
	jrpl CheckQueue_new

	cp A, (X)
	jreq CheckQueue_exist
	; call IncRotatePointer
	jra CheckQueue_match_loop





CheckQueue_new:
	; return False;
	ld A, #False
	jra CheckQueue_exit
CheckQueue_exist:
	; return True;
	ld A, #True


CheckQueue_exit:
	popw X
	; popw Y
	pop cc
	ret









; ---------------------------------
; name  : A IsQueueFull()
; params: 
;
; return: A: is queue full => {True, False}
; =================================
; void IsQueueFull()
; {
; 	return W_CUR_TARGET_PTR == W_NEW_PTR && B_STATUS != STATUS_IDLE
; }
; ---------------------------------
.IsQueueFull.w
	push cc
	pushw X
IsQueueFull_start:

	ldw X, W_NEW_PTR
	pushw X
	ldw X, W_CUR_TARGET_PTR
	cpw X, (1,SP)
	popw X
	jrne IsQueueFull_NOTfull
IsQueueFull_full_ifidle:
	ld A, B_STATUS
	cp A, #STATUS_IDLE
	jrne IsQueueFull_NOTidle
IsQueueFull_NOTfull:
	ld A, #False
	jra IsQueueFull_exit

IsQueueFull_NOTidle:
	ld A, [W_CUR_TARGET_PTR.w]
	cp A, #INVALID_TARGET
	jreq IsQueueFull_NOTfull
IsQueueFull_full:
	ld A, #True

IsQueueFull_exit:
	popw X
	pop cc
	ret




; ---------------------------------
; name  : A IsQueueEmpty()
; params: 
;
; return: A: is queue empty => {True, False}
; =================================
; void IsQueueEmpty()
; {
; 	return W_CUR_TARGET_PTR == W_NEW_PTR && B_STATUS == STATUS_IDLE
; }
; ---------------------------------
.IsQueueEmpty.w
	push cc
	pushw X
IsQueueEmpty_start:

	ldw X, W_NEW_PTR
	pushw X
	ldw X, W_CUR_TARGET_PTR
	cpw X, (1,SP)
	popw X
	jrne IsQueueEmpty_NOTempty
IsQueueEmpty_empty_isidle:
	ld A, B_STATUS
	cp A, #STATUS_IDLE
	jreq IsQueueEmpty_empty
IsQueueEmpty_NOTempty:
	ld A, #False
	jra IsQueueEmpty_exit

IsQueueEmpty_empty:
	ld A, #True

IsQueueEmpty_exit:
	popw X
	pop cc
	ret





; ---------------------------------
; name  : X IncRotatePointer(X pointer)
; params: X: raw pointer
;
; return: X: handled pointer
; =================================
; void IncRotatePointer()
; {
; 	...
; }
; ---------------------------------
.IncRotatePointer.w
	push cc
IncRotatePointer_start:
	incw X
	cpw X, #{TARGET_QUEUE_TOP+1}
	jrne IncRotatePointer_exit
	ldw X, #TARGET_QUEUE_BOTTOM
IncRotatePointer_exit:
	pop cc
	ret


; ---------------------------------
; name  : X DecRotatePointer(X pointer)
; params: X: raw pointer
;
; return: X: handled pointer
; =================================
; void DecRotatePointer()
; {
; 	...
; }
; ---------------------------------
.DecRotatePointer.w
	push cc
DecRotatePointer_start:
	decw X
	cpw X, #TARGET_QUEUE_BOTTOM
	jrpl DecRotatePointer_exit
	; jrne DecRotatePointer_exit
	ldw X, #TARGET_QUEUE_TOP
DecRotatePointer_exit:
	pop cc
	ret












	end

