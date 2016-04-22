;===========================================================================
;+
; NAME:
;	dsk_surface_normal
;
;
; PURPOSE:
;	Computes the surface normal for a DISK object at the given 
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
;	v:	Array (nv,3) of observer positions in the BODY frame.
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
;	north:     If set, the retruned normals will be pointed north.  
;	           Otherwise, they point toward the observer's hemisphere.
;
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
function dsk_surface_normal, dkxp, v, r, frame_bd=frame_bd, noevent=noevent, north=north
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1, noevent=noevent
 dkd = nv_dereference(dkdp)

 nv = (size(r))[1]
 nt = n_elements(dkd)

 normal = dblarr(nv,3,nt)
 normal[*,2,*] = 1

 s = 1
 if(NOT keyword_set(north)) then  s = sign(transpose((sign(v[*,2,*]))[linegen3z(nv,nt,3)], [0,2,1]))

 return, s*normal
end
;=============================================================================
