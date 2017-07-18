;=============================================================================
;+
; NAME:
;	nv_suspend_events
;
;
; PURPOSE:
;	Suspends data event tracking.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	nv_suspend_events
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_suspend_events
@nv_notify_block.common

 suspended = 1

end
;=============================================================================

