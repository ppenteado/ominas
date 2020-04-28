;=============================================================================
;+
; NAME:
;	cor_tag
;
;
; PURPOSE:
;	Returns the tag name for the given object class.
;
;
; CATEGORY:
;	NV/OBJ/COR
;
;
; CALLING SEQUENCE:
;	tag = cor_tag(xd)
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
;  INPUT:  
;	x:	If set, the generic form is returned, e.g, 'CRX'.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	String giving the standard tag for the given class, e.g., 'CRD'.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2017
;	
;-
;=============================================================================
function cor_tag, crd, x=x, noevent=noevent
@core.include
 if(NOT keyword_set(crd)) then return, ''

 n = n_elements(crd)
 tag = strarr(n)

 w = where(obj_valid(crd))
 if(w[0] EQ -1) then return, tag
 crd = crd[w]
 
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
 tag[w] = _crd.tag

 if(keyword_set(x)) then $
  begin
   gat = byte(str_flip(tag))
   gat[0,*] = byte('X')
   tag = str_flip(gat)
  end

 if(n EQ 1) then return, tag[0]
 return, tag
end
;===========================================================================


