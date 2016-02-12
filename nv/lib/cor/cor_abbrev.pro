;=============================================================================
;+
; NAME:
;	cor_abbrev
;
;
; PURPOSE:
;	Returns the abbrieviation for the given object class.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	abbrev = cor_abbrev(xd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	 Descriptor.
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
;	String giving the standard abbreviation for the given class, 
;	e.g., 'BOD'.
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
function cor_abbrev, xd
 return, (*xd[0]).abbrev
end
;===========================================================================


