;==============================================================================
;+
; NAME:
;	nv_module_install
;
;
; PURPOSE:
;	Installs a user module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	status = nv_module_install(module)
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
;	update:		If set, the existing module is updated.
;
;	working_dir:	Working directory, other than the default, to install into.
;
;	fg:		If set, the install method is run in the foreground instead of
;			in a parallel child process.
;
;	callback:	Procedure to call upon completion.
;
;	data:		Data for the callback function.
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



;==============================================================================
; nv_module_install_callback
;
;==============================================================================
pro nv_module_install_callback, status, error, bridge, data

 module = nv_get_module(data.qname)
 qname = strupcase(data.qname)

 if(status EQ 2) then $
  begin
   nv_message, /continue, /anonymous, 'Module successfully installed: ' + qname
   file_move_decrapified, module.working_dir, module.data_dir
  end $
 else if(status EQ 3) then $
   nv_message, /continue, /anonymous, $
             'Module installation failed for: ' + qname, explanation=error $
 else if (status EQ 4) then $
    nv_message, /continue, /anonymous, 'Module installation aborted for: ' + qname

 if(keyword_set(data.callback)) then $
                           call_procedure, data.callback, module, data.data
end
;==============================================================================



;==============================================================================
; nv_module_install
;
;==============================================================================
function _nv_module_install, module, update=update, working_dir=working_dir, fg=fg, $
                                                      callback=callback, data=data

 if(NOT keyword_set(callback)) then callback = ''
 if(NOT keyword_set(data)) then data = ''
 update = keyword_set(update)

 ;-----------------------------------------------------------------------
 ; Determine which directory in which to install:
 ;  A fresh installation goes into a temporary directory and is copied
 ;  into the final directory after successful installation.  An update
 ;  goes into whichever directory cirrently exists.
 ;-----------------------------------------------------------------------
 data_dir = module.data_dir

 if(NOT keyword_set(working_dir)) then $
  begin
   working_dir = module.working_dir
   if(update) then working_dir = nv_module_get_working_dir(module)
  end

 ;-----------------------------------------------------------------------
 ; set up arguments for the callback function
 ;-----------------------------------------------------------------------
 args = {dir:working_dir, method_dir:module.method_dir, update:update, $
         qname:module.qname, working_dir:working_dir, data_dir:data_dir}
 udata = {qname:module.qname, callback:callback, data:data}

 ;-----------------------------------------------------------------------
 ; Determine whther anupdate is really necessary
 ;-----------------------------------------------------------------------
 if(NOT update) then $
  begin
   if(nv_module_query(module, /installed)) then return, udata
  end $
 else if(NOT nv_module_query(module, /installed)) then $
                    if(NOT nv_module_query(module, /broken)) then return, udata


 ;---------------------------------------------------
 ; Create module working directory
 ;---------------------------------------------------
 file_mkdir_decrapified, working_dir


 ;---------------------------------------------------
 ; First install submodules
 ;---------------------------------------------------
 submodules = nv_get_submodules(module)
 if(keyword_set(submodules)) then $
     for i=0, n_elements(submodules)-1 do $
              nv_module_install, submodules[i], update=update, working_dir=working_dir


 ;--------------------------------------------------------------------
 ; Call module installation program to install into working dir
 ; Note: install methods run in a child process (i.e. /fg not set) 
 ; do not have access to OMINAS; they must be written using standard
 ; IDL.
 ;--------------------------------------------------------------------
 fn = module.install_fn
 if(NOT keyword_set(fn)) then return, udata

 nv_message, /continue, /anonymous, $
                  (update?'Updating':'Installing') + ' ' + strupcase(module.qname)
 *module.bridge_p = $
           call_function_bg(fg=keyword_set(fg), fn, args, udata=udata, $
                    callback='nv_module_install_callback', bridge=*module.bridge_p)

 return, 0
end
;=============================================================================



;==============================================================================
; nv_module_install
;
;  The purpose of this wrapper function is to ensure that the callback
;  function gets called any time _nv_module_install returns
;
;==============================================================================
pro nv_module_install, module, update=update, working_dir=working_dir, fg=fg, $
                                                      callback=callback, data=data

 udata = _nv_module_install(module, update=update, $
                   working_dir=working_dir, fg=fg, callback=callback, data=data)
 if(keyword_set(udata)) then $
          if(keyword_set(callback)) then $
                         nv_module_install_callback, -1, '', obj_new(), udata
end
;==============================================================================
