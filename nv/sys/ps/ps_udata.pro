;=============================================================================
;+
; NAME:
;	ps_udata
;
;
; PURPOSE:
;	Returns a user data array associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	udata = ps_udata(ps, name)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points structure.
;
;	name:	String giving the name of the data array.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The user data array associated with the specified name.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_udata
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_udata, psp, name, noevent=noevent
 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 if(NOT keyword_set(name)) then return, ps.udata_tlp
 return, tag_list_get(ps.udata_tlp, name)
end
;===========================================================================



