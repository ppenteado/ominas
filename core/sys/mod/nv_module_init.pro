;==============================================================================
;+
; NAME:
;	nv_module_init
;
;
; PURPOSE:
;	Calls a user module init method.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	status = nv_module_init(module)
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
; 	Written by:	Spitale		3/2020
;	
;-
;==============================================================================
pro nv_module_init, module

 if(NOT nv_module_query(module, /active)) then return
 if(nv_module_query(module, /suppressed)) then return
 if(module.initialized) then return

 fn = module.init_fn

 if(keyword_set(fn)) then $
  begin
   args = {dir:module.data_dir, method_dir:module.method_dir}
   status = call_function(fn, args)

   if(keyword_set(status)) then $
    begin
     nv_message, /continue, $
           'Module initialization failed for: ' + strupcase(module.qname)
     return
    end
  end

 module.initialized = 1
 nv_message, verb=0.1, $
      'Module successfully initialized: ' + strupcase(module.qname)
end
;=============================================================================
