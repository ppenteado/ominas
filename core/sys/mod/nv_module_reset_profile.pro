;==============================================================================
;+
; NAME:
;	nv_module_reset_profile
;
;
; PURPOSE:
;	Resets a profile to Default settings.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_reset_profile, name
;
;
; ARGUMENTS:
;  INPUT: 
;	name:		Name of profile to reset.  If not given, the
;			current profile is reset.
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
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
pro nv_module_reset_profile, name
 if(NOT keyword_set(name)) then name = nv_module_get_profiles(/cur)
 nv_module_delete_profile, name, /force
 nv_module_create_profile, name
end
;==============================================================================
