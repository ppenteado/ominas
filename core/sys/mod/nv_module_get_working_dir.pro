;==============================================================================
;+
; NAME:
;	nv_module_get_working_dir
;
;
; PURPOSE:
;	Determines a module working directory.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data_dir = nv_module_get_working_dir(module)
;
;
; ARGUMENTS:
;  INPUT: 
;	module:		Module.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2020
;	
;-
;==============================================================================
function nv_module_get_working_dir, module
 if(keyword_set(file_search(module.working_dir))) then return, module.working_dir
 return, module.data_dir
end
;=============================================================================
