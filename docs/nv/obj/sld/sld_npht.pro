;=============================================================================
;+
; NAME:
;	sld_npht
;
;
; PURPOSE:
;	Returns an integer indicating the maximum number of parameters
;	allowed in the refl_parm and phase-parm fields of the solid 
;	descriptor.  This number can be adjusted using the environment 
;	variable 'SLD_NPHT'.  The default is 4.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	npht = sld_npht()
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
; ENVIRONMENT VARIABLES:
;	SLD_NPHT:	Sets the npht value.
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
function sld_npht

 npht_string = getenv('SLD_NPHT')
 if(keyword__set(npht_string)) then npht = strtrim(npht_string, 2) else npht = 4

 return, npht
end
;===========================================================================



