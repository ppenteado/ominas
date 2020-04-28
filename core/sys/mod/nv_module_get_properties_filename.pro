;==============================================================================
;+
; NAME:
;	nv_module_get_properties_filename
;
;
; PURPOSE:
;	Returns the path to the properties file for a given module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filename = nv_module_get_properties_filename(module)
;
;
; ARGUMENTS:
;  INPUT:
;	module:	 	Module data structure.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	dir:		Directory.  Default is the profile directory for 
;			that module.
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
function nv_module_get_properties_filename, module, dir=dir

 if(NOT keyword_set(dir)) then dir = nv_module_get_profile_dir(module)
 return, dir + '/properties.txt'
end
;=============================================================================
