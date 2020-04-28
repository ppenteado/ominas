;==============================================================================
;+
; NAME:
;	nv_get_module
;
;
; PURPOSE:
;	Retrieves a module by name.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	module = nv_module_add(arg)
;
;
; ARGUMENTS:
;  INPUT:
;	arg:		Fully qualified name or abbreviation.  If not given,
;			'OMINAS' is assumed.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	all:		If set, all modules beneasth the spcified module
;			are returned.
;
;	siblings:	If set, all sibling modules are returned (including
;			the input module) in the order specified by the ORDER 
;			property of the parent.
;
;  OUTPUT: NONE
;
;
; RETURN:  Module structure or !null if none found.
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
function ___nv_get_module, arg, all=all, siblings=siblings
@nv_block.common

 modules = *nv_state.modules_p
 if(NOT keyword_set(modules)) then return, !null

 if(keyword_set(all)) then return, modules
 if(NOT keyword_set(arg)) then arg = 'ominas'

 w = (where(modules.qbbr EQ strlowcase(arg)))[0]
 if(w[0] NE -1) then return, modules[w]

 w = (where(modules.qname EQ strlowcase(arg)))[0]
 if(w[0] NE -1) then return, modules[w]

 return, !null
end
;=============================================================================



;==============================================================================
; nvgm_descend
;
;
;==============================================================================
function nvgm_descend, module

 modules = nv_get_submodules(module)
 if(NOT keyword_set(modules)) then return, !null
  
 for i=0, n_elements(modules)-1 do $
     modules = append_array(modules, nvgm_descend(modules[i]))

 return, modules
end
;=============================================================================



;==============================================================================
; nv_get_module
;
;
;==============================================================================
function nv_get_module, arg, all=all, siblings=siblings
@nv_block.common

 modules = *nv_state.modules_p
 if(NOT keyword_set(modules)) then return, !null
 if(NOT keyword_set(arg)) then arg = 'ominas'

 w = (where(modules.qbbr EQ strlowcase(arg)))[0]
 if(w[0] NE -1) then module = modules[w] $
 else $
  begin
   w = (where(modules.qname EQ strlowcase(arg)))[0]
   if(w[0] NE -1) then module = modules[w]
  end
 if(NOT keyword_set(module)) then return, !null

 if(keyword_set(all)) then return, nvgm_descend(module)

 return, module
end
;=============================================================================
