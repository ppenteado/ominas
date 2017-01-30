;=============================================================================
;+
; NAME:
;	_cor_udata
;
;
; PURPOSE:
;	Retrieves user data stored in a structure under the specified name.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	data = _cor_udata(_crd, name)
;
;
; ARGUMENTS:
;  INPUT:
;	_crd:	 Any subclass of CORE.  If multiple _crd are provided, then
;		 the trailing dimension represents each each structure.
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
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _cor_udata, _crd, name

 if(NOT keyword_set(name)) then return, _crd.udata_tlp


 n = n_elements(_crd)

 ;----------------------------
 ; if only one _crd
 ;----------------------------
 if(n EQ 1) then return, tag_list_get(_crd.udata_tlp, name)

 ;----------------------------
 ; if more than one _crd
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
