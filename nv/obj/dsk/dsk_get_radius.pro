;=============================================================================
;+
; NAME:
;	dsk_get_radius
;
;
; PURPOSE:
;	Computes radii along the iner and outer edges of a disk.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	r = dsk_get_radius(dkd, lon, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	lon:	 Array (nlon) of longitudes at which to compute radii.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkd.
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
;	Array (nlon x 2 x nt) of radii computed at each longitude on each 
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
function dsk_get_radius, dkd, dlon, frame_bd
@core.include

 r_inner = dsk_get_edge_radius(dkd, dlon, frame_bd, /inner)
 r_outer = dsk_get_edge_radius(dkd, dlon, frame_bd, /outer)

 s = size(r_inner)
 nt = n_elements(dkd)
 nv = n_elements(r_inner)/nt

 r = dblarr(nv,2,nt)
 r[*,0,*] = r_inner
 r[*,1,*] = r_outer

 return, r
end
;===========================================================================
