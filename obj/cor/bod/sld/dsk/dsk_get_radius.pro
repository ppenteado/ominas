;=============================================================================
;+
; NAME:
;	dsk_get_radius
;
;
; PURPOSE:
;	Computes radii along the inner and outer edges of a disk.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	r = dsk_get_radius(dkd, ta, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	ta:	 Array (nv x nt) of true anomalies at which to compute radii.
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
; RETURN:
;	Array (nv x 2 x nt) of radii computed at each true anomaly on each 
;	disk.
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
function dsk_get_radius, dkd, ta
@core.include

 r_inner = dsk_get_edge_radius(dkd, ta, /inner)
 r_outer = dsk_get_edge_radius(dkd, ta, /outer)

 s = size(r_inner)
 nt = n_elements(dkd)
 nv = n_elements(r_inner)/nt

 r = dblarr(nv,2,nt)
 r[*,0,*] = r_inner
 r[*,1,*] = r_outer

 return, r
end
;===========================================================================
