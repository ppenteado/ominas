;=============================================================================
;+
; NAME:
;	dsk_body_to_disk
;
;
; PURPOSE:
;	Transforms vectors from the body coordinate system to the disk
;	coordinate system.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	v_disk = dsk_body_to_disk(dkd, v_body)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	v_body:	 Array (nv x 3 x nt) of column vectors in the body 
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
;	Array (nv x 3 x nt) of column vectors in the disk coordinate system.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_body_to_disk, dkd, v
@core.include
 
 sv = size(v)
 nv = sv[1]
 nt = n_elements(dkd)

 ;------------------------------------------
 ; new coordinates
 ;------------------------------------------
 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = sqrt(v[*,0,*]^2 + v[*,1,*]^2)		; radius
 result[*,1,*] = atan(v[*,1,*], v[*,0,*])		; true anomaly
 result[*,2,*] = v[*,2,*]				; altitude

 ;------------------------------------------
 ; apply radial scale
 ;------------------------------------------
 result[*,0,*] = dsk_apply_scale(dkd, result[*,0,*])

 return, result
end
;===========================================================================



