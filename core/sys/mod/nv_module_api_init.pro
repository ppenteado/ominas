;==============================================================================
;+
; NAME:
;	nv_module_api_init
;
;
; PURPOSE:
;	Initializes the OMINAS module API.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_api_init, setup_dir
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	setup_dir:	Directory for setup files, default is ~/.ominas.
;
;	reset:		If set, configuration files are overwritten with 
;			defaults.
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
; nv_module_api_init
;
;
;==============================================================================
pro nv_module_api_init, setup_dir=setup_dir, reset=reset

 setup_dir = nv_module_get_setup_dir(setup_dir=setup_dir)
 profiles_dir = setup_dir + '/profiles'
 ominas_dir = getenv('OMINAS_DIR')
 ominas_defaults_dir = ominas_dir + '/defaults'


 ;-------------------------------------------------------------
 ; test the profile link
 ;-------------------------------------------------------------
 profile_dir = nv_module_get_profile_dir(setup_dir=setup_dir)
 test = file_readlink_decrapified(profile_dir)
 if(NOT keyword_set(test)) then $
                       nv_module_select_profile, 'Default', setup_dir=setup_dir
 print, 'Using profile "' + nv_module_get_profiles(/cur) + '"'


 ;-------------------------------------------------------------
 ; create directories
 ;-------------------------------------------------------------
 file_mkdir_decrapified, [setup_dir, profiles_dir]


 ;-------------------------------------------------------------
 ; copy default files
 ;-------------------------------------------------------------
 default_files = file_search(ominas_defaults_dir + '/*')
 file_copy_decrapified, default_files, setup_dir, overwrite=reset


 ;-------------------------------------------------------------
 ; build the module tree
 ;-------------------------------------------------------------
 nv_module_scan


 ;-------------------------------------------------------------
 ; create the default profile if necessary
 ;-------------------------------------------------------------
 nv_module_create_profile, 'Default', reset=reset

end
;=============================================================================
