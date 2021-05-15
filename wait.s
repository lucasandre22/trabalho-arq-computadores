.equ TWOSEC, 4000
.equ SWI_GetTicks, 0x6d 
	ldr r2,=10000
Wait:
	@stmfd sp!, {r0-r1,lr}
	swi SWI_GetTicks
	mov r1, r0 @ R1: start time
WaitLoop:
	swi SWI_GetTicks
	subs r0, r0, r1 @ R0: time since start
	@rsblt r0, r0, #0 @ fix unsigned subtract
	cmp r0, r2
	blt WaitLoop
WaitDone:
	mov r10, #9
