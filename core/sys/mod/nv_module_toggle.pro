;==============================================================================
;+
; NAME:
;	nv_module_toggle
;
;
; PURPOSE:
;	Toggles module activation.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_toggle, module
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
;	force:		If set, the module is toggled even if the
;			setup file is locked.
;
;	reset:		If set, all deactivated module files are removed from
;			the profile directory.
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
; 	Written by:	Spitale		3/2020
;	
;-
;==============================================================================
pro nv_module_toggle, module, reset=reset, force=force

 active = nv_module_query(module, /active)

 if(active) then nv_module_deactivate, module, reset=reset, force=force $
 else nv_module_activate, module, reset=reset, force=force

end
;=============================================================================
