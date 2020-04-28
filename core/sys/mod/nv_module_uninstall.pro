;==============================================================================
;+
; NAME:
;	nv_module_uninstall
;
;
; PURPOSE:
;	Uninstalls a user module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	status = nv_module_uninstall(module)
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
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:  0 if successful, nonzero otherwise.
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
pro nv_module_uninstall, module

 if(NOT nv_module_query(module, /installed)) then return

 ;---------------------------------------------------
 ; first uninstall submodules
 ;---------------------------------------------------
 submodules = nv_get_submodules(module)
 if(keyword_set(submodules)) then $
        for i=0, n_elements(submodules)-1 do nv_module_uninstall, submodules[i]


 ;---------------------------------------------------
 ; deactivate module
 ;---------------------------------------------------
 nv_module_deactivate, module, /reset


 ;---------------------------------------------------
 ; call module uninstallation program
 ;---------------------------------------------------
 fn = module.uninstall_fn

 if(keyword_set(fn)) then $
  begin
   args = {dir:module.data_dir, method_dir:module.method_dir}
   status = call_function(fn, args)

   if(keyword_set(status)) then $
    begin
     nv_message, /continue, $
           'Module uninstallation failed for: ' + strupcase(module.qname)
     return
    end
  end


 ;---------------------------------------------------
 ; delete data directory 
 ;---------------------------------------------------
 file_delete, /quiet, module.data_dir, /recursive

 nv_message, verb=0.1, $
      'Module successfully uninstalled: ' + strupcase(module.qname)
end
;=============================================================================
