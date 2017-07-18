;=============================================================================
;+
; NAME:
;	bod_ndv
;
;
; PURPOSE:
;	Returns an integer indicating the maximum number of time derivatives
;	allowed in the vel and avel fields of the body descriptor.  This number
;	can be adjusted using the environment variable 'BOD_NDV'.  The default
;	is 4.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	ndv = bod_ndv()
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
;	BOD_NDV:	Sets the ndv value.
;
;
; RETURN:
;	Current ndv value.
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
function bod_ndv
@core.include

 ndv_string = getenv('BOD_NDV')
 if(keyword__set(ndv_string)) then ndv=strtrim(ndv_string, 2) else ndv=4

 return, ndv
end
;===========================================================================



