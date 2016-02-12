;=============================================================================
;+
; NAME:
;	class_get_tree
;
;
; PURPOSE:
;	Builds a class tree for te givern descriptor.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	classes = class_get_tree(od)
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
;	
;-
;=============================================================================
function class_get_tree, odp
 od = nv_dereference(odp)

 repeat $
  begin
   classes = append_array(classes, od.class)
   if(size(od[0].(0), /type) NE 10) then return, classes
   od = *(od[0].(0))
  endrep until(0)

end
;===========================================================================



