;==============================================================================
;+
; NAME:
;	stn_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source station descriptors into the
;       destination station descriptors.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	stn_copy_descriptor, stx_dst, stx_src
;
;
; ARGUMENTS:
;  INPUT:
;	stx_dst:	        Array (nt) of any subclass of STATION to copy to.
;
;	stx_src:	        Array (nt) of any subclass of STATION to copy from.
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
pro stn_copy_descriptor, stdp_dst, stdp_src
@nv_lib.include
 nv_notify, stdp_src, type = 1
 std_src = nv_dereference(stdp_src)
 std_dst = nv_dereference(stdp_dst)

 new_std = std_src
 new_std.bd = std_dst.bd

 bod_copy_descriptor, new_std.bd, stn_globe(stdp_src)

 nv_rereference, stdp_dst, new_std
 nv_notify, stdp_dst
end
;==============================================================================



