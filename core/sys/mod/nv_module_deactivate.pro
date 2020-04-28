;==============================================================================
;+
; NAME:
;	nv_module_deactivate
;
;
; PURPOSE:
;	Deactivates a module by removing its setup file from a profile.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_deactivate, module
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
;	force:		If set, the module is deactivated even if the
;			setup file is locked.
;
;	reset:		If set, all module files are removed from the 
;			profile directory.
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
pro nv_module_deactivate, module, reset=reset, force=force

 profile_dir = nv_module_get_profile_dir(module)
 setup_file = profile_dir + '/setup.sh'

 if(NOT keyword_set(force)) then $
                         if(nv_module_query(module, /locked)) then return

 file_delete, /quiet, setup_file

 if(keyword_set(reset)) then $
  begin
   files = file_search(profile_dir + '/*')
   if(keyword_set(files)) then $
      for i=0, n_elements(files)-1 do file_delete, /quiet, files[i]
  end

end
;=============================================================================
