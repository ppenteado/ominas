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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_udata, crd, name, noevent=noevent
@core.include
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)

 if(NOT keyword_set(name)) then return, _crd.udata_tlp


 n = n_elements(_crd)

 ;----------------------------
 ; if only one crd
 ;----------------------------
 if(n EQ 1) then return, tag_list_get(_crd.udata_tlp, name)

 ;----------------------------
 ; if more than one crd
 ;----------------------------
 xx = tag_list_get(_crd[0].udata_tlp, name, index=index)
 dim = size([xx], /dim)
 xdim = product(dim)
 type = size(xx, /type)

 result = tr(reform([xx], xdim, /over))
 for i=1, n-1 do $
      result = [result, $
        tr(reform([tag_list_get(_crd[i].udata_tlp, index=index)], xdim, /over))]
 result = reform(tr(result), [dim, n], /over)

 return, result
end
;=============================================================================
