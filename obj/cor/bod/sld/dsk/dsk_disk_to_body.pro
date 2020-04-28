;=============================================================================
;+
; NAME:
;	dsk_disk_to_body
;
;
; PURPOSE:
;	Transforms vectors from the disk coordinate system to the body
;	coordinate system.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	v_body = dsk_disk_to_body(dkd, v_dsk)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	v_disk:	 Array (nv x 3 x nt) of column vectors in the disk
;		 coordinate system.
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
;	Array (nv x 3 x nt) of column vectors in the body coordinate system.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_disk_to_body, dkd, v
@core.include
 
 sv = size(v)
 nv = sv[1]
 nt = n_elements(dkd)

 ;------------------------------------------
 ; new coordinates
 ;------------------------------------------
 rad = v[*,0,*]
 ta = v[*,1,*]

 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = rad*cos(ta)
 result[*,1,*] = rad*sin(ta)
 result[*,2,*] = v[*,2,*]

 ;------------------------------------------
 ; apply radial scale
 ;------------------------------------------
 result[*,0,*] = dsk_apply_radial_scale(dkd, result[*,0,*], /inverse)

 return, result
end
;===========================================================================



