;==============================================================================
;+
; NAME:
;	nv_module_set_position
;
;
; PURPOSE:
;	Sets the position of a module relative to its siblings.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_set_position, module, pos
;
;
; ARGUMENTS:
;  INPUT:
;	module:		Module structure.
;
;	pos:		New position index.  Indices of sibling modules 
;			are adjusted accordingly.
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
pro nv_module_set_position, module, pos

 parent = *module.parent_p
 if(NOT keyword_set(parent)) then return

 order = nv_module_get_property(parent, 'ORDER')
 if(NOT keyword_set(order)) then $
  begin
   parent = *module.parent_p
   if(NOT keyword_set(parent)) then return
   modules = *parent.submodules_p
   order = modules.abbr
  end
 order = strlowcase(order)

 pos0 = where(order EQ module.abbr)
 order = mv_list_item(order, pos0, pos)

 nv_module_set_property, parent, 'ORDER', order
end
;=============================================================================
