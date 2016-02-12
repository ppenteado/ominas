;===========================================================================
;+
; NAME:
;	dsk_surface_normal
;
;
; PURPOSE:
;	Computes the surface normals of a DISK object at the given 
;	body-frame positions.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	n = dsk_surface_normal(dkx, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	Array (nt) of any subclass of DISK descriptors.
;
;	r:	Array (nv,3) of surface positions in the BODY frame.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	frame_bd:  Frame descriptor.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (nv, 3, nt) of surface unit normals in the BODY frame.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
function dsk_surface_normal, dkxp, r, frame_bd=frame_bd
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1
 dkd = nv_dereference(dkdp)


 nv = (size(r))[1]
 nt = n_elements(dkd)

v = (bod_orient(dkdp))[2,*,*]##make_array(nv,val=1d)
;stop
;v_inner(bod_pos(dkdp)##make_array(nv,val=1d),v)
; need to consider which side you're on
return, v

; need to account for inclination
end
;=============================================================================
