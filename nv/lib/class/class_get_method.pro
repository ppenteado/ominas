;=============================================================================
;+
; NAME:
;	class_get_method
;
;
; PURPOSE:
;	Searches the object tree for a method corresponding to the 
;	corresponding string.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	fm = class_get_method(xd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	 Descriptor of any class. 
;
;	name:    Name of method, without class prefix.
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
;	Method name.
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
function class_get_method, xdp, name, noevent=noevent
 nv_notify, xdp, type = 1, noevent=noevent
 if(NOT keyword_set(xdp)) then return, 0

 xd = *xdp

 repeat $
  begin
   method = strlowcase(xd.abbrev+name)
   if(routine_exists(method)) then return, method
   xd = *(xd).(0)
  endrep until(xd.class EQ 'CORE')


 return, ''
end
;===========================================================================
