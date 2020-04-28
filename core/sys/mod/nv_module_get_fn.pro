;==============================================================================
;+
; NAME:
;	nv_module_get_fn
;
;
; type:
;	Creates a name for an installation methods.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	fn_name = nv_module_get_fn(module, type)
;
;
; ARGUMENTS:
;  INPUT:
;	module:	 	Module data structure.
;
;	type:		Type of method (install, uninstall, query, etc.).
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
; RETURN:  Method name.
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
function nv_module_get_fn, module, type

 fn = 'module_' + strlowcase(type) + '_' + module.apibbr

 if(NOT routine_exists(fn)) then $
  begin
   nv_message, verb=0.9, 'Module program does not exist: ' + fn
   return, ''
  end

 return, fn
end
;=============================================================================
