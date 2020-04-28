;==============================================================================
;+
; NAME:
;	nv_module_get_profiles
;
;
; PURPOSE:
;	Returns the names of all OMINAS profiles.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	profiles = nv_module_get_profiles()
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
;	current:	If set, onnly the name of the current profile is 
;			returned.
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
function nv_module_get_profiles, current=current

 if(keyword_set(current)) then $
  begin
   profile_dir = nv_module_get_profile_dir()
   qdir = file_readlink(profile_dir)
   return, file_basename(qdir)
  end

 profile_top = nv_module_get_profile_dir(/top)
 return, file_basename(file_search(profile_top + '/*', /test_dir))
end
;=============================================================================
