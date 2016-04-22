;=============================================================================
;+
; NAME:
;	cor_udata
;
;
; PURPOSE:
;	Retrieves user data stored in a descriptor under the specified name.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	data = cor_udata(crx, name)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  If multiple crx are provided, then
;		 the trailing dimension represents each each descriptor.
;
;	name:	 Name associated with the data.
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
;	Data associated with the given name.
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
function cor_udata, crxp, name, noevent=noevent
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1, noevent=noevent
 crd = nv_dereference(crdp)

 if(NOT keyword_set(name)) then return, crd.udata_tlp


 n = n_elements(crd)

 ;----------------------------
 ; if only one crd
 ;----------------------------
 if(n EQ 1) then return, tag_list_get(crd.udata_tlp, name)

 ;----------------------------
 ; if more than one crd
 ;----------------------------
 xx = tag_list_get(crd[0].udata_tlp, name, index=index)
 dim = size([xx], /dim)
 xdim = product(dim)
 type = size(xx, /type)

 result = tr(reform([xx], xdim, /over))
 for i=1, n-1 do $
      result = [result, $
        tr(reform([tag_list_get(crd[i].udata_tlp, index=index)], xdim, /over))]
 result = reform(tr(result), [dim, n], /over)

 return, result
end
;=============================================================================
