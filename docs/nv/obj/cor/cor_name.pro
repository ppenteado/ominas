;=============================================================================
;+
; NAME:
;	cor_name
;
;
; PURPOSE:
;	Returns the name for each given core descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	name = cor_name(crd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	crd:	 Any subclass of CORE.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Name associated with each given core descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 4/2016
;	
;-
;=============================================================================
function cor_name, crd, noevent=noevent
@core.include
 if(NOT keyword_set(crd)) then return, ''

 n = n_elements(crd)
 names = strarr(n)

 w = where(obj_valid(crd))
 if(w[0] EQ -1) then return, names
 crd = crd[w]
 
 nv_notify, crd, type = 1, noevent=noevent

 _crd = cor_dereference(crd)
 names[w] = _crd.name

 if(n EQ 1) then return, names[0]
 return, names
end
;===========================================================================

