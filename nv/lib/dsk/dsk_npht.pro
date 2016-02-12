;=============================================================================
;+
; NAME:
;	dsk_npht
;
;
; PURPOSE:
;	Returns an integer indicating the maximum number of parameters
;	allowed in the refl_parm and phase-parm fields of the disk 
;	descriptor.  This number can be adjusted using the environment 
;	variable 'dsk_NPHT'.  The default is 4.
;
;
; CATEGORY:
;	NV/LIB/dsk
;
;
; CALLING SEQUENCE:
;	npht = dsk_npht()
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
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Current npht value.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function dsk_npht

 npht_string = getenv('DSK_NPHT')
 if(keyword__set(npht_string)) then npht = strtrim(npht_string, 2) else npht = 4

 return, npht
end
;===========================================================================



