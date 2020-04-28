;==============================================================================
;+
; NAME:
;	nv_module_select_profile
;
;
; PURPOSE:
;	Selects an OMINAS profile.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_select_profile, name
;
;
; ARGUMENTS:
;  INPUT:
;	name:		Profile name.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	setup_dir:	Directory for setup files, default is ~/.ominas.
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
pro nv_module_select_profile, name, setup_dir=setup_dir

 profile_dir = nv_module_get_profile_dir(name=name, setup_dir=setup_dir)
 profile_link = nv_module_get_profile_dir(setup_dir=setup_dir)

 file_delete, /quiet, profile_link
 file_link_decrapified, profile_dir, profile_link

end
;=============================================================================
