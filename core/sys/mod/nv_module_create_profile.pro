;==============================================================================
;+
; NAME:
;	nv_module_create_profile
;
;
; PURPOSE:
;	Creates an OMINAS profile using the current module tree.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_create_profile, name
;
;
; ARGUMENTS:
;  INPUT:
;	name:		Profile name.  If not given, then 'Default' is assumed.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	setup_dir:	Directory for setup files, default is ~/.ominas.
;
;	clone:		Name of a profile to clone instead of using the default
;			setup.
;
;	reset:		If set, the profile is overwritten with defaults.
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



;==============================================================================
; nvmcp_descend
;
;
;==============================================================================
pro nvmcp_descend, module, dir=dir, reset=reset

 nv_module_activate, module, /no_setup, reset=reset	; just create directory
 modules = nv_get_submodules(module)
 if(keyword_set(modules)) then $
      for i=0, n_elements(modules)-1 do nvmcp_descend, modules[i], dir=dir

end
;==============================================================================



;==============================================================================
; nvmcvp_new
;
;==============================================================================
pro nvmcvp_new, name, profile_dir, setup_dir=setup_dir

 file_mkdir_decrapified, profile_dir
 nv_module_select_profile, name, setup_dir=setup_dir
 nvmcp_descend, nv_get_module(), dir=profile_dir, reset=reset

end
;==============================================================================



;==============================================================================
; nvmcvp_clone
;
;==============================================================================
pro nvmcvp_clone, name, clone, profile_dir, setup_dir=setup_dir

 clone_dir = nv_module_get_profile_dir(name=clone, setup_dir=setup_dir)
 file_copy_decrapified, /recursive, clone_dir, profile_dir
 nv_module_select_profile, name, setup_dir=setup_dir

end
;==============================================================================



;==============================================================================
; nv_module_create_profile
;
;==============================================================================
pro nv_module_create_profile, name, setup_dir=setup_dir, clone=clone, reset=reset
@nv_block.common

 profile_dir = nv_module_get_profile_dir(name=name, setup_dir=setup_dir)
 ff = file_search(profile_dir)
 if(keyword_set(ff)) then return

 if(keyword_set(clone)) then nvmcvp_clone, name, clone, profile_dir, setup_dir=setup_dir $
 else nvmcvp_new, name, profile_dir, setup_dir=setup_dir

end
;=============================================================================
