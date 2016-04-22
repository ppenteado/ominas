;=============================================================================
;+
; NAME:
;	nv_udata
;
;
; PURPOSE:
;	Returns a user data array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_udata(dd, name)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	name:	String giving the name of the data array.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The data array associated with the specified name.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_udata
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function nv_udata, ddp, name, noevent=noevent
return, cor_udata(ddp, name, noevent=noevent)




@nv.include
 nv_notify, ddp, type = 1, noevent=noevent

 dd = nv_dereference(ddp)

 if(NOT ptr_valid(dd.data_dap)) then return, 0
 if(NOT data_archive_defined(dd.data_dap, dd.dap_index)) then nv_load_data, ddp

 if(NOT keyword_set(name)) then return, dd.udata_tlp
 return, tag_list_get(dd.udata_tlp, name)
end
;===========================================================================



