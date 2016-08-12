;=============================================================================
;+
; NAME:
;	nv_protected
;
;
; PURPOSE:
;	Tests whether a structure field is protected.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	test = nv_protected(tag)
;
;
; ARGUMENTS:
;  INPUT:
;	tag:		Structure tag to test.
;
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
;	1 if protected, 0 if not.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2016
;	
;-
;=============================================================================
function nv_protected, tag
 token = '__PROTECT__'
 if(strmid(tag, 0, strlen(token)) EQ token) then return, 1
 return, 0
end
;===========================================================================



