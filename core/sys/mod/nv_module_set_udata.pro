;==============================================================================
;+
; NAME:
;	nv_module_set_udata
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
;	nv_module_set_udata, module, uname, udata
;
;
; ARGUMENTS:
;  INPUT:
;	module:		Module structure.
;
;	uname:		Label to associate with the data.
;
;	udata:		User data.
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
; RETURN:  NONE
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
pro nv_module_set_udata, module, uname, udata

 tag_list_set, module.udata_tlp, uname, udata

end
;=============================================================================
