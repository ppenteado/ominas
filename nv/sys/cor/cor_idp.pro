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
;	idp = cor_idp(crx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	crx:	 Any subclass of CORE.
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
;	
;-
;=============================================================================
function cor_idp, crxp, noevent=noevent
@nv_lib.include
 if(NOT keyword_set(crxp)) then return, ''

 n = n_elements(crxp)
 idps = ptrarr(n)

 w = where(ptr_valid(crxp))
 if(w[0] EQ -1) then return, idps
 crxp = crxp[w]
 
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1, noevent=noevent
 crd = nv_dereference(crdp)
 idps[w] = crd.idp

 if(n EQ 1) then return, idps[0]
 return, idps
end
;===========================================================================

