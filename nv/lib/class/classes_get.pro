;=============================================================================
;+
; NAME:
;	classes_get
;
;
; PURPOSE:
;	Returns the names of object classes for an inhomogeneous array of
;	object descriptors.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	classes = classes_get(od)
;
;
; ARGUMENTS:
;  INPUT:
;	od:	 Inhomogeneous array of descriptors.
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
;	String array giving the names of the object classes.
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
function classes_get, odp, class
 nv_notify, odp, type = 1

 if(NOT keyword_set(odp)) then return, 0

 n = n_elements(odp)
 classes = strarr(n)

 for i=0, n-1 do $
  begin
   od = nv_dereference(odp[i])
   classes[i] = od.class
  end

 return, classes
end
;===========================================================================
