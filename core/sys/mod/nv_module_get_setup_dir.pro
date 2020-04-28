;==============================================================================
;+
; NAME:
;	nv_module_get_setup_dir
;
;
; PURPOSE:
;	Returns the OMINAS setup directory.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	setup_dir = nv_module_get_setup_dir()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	setup_dir:	Directory to use instead of the default.
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
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
function nv_module_get_setup_dir, setup_dir=setup_dir
 if(keyword_set(setup_dir)) then return, setup_dir
 return, '$HOME/.ominas'
end
;=============================================================================
