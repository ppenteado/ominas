;==============================================================================
;+
; NAME:
;	arr_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source array descriptors into the
;       destination array descriptors.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	arr_copy_descriptor, arx_dst, arx_src
;
;
; ARGUMENTS:
;  INPUT:
;	arx_dst:	        Array (nt) of any subclass of ARRAY to copy to.
;
;	arx_src:	        Array (nt) of any subclass of ARRAY to copy from.
;
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
; RETURN: NONE
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
;==============================================================================
pro arr_copy_descriptor, ardp_dst, ardp_src, noevent=noevent
return, nv_copy, ardp_dst, ardp_src, noevent=noevent
@nv_lib.include
 nv_notify, ardp_src, type = 1, noevent=noevent
 ard_src = nv_dereference(ardp_src)
 ard_dst = nv_dereference(ardp_dst)

 new_ard = ard_src
 new_ard.bd = ard_dst.bd

 bod_copy_descriptor, new_ard.bd, arr_globe(ardp_src)

 nv_rereference, ardp_dst, new_ard
 nv_notify, ardp_dst, noevent=noevent
end
;==============================================================================



