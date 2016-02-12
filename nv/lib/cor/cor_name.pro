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
;	name = cor_name(crx)
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
;	Name associated with each given core descriptor.
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
function cor_name, crxp
@nv_lib.include
 if(NOT keyword_set(crxp)) then return, ''

 n = n_elements(crxp)
 names = strarr(n)

 w = where(ptr_valid(crxp))
 if(w[0] EQ -1) then return, names
 crxp = crxp[w]
 
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1
 crd = nv_dereference(crdp)
 names[w] = crd.name

 if(n EQ 1) then return, names[0]
 return, names
end
;===========================================================================



;===========================================================================
; cor_name
;
;
;===========================================================================
function _cor_name, crxp
@nv_lib.include
 if(NOT keyword_set(crxp)) then return, ''
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1
 crd = nv_dereference(crdp)
 return, crd.name
end
;===========================================================================

