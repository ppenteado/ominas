;==============================================================================
;+
; NAME:
;	nv_module_get_udata
;
;
; PURPOSE:
;	Adds user data to a module structure.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	udata = nv_module_get_udata(module, uname)
;
;
; ARGUMENTS:
;  INPUT:
;	module:		Module structure.
;
;	uname:		Label to associate with the data.
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
; RETURN:  User data associated with the given uname.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
function nv_module_get_udata, module, uname

 return, tag_list_get(module.udata_tlp, uname)

end
;=============================================================================
