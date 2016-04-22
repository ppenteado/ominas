;===========================================================================
;+
; NAME:
;	bod_set_array
;
;
; PURPOSE:
;	Replaces the array for the given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_array, bx, array
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 BODY descriptor.
;
;	array:	 Array of points in the body frame.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2012
;	
;-
;===========================================================================
pro bod_set_array, bxp, tag, array, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 tlp = bd.arrays_tlp
 tag_list_set, tlp, tag, array
 bd.arrays_tlp = tlp

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0, noevent=noevent
end
;===========================================================================



