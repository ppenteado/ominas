;==============================================================================
;+
; NAME:
;	nv_module_rename_profile
;
;
; PURPOSE:
;	Renames an OMINAS profile.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_rename_profile, name, new_name
;
;
; ARGUMENTS:
;  INPUT:
;	name:		Current profile name.
;
;	new_name:	New profile name.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	setup_dir:	Directory for setup files, default is ~/.ominas.
;
;	force:		If set, the default profile may be deleted.
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
pro nv_module_rename_profile, name, new_name, setup_dir=setup_dir, force=force
@nv_block.common

 if(strupcase(name) EQ 'DEFAULT') then if(NOT keyword_set(force)) then return

 profiles_dir = nv_module_get_profile_dir(/top, setup_dir=setup_dir)
 profile_dir = profiles_dir + '/' + name
 new_profile_dir = profiles_dir + '/' + new_name

 file_move_decrapified, profile_dir, new_profile_dir

 nv_module_select_profile, new_name, setup_dir=setup_dir

end
;=============================================================================
