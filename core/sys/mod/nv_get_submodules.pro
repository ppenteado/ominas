;==============================================================================
;+
; NAME:
;	nv_get_submodules
;
;
; PURPOSE:
;	Returns submodules of an OMINAS module in the order specified
;	by the ORDER property of the parent.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	submodules = nv_get_submodules(module)
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
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:  Array of modules, 0 if none exist.
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
function nv_get_submodules, module

 ;------------------------------------------------
 ; get submodules
 ;------------------------------------------------
 submodules = *module.submodules_p
 if(NOT keyword_set(submodules)) then return, !null

 n = n_elements(submodules)
 if(n EQ 1) then return, submodules

 ;------------------------------------------------
 ; reorder submodules
 ;------------------------------------------------
 order = nv_module_get_property(module, 'ORDER')
 if(NOT keyword_set(order)) then return, submodules

 w = nwhere1(submodules.abbr, strlowcase(order))
 return, submodules[w]
end
;=============================================================================
