;==============================================================================
;+
; NAME:
;	nv_module_query
;
;
; PURPOSE:
;	Queries the installation status of a user module.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	status = nv_module_query(module)
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
;	property:	Name of a generic property to be queried in the 
;			properties file.  This input supercedes the
;			other query inputs.
;
;	installed:	Query whether module is installed.  The module
;			is assumed to be installed if there is no install 
;			method.
;
;	active:		Query whether module is active.
;
;	suppressed:	Query wether module is suppressed.
;
;	activate:	Query whether the module should activated by default.
;
;	locked:		Query whether module is locked, i.e., cannot be 
;			deactivated).
;
;	protected:	Query whether the module is protected, i.e., cannot 
;			be uninstalled.
;
;	installing:	Query whether the module is currently being installed
;			in the background.
;
;  OUTPUT: NONE
;
;
; RETURN:  1 if the condition is met, 0 if not, 2 if query function not 
;          found.
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
; nvmq_query
;
;==============================================================================
function nvmq_query, module, args

 if(NOT keyword_set(module.query_fn)) then $
  begin
   nv_message, verb=0.5, 'No method: ' + module.query_fn
   return, 2
  end

 return, call_function(module.query_fn, args)
end
;==============================================================================



;==============================================================================
; nv_module_query
;
;==============================================================================
function nv_module_query, module, property=property,$
    installed=installed, active=active, activate=activate, locked=locked, $
    protected=protected, broken=broken, installing=installing, suppressed=suppressed

 profile_dir = nv_module_get_profile_dir(module)
 setup_file = file_search(profile_dir + '/setup.sh')

 ;----------------------------------------------------------
 ; query generic property
 ;----------------------------------------------------------
 if(keyword_set(property)) then return, nv_module_get_property(module, property)

 ;----------------------------------------------------------
 ; query whether currently installing
 ;----------------------------------------------------------
 if(keyword_set(installing)) then $
  begin
   bridge = *module.bridge_p
   if(NOT keyword_set(bridge)) then return, 0
   status = bridge->Status()
   return, status EQ 1
  end

 ;----------------------------------------------------------
 ; query suppressed
 ;----------------------------------------------------------
 if(keyword_set(suppressed)) then return, keyword_set(getenv(module.vname+'_SUPPRESS'))

 ;----------------------------------------------------------
 ; query active
 ;----------------------------------------------------------
 if(keyword_set(active)) then return, keyword_set(setup_file)

 ;----------------------------------------------------------
 ; query activate
 ;----------------------------------------------------------
 if(keyword_set(activate)) then $
                         return, nv_module_get_property(module, 'activate')

 ;----------------------------------------------------------
 ; query locked
 ;----------------------------------------------------------
 if(keyword_set(locked)) then return, nv_module_get_property(module, 'locked')

 ;----------------------------------------------------------
 ; query exclusive
 ;----------------------------------------------------------
 if(keyword_set(exclusive)) then $
                        return, nv_module_get_property(module, 'exclusive')

 ;----------------------------------------------------------
 ; query broken
 ;----------------------------------------------------------
 if(keyword_set(broken)) then return, keyword_set(file_search(module.working_dir))

 ;----------------------------------------------------------------------------
 ; if no install method or PROTECTED property set, the module is protected
 ;----------------------------------------------------------------------------
 if(keyword_set(protected)) then $
  begin
   if(NOT keyword_set(module.install_fn)) then return, 1
   return, nv_module_get_property(module, 'protected')
  end

 ;----------------------------------------------------------
 ; if no install method, the module is considered installed 
 ; otherwise, check for the presence of a data directory
 ;----------------------------------------------------------
 if(keyword_set(installed)) then $
  begin
   if(NOT keyword_set(module.install_fn)) then return, 1
   return, keyword_set(file_search(module.data_dir, /test_dir))
  end

 ;----------------------------------------------------------
 ; other future queries might call the query function...
 ;----------------------------------------------------------
 if(keyword_set(blah)) then $
  begin
   args = {dir: 	       module.data_dir, $
	   method_dir:         module.method_dir, $
	   query_something:    1 $
	 }
   return, nvmq_query(module, args)
  end

end
;=============================================================================



