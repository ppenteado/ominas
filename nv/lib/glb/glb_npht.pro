;=============================================================================
;+
; NAME:
;	glb_npht
;
;
; PURPOSE:
;	Returns an integer indicating the maximum number of parameters
;	allowed in the refl_parm and phase-parm fields of the globe 
;	descriptor.  This number can be adjusted using the environment 
;	variable 'GLB_NPHT'.  The default is 4.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	npht = glb_npht()
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
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function glb_npht

 npht_string = getenv('GLB_NPHT')
 if(keyword__set(npht_string)) then npht = strtrim(npht_string, 2) else npht = 4

 return, npht
end
;===========================================================================



