;==============================================================================
;+
; NAME:
;	nv_module_get_profile_dir
;
;
; PURPOSE:
;	Returns and an OMINAS profile directory.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	profile_dir = nv_module_get_profile_dir(module, name=name)
;
;
; ARGUMENTS:
;  INPUT:
;	module:		OMINAS module.  If given, the return value includes
;			the path to the module within the profile.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	name:		Profile name.  If not given, the OMINAS_PROFILE environment
;			variable is checked.  If that is not set, the top directory 
;			of the current profile is used.  If a non-existent profile
;			is specified, it is created as a cloine of the Default profile.
;
;	setup_dir:	Directory for setup files, default is ~/.ominas.
;
;	top:		If set, the directory containing the profiles is 
;			returned.
;
;  OUTPUT: 
;	flags:		Byte giving flag info.
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
function __nv_module_get_profile_dir, module, name=name, $
                 setup_dir=setup_dir, top=top, flags=flags

 setup_dir = nv_module_get_setup_dir(setup_dir=setup_dir)

 profile_top = setup_dir + '/profiles/'
 if(keyword_set(top)) then return, profile_top

 if(NOT keyword_set(name)) then profile_dir = setup_dir + '/profile' $
 else profile_dir = profile_top + '/' + name

 if(keyword_set(module)) then profile_dir = profile_dir + '/'+ module.profile_dir
 
 return, profile_dir
end
;=============================================================================



;==============================================================================
function nv_module_get_profile_dir, module, name=name, $
                 setup_dir=setup_dir, top=top, flags=flags

 setup_dir = nv_module_get_setup_dir(setup_dir=setup_dir)

 profile_top = setup_dir + '/profiles/'
 if(keyword_set(top)) then return, profile_top

 if(NOT keyword_set(name)) then name = nv_getenv('OMINAS_PROFILE')
 if(NOT keyword_set(name)) then profile_dir = setup_dir + '/profile' $
 else profile_dir = profile_top + '/' + name

 if(keyword_set(module)) then profile_dir = profile_dir + '/'+ module.profile_dir
 
 return, profile_dir
end
;=============================================================================
