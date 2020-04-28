;==============================================================================
;+
; NAME:
;	nv_module_get_property
;
;
; PURPOSE:
;	Reads a value from the properties file.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	value = nv_module_get_property(module, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	module:	 	Module data structure.
;
;	keyword:	Name of keyword to retrieve.
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
function nv_module_get_property, module, keyword

 prop_file = nv_module_get_properties_filename(module)

 properties = read_settings(prop_file)
 if(NOT keyword_set(properties)) then return, !null

 return, struct_get(properties, keyword)
end
;=============================================================================
