;=============================================================================
;+
; NAME:
;	cor_init_state
;
;
; PURPOSE:
;	Initializes the CORE state structure.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	state = cor_init_state()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	New core state structure.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		5/2016
;	
;-
;=============================================================================
function cor_init_state
@nv_block.common

 state = {core_state_struct}
 
 state.trace = 0

 return, state
end
;===========================================================================
