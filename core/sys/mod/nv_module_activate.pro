;==============================================================================
;+
; NAME:
;	nv_module_activate
;
;
; PURPOSE:
;	Activates a module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_activate, module
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
;	no_setup:	If set, the setup file is not copied, meaning
;			that it the module will not be considered active.
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
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================
pro nv_module_activate, module, no_setup=no_setup, force=force

 profile_dir = nv_module_get_profile_dir(module)
 method_dir = module.method_dir
 apibbr = module.apibbr

 ;-------------------------------------------------------------
 ; check module lock
 ;-------------------------------------------------------------
 if(NOT keyword_set(force)) then $
                         if(nv_module_query(module, /locked)) then return

 ;-------------------------------------------------------------
 ; create profile module directory
 ;-------------------------------------------------------------
 file_mkdir_decrapified, profile_dir

 ;-------------------------------------------------------------
 ; copy default properties file
 ;-------------------------------------------------------------
 prop_file = nv_module_get_properties_filename(module, dir=method_dir)
 file_copy_decrapified, prop_file, profile_dir

 ;-------------------------------------------------------------
 ; copy detectors
 ;-------------------------------------------------------------
 detector_files = file_basename(file_search(method_dir + '/detect_*.pro'))
 if(keyword_set(detector_files)) then $
  file_copy_decrapified, method_dir + '/' + detector_files, profile_dir

 ;-------------------------------------------------------------
 ; copy tables
 ;-------------------------------------------------------------
 table_files = file_basename(file_search(method_dir + '/*.tab'))
 if(keyword_set(table_files)) then $
  file_copy_decrapified, method_dir + '/' + table_files, profile_dir

 ;-------------------------------------------------------------
 ; copy setup code
 ;-------------------------------------------------------------
 if(NOT keyword_set(no_setup)) then $
  begin
   setup_src = method_dir + '/setup.sh'
   setup_dst = profile_dir + '/setup.sh'
   ff = file_search(setup_src)
   if(NOT keyword_set(ff)) then write_txt_file, setup_dst, '#' $
   else file_copy_decrapified, setup_src, setup_dst
  end

 ;-------------------------------------------------------------
 ; implement 'activate' property
 ;-------------------------------------------------------------
 if(NOT keyword_set(force)) then $
         if(nv_module_get_property(module, 'activate')) then $
                                          nv_module_activate, module, /force

end
;=============================================================================
