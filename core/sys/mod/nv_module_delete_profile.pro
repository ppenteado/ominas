;==============================================================================
;+
; NAME:
;	nv_module_delete_profile
;
;
; PURPOSE:
;	Deletes an OMINAS profile.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_delete_profile, name
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
pro nv_module_delete_profile, name, setup_dir=setup_dir, force=force
@nv_block.common

 if(strupcase(name) EQ 'DEFAULT') then if(NOT keyword_set(force)) then return

 profile_dir = nv_module_get_profile_dir(name=name, setup_dir=setup_dir)

 ;-------------------------------------------------------------
 ; delete the profile directory
 ;-------------------------------------------------------------
 file_delete, /quiet, profile_dir, /recursive, /allow_nonexistent

 ;-------------------------------------------------------------
 ; select a remaining profile
 ;-------------------------------------------------------------
 nv_module_select_profile, 'Default', setup_dir=setup_dir

end
;=============================================================================
