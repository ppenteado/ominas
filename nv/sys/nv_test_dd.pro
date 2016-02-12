;=============================================================================
;+
; NAME:
;	nv_test_dd
;
;
; PURPOSE:
;	Determines whether the argument is a valid data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	test = nv_test_dd(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor to test.
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
;	True if the argument is present, is a valid pointer, and
;	points to a data descriptor.
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
function nv_test_dd, ddp
@nv.include
 if(NOT keyword_set(ddp)) then return, 0
 if(NOT ptr_valid(ddp)) then return, 0

 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)

 return, tag_exists(dd, 'DATA_DAP')
end
;====================================================================================
