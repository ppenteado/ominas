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

 return, _cor_udata(_crd, name)
end
;=============================================================================
