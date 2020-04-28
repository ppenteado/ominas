;=============================================================================
;+
; NAME:
;	core_state_struct__define
;
;
; PURPOSE:
;	Structure defining the CORE state.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	trace:		Specifies whether trace information is printed
;			or object routines.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro core_state_struct__define


 struct = $
    { core_state_struct, $
	trace:			0b $
    }


end
;===========================================================================
