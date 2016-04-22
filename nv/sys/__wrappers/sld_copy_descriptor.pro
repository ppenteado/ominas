;==============================================================================
;+
; NAME:
;	sld_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source solid descriptors into the
;       destination solid descriptors.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_copy_descriptor, slx_dst, slx_src
;
;
; ARGUMENTS:
;  INPUT:
;	slx_dst:	Array (nt) of any subclass of SOLID descriptors to copy to.
;
;	slx_src:	Array (nt) of any subclass of SOLID descriptors to copy from.
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
pro _sld_copy_descriptor, sldp_dst, sldp_src, noevent=noevent
 nv_notify, sldp_src, type = 1, noevent=noevent
 new_sld = nv_dereference(sldp_src)

 bod_copy_descriptor, new_sld.bd, sld_body(sldp_src)

 nv_rereference, sldp_dst, new_sld
 nv_notify, sldp_dst, noevent=noevent
end
;==============================================================================



;==============================================================================
; sld_copy_descriptor
;
;
;==============================================================================
pro sld_copy_descriptor, sldp_dst, sldp_src, noevent=noevent
return, nv_copy, sldp_dst, sldp_src, noevent=noevent
@nv_lib.include, noevent=noevent
 nv_notify, sldp_src, type = 1
 sld_src = nv_dereference(sldp_src)
 sld_dst = nv_dereference(sldp_dst)

 new_sld = sld_src
 new_sld.bd = sld_dst.bd

 bod_copy_descriptor, new_sld.bd, sld_body(sldp_src)

 nv_rereference, sldp_dst, new_sld
 nv_notify, sldp_dst, noevent=noevent
end
;==============================================================================



