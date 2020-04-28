;==============================================================================
;+
; NAME:
;	nv_module_add
;
;
; PURPOSE:
;	Adds a new user module to the module database.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	module = nv_module_add(parent, abbr)
;
;
; ARGUMENTS:
;  INPUT:
;	abbr:		Abbreviated name of module.
;
;	dir:		Module code directory.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	parent:		Parent module.  If none given, all current modules 
;			are deleted.
;	
;  OUTPUT: NONE
;
;
; RETURN:  Module structure.
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
function nv_module_add, abbr, dir, parent=parent
@nv_block.common

 ;------------------------------------------------------------------
 ; reset module database if no parent given
 ;------------------------------------------------------------------
 if(NOT keyword_set(parent)) then *nv_state.modules_p = 0

 ;------------------------------------------------------------------
 ; get module database
 ;------------------------------------------------------------------
 modules = *nv_state.modules_p

 ;------------------------------------------------------------------
 ; get module description
 ;------------------------------------------------------------------
 description = nv_module_read_description(dir, abbr, name=name)

 ;------------------------------------------------------------------
 ; construct various names
 ;------------------------------------------------------------------
 qname0 = keyword_set(parent) ? parent.qname : ''
 qbbr0 = keyword_set(parent) ? parent.qbbr : ''
 qname = nv_module_qualified_name(qname0, name)
 qbbr = nv_module_qualified_name(qbbr0, abbr)
 apiname = nv_module_api_name(qname)
 apibbr = nv_module_api_name(qbbr)
 vname = 'OMINAS_' + strupcase(apibbr)

 ;------------------------------------------------------------------
 ; set up directories and files
 ;------------------------------------------------------------------
 ominas_data = getenv('OMINAS_DATA')
 if(NOT keyword_set(ominas_data)) then $
     nv_message, 'OMINAS_DATA environment variable not defined.'
 data_dir = ominas_data + '/' + strep_char(apibbr, '_', '/')
 working_dir = file_dirname(data_dir) + '/_' + file_basename(data_dir)
 profile_dir = strep_char(qbbr, '.', '/')
 method_dir = dir + '/module'

 ;------------------------------------------------------------------
 ; find submodules
 ;------------------------------------------------------------------
 abbr_sub = nv_module_search(dir, dirs=dirs_sub)

 ;------------------------------------------------------------------
 ; populate module structure and add to database
 ;------------------------------------------------------------------
 if(NOT keyword_set(parent)) then parent = 0
 module = $
    {nv_module, $
	initialized:		0, $			; Initialization flag
	parent_p:		ptr_new(parent), $	; Parent module
	abbr:			strlowcase(abbr), $	; Module abbreviation
	qbbr:			strlowcase(qbbr), $	; Module fully qualified abbreviation
	apibbr:			strlowcase(apibbr), $	; Abbreviation for use in API
	name:			strlowcase(name), $	; Module name
	vname:			vname, $		; Module environment name
	qname:			strlowcase(qname), $	; Module fully qualified name
	apiname:		strlowcase(apiname), $	; Name for use in API
	submodules_p:		ptr_new(0), $		; Submodules
	dir:			dir, $			; Module code directory
	method_dir:		method_dir, $		; Module method directory
	data_dir:		data_dir, $		; Module data directory; from profile root
	working_dir:		working_dir, $		; Module working data directory; from profile root
	profile_dir:		profile_dir, $		; Module profile directory
	install_fn:		'', $			; Install method name
	uninstall_fn:		'', $			; Uninstall method name
	update_fn:		'', $			; Update method name
	init_fn:		'', $			; Init method name
	activate_fn:		'', $			; Activation method name
	deactivate_fn:		'', $			; Deactivation method name
	query_fn:		'', $			; Query method name
	udata_tlp:		ptr_new(''), $		; User data
	bridge_p:		ptr_new(), $		; Bridge to installation process
	description_p:		ptr_new(description) $	; Module description text
    }

 ;------------------------------------------------------------------
 ; get methods
 ;------------------------------------------------------------------
 module.install_fn = nv_module_get_fn(module, 'install')
 module.uninstall_fn = nv_module_get_fn(module, 'uninstall')
 module.update_fn = nv_module_get_fn(module, 'update')
 module.init_fn = nv_module_get_fn(module, 'init')
 module.query_fn = nv_module_get_fn(module, 'query')
 module.bridge_p = nv_ptr_new(0)

 ;------------------------------------------------------------------
 ; call module init method
 ;------------------------------------------------------------------
 nv_module_init, module

 ;------------------------------------------------------------------
 ; add to module database
 ;------------------------------------------------------------------
 modules = append_array(modules, module)
 *nv_state.modules_p = modules

 ;------------------------------------------------------------------
 ; add any submodules
 ;------------------------------------------------------------------
 if(keyword_set(abbr_sub)) then $
  begin
   for i=0, n_elements(abbr_sub)-1 do $
      submodules = append_array(submodules, $
              nv_module_add(parent=module, abbr_sub[i], dirs_sub[i]))

   *module.submodules_p = submodules
  end

 return, module
end
;=============================================================================
