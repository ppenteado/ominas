;=============================================================================
;+
; NAME:
;	dsk_intersect_inertial
;
;
; PURPOSE:
;	Computes ray intersections with a DISK object, in inertial coordinates.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	v_int = dsk_intersect_inertial(dkx, v, r)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	v:	 Array (nv x 3 x nt) of column vectors giving the origins
;		 of the rays in the inertial frame.
;
;	r:	 Array (nv x 3 x nt) of column vectors giving the directions
;		 of the rays in the inertial frame.
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
;  OUTPUT: 
;	t:	Array(nv x 3 x nt) giving the distances to each intersection.
;		Values down each column are identical, i.e., this array
;		is a stack of three identical (nv x 1 x nt) arrays.
;
;	hit: 	Array giving the subscripts of the input rays that actually
;	 	intersect the disk. 
;
;
; RETURN:
;	Array (nv x 3 x nt) of column vectors giving the ray/disk
;	intersections in the inertial frame.  Note this if inertial
;	results are needed, this routine is slightly faster than
;	dsk_intersect.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dsk_intersect_inertial, dkxp, v, r, t=t, hit=hit, frame_bd=frame_bd
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1
 dkd = nv_dereference(dkdp)

 nt = n_elements(dkd)
 nv = (size(v))[1]


 p = bod_pos(dkd.bd)				; center of disk
 a = (bod_orient(dkd.bd))[2,*,*]		; disk normal

 t = v_inner(p - v, a)/v_inner(r, a)
 t = t[linegen3y(nv,3,nt)]
 vv = v + r*t


 ;---------------------------------------------------------------
 ; determine where intersection lies within radial limits
 ;---------------------------------------------------------------
 if(arg_present(hit)) then $
  begin
   vv_disk = dsk_body_to_disk(dkdp, $
               bod_inertial_to_body_pos(dkdp, vv), frame_bd=frame_bd)
   rad = dsk_get_radius(dkdp, vv_disk[*,1,*], frame_bd)
   hit = where((vv_disk[*,0,*] GT rad[*,0,*]) AND (vv_disk[*,0,*] LT rad[*,1,*]))

   ;-------------------------------------------
   ; disks with only one edge cannot be 'hit'
   ;-------------------------------------------
   mark = bytarr(nv, nt)
   if(hit[0] NE -1) then mark[hit] = 1

   sma = (dsk_sma(dkdp))[0,*,*]
   w = where((sma[0,0,*] EQ -1) OR (sma[0,1,*] EQ -1))
   if(w[0] NE -1) then mark[w] = 0

   hit = where(mark NE 0)
  end


 return, vv
end
;===========================================================================
