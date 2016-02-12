;=============================================================================
;+
; NAME:
;	dsk_rm_points
;
;
; PURPOSE:
;	Removes points infront of or behind a DISK object.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	sub = dsk_rm_points(dkx, r, points)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Array (nt) of any subclass of DISK.
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
;  INPUT: 
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.
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
;	
;-
;=============================================================================
function dsk_rm_points, dkxp, r, points, frame_bd=frame_bd
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')

 nt = n_elements(dkdp)
 nv = (size(points))[1]

 rr = r[gen3y(nv,3,nt)]
 v = points-rr

 p = dsk_intersect(dkdp, rr, v, frame_bd=frame_bd)

 p_rp = dsk_body_to_disk(dkdp, p, frame_bd=frame_bd)
 rad = dsk_get_radius(dkdp, p_rp[*,1,*], frame_bd)

 sub = where(p_rp[*,0,*] GE rad[*,0,*] AND p_rp[*,0,*] LE rad[*,1,*])

 return, sub
end
;===========================================================================
