;==============================================================================
;+
; NAME:
;	nv_module_read_description
;
;
; PURPOSE:
;	Reads and parses a module description file.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	description = nv_module_read_description(dir, name=name)
;
;
; ARGUMENTS:
;  INPUT:
;	dir:		 Module code directory,
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: 
;	name:		Module name.
;
;
; RETURN:  Description text.
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
function nv_module_read_description, dir, abbr, name=name

 name = abbr
 description = read_txt_file(dir+'/module/module_description.txt', /raw)
 if(NOT keyword_set(description)) then return, ''

 name = description[0]
 description = description[1:*]

 return, description
end
;=============================================================================
