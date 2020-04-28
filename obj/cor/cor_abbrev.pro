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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_abbrev, crd, noevent=noevent
@core.include
 if(NOT keyword_set(crd)) then return, ''

 n = n_elements(crd)
 abbrev = strarr(n)

 w = where(obj_valid(crd))
 if(w[0] EQ -1) then return, abbrev
 crd = crd[w]
 
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
 abbrev[w] = _crd.abbrev

 if(n EQ 1) then return, abbrev[0]
 return, abbrev
end
;===========================================================================







;=============================================================================
function _cor_abbrev, xd
 dim = size([xd], /dim)
 n = n_elements(xd)
 abbrev = strarr(dim)
 for i=0, n-1 do abbrev[i] = (*xd[i]).abbrev
 if(n EQ 1) then abbrev = abbrev[0]
 return, abbrev
end
;===========================================================================


