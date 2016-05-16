;=============================================================================
;+
; NAME:
;	cor_idp
;
;
; PURPOSE:
;	Returns the id pointer for each given core descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	idp = cor_idp(crd)
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
;	ID pointer associated with each given core descriptor.
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
function cor_idp, crd, noevent=noevent
@core.include
 if(NOT keyword_set(crd)) then return, ''

 n = n_elements(crd)
 idps = ptrarr(n)

 w = where(obj_valid(crd))
 if(w[0] EQ -1) then return, idps
 crd = crd[w]
 
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
 idps[w] = _crd.idp

 if(n EQ 1) then return, idps[0]
 return, idps
end
;===========================================================================

