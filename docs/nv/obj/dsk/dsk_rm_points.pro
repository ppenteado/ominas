;=============================================================================
;+
; NAME:
;	dsk_rm_points
;
;
; PURPOSE:
;	Removes points in front of or behind a DISK object.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	sub = dsk_rm_points(dkd, r, points)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	r:	 Column vector giving the position of the viewer in the disk
;		 body frame.
;
;	points:	 Array (nv x 3 x nt) of points to test, given in the disk
;		 body frame
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
;	Array Subscripts of all input vectors (points argument) that are hidden 
;	from the viewer at r by the given disk.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_rm_points, dkd, r, points
@core.include
 

 nt = n_elements(dkd)
 nv = (size(points))[1]

 rr = r[gen3y(nv,3,nt)]
 v = points-rr

 p = dsk_intersect(dkd, rr, v)

 p_rp = dsk_body_to_disk(dkd, p)
 rad = dsk_get_radius(dkd, p_rp[*,1,*])

 sub = where(p_rp[*,0,*] GE rad[*,0,*] AND p_rp[*,0,*] LE rad[*,1,*])

 return, sub
end
;===========================================================================
