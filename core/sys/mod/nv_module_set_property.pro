;==============================================================================
;+
; NAME:
;	nv_module_set_property
;
;
; PURPOSE:
;	Sets a value in the properties file.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_set_property, module, keyword, value
;
;
; ARGUMENTS:
;  INPUT:
;	module:	 	Module data structure.
;
;	keyword:	Name of keyword to set.
;
;	value:		New value.
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
pro nv_module_set_property, module, keyword, value

 prop_file = nv_module_get_properties_filename(module)
 if(NOT defined(value)) then value = 1

 properties = read_settings(prop_file)
 write_settings, prop_file, struct_replace(properties, keyword, value)

end
;=============================================================================
