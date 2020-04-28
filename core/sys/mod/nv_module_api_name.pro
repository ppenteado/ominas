;==============================================================================
;+
; NAME:
;	nv_module_api_name
;
;
; PURPOSE:
;	Constructs an API name for a module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	apiname = nv_module_api_name(qname)
;
;
; ARGUMENTS:
;  INPUT:
;	qname:		Fully qualified module name.
;	
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
; RETURN:  API module name.
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
function nv_module_api_name, qname
 s = strsplit(qname, '.', /extract)
 if(n_elements(s) EQ 1) then return, s[0]
 return, str_comma_list(s[1:*], delim='_')
end
;=============================================================================
