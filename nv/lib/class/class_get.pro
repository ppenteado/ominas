;=============================================================================
;+
; NAME:
;	class_get
;
;
; PURPOSE:
;	Returns the name of the object class.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	class = class_get(od)
;
;
; ARGUMENTS:
;  INPUT:
;	od:	 Descriptor of any class.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	String giving the name of the object class.
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
function class_get, odp, all=all
 if(NOT keyword_set(odp)) then return, ''

 n = n_elements(odp)
 class = strarr(n)

 for i=0, n-1 do class[i] = (*odp[i]).class
 
 return, class
end
;===========================================================================



