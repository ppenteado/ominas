;=============================================================================
;+
; NAME:
;	cor_tree
;
;
; PURPOSE:
;	Builds a class tree for te given descriptor.
;
;
; CATEGORY:
;	NV/SYS/COR
;
;
; CALLING SEQUENCE:
;	classes = cor_tree(od)
;
;
; ARGUMENTS:
;  INPUT:
;	od:	 Descriptor of any class.
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
; RETURN:
;	String array giving the names of all classes in od, in descending order.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_tree, od
@core.include

 class = cor_class(od)
 repeat $
  begin
   super = cor_class(od, /super)
   classes = append_array(classes, class)
   if(class EQ 'CORE') then return, classes
   ;stat = execute('od = obj_new("' + super[0] + '", 1)')
   od=obj_new(super[0],1)
   class = super
  endrep until(0)

end
;===========================================================================



