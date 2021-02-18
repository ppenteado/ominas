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
;  OUTPUT: 
;	new:		Indicates that this is a new OMINAS installation.
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
pro nv_module_api_init, setup_dir=setup_dir, new=new

 setup_dir = nv_module_get_setup_dir(setup_dir=setup_dir)
 profiles_dir = setup_dir + '/profiles'
 ominas_dir = getenv('OMINAS_DIR')
 ominas_defaults_dir = ominas_dir + '/defaults'


 ;-------------------------------------------------------------
 ; test the profile link
 ;-------------------------------------------------------------
 profile_dir = nv_module_get_profile_dir(setup_dir=setup_dir)
 test = file_readlink_decrapified(profile_dir)
 new = 0
 if(NOT keyword_set(test)) then $
  begin
   new = 1
   nv_module_select_profile, 'Default', setup_dir=setup_dir
  end
 print, 'Using profile "' + nv_module_get_profiles(/cur) + '"'


 ;-------------------------------------------------------------
 ; build the module tree
 ;-------------------------------------------------------------
 nv_module_scan


 ;-------------------------------------------------------------
 ; create the default profile if necessary
 ;-------------------------------------------------------------
 nv_module_create_profile, 'Default'

end
;=============================================================================
