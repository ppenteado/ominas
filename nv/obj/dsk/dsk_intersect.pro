;=============================================================================
;+
; NAME:
;	dsk_intersect
;
;
; PURPOSE:
;	Computes ray intersections with a DISK object. 
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	v_int = dsk_intersect(dkd, v, r)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	v:	 Array (nv x 3 x nt) of column vectors giving the origins
;		 of the rays in the body frame.
;
;	r:	 Array (nv x 3 x nt) of column vectors giving the directions
;		 of the rays in the body frame.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	t:	Array(nv x 3 x nt) giving the distances to each intersection.
;		Values down each column are identical, i.e., this array
;		is a stack of three identical (nv x 1 x nt) arrays.
;
;	hit: 	Array giving the subscripts of the input rays that actually
;	 	intersect the disk. 
;
;	miss: 	Array giving the subscripts of the input rays that do not
;	 	intersect the disk. 
;
;
; RETURN:
;	Array (nv x 3 x nt) of column vectors giving the ray/disk
;	intersections in the body frame. 
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_intersect, dkd, v, r, t=t, hit=hit, miss=miss
@core.include
 

 nt = n_elements(dkd)
 nv = (size(v))[1]

 ;--------------------------------------
 ; compute intersection with disk plane
 ;--------------------------------------
 sub = linegen3y(nv,3,nt)
 vz = (v[*,2,*])[sub]
 rz = (r[*,2,*])[sub]

 t = - vz/rz
 vv = v + r*t

 ;---------------------------------------------------------------
 ; determine where intersection lies within radial limits
 ;---------------------------------------------------------------
 if(arg_present(hit) OR arg_present(miss)) then $
  begin
   vv_disk = dsk_body_to_disk(dkd, vv)
   rad = dsk_get_radius(dkd, vv_disk[*,1,*])
   hit = where((vv_disk[*,0,*] GT rad[*,0,*]) AND (vv_disk[*,0,*] LT rad[*,1,*]))

   ;-------------------------------------------
   ; disks with only one edge cannot be 'hit'
   ;-------------------------------------------
   mark = bytarr(nv, nt)
   if(hit[0] NE -1) then mark[hit] = 1
 
   w = where(t[*,0] LT 0)
   if(w[0] NE -1) then mark[w] = 0

   sma = (dsk_sma(dkd))[0,*,*]
   w = where((sma[0,0,*] EQ -1) OR (sma[0,1,*] EQ -1))
   if(w[0] NE -1) then mark[w] = 0

   hit = where(mark NE 0)
   miss = where(mark EQ 0)
  end


 return, vv
end
;===========================================================================


;===========================================================================
; dsk_intersect.pro
;
; Inputs and outputs are in disk body coordinates
;
; computes vectors at which rays with origins v and directions r intersect
; the ringplane.
;
;===========================================================================
function _dsk_intersect, dkd, v, r, t=t, hit=hit
@core.include
 

 ntt = n_elements(dkd)
 nv = (size(v))[1]

 ;-----------------------------------------
 ; remove disks with only one edge
 ;-----------------------------------------
 sma = (dsk_sma(dkd))[0,*,*]
 w = where((sma[0,0,*] NE -1) AND (sma[0,1,*] NE -1))
 hit = -1
 vvv = dblarr(nv, 3, ntt)


 ;---------------------------------------------------
 ; do the calc for finite disks
 ;---------------------------------------------------
 if(w[0] NE -1) then $
  begin
   dkd = dkd[w]
   nt = n_elements(dkd)

   ;--------------------------------------
   ; compute intersection with disk plane
   ;--------------------------------------
   sub = linegen3y(nv,3,nt)
   vz = (v[*,2,*])[sub]
   rz = (r[*,2,*])[sub]

   t = - vz/rz
   vv = v + r*t

   ;---------------------------------------------------------------
   ; determine where intersection lies within radial limits
   ;---------------------------------------------------------------
   if(arg_present(hit)) then $
    begin
     vv_disk = dsk_body_to_disk(dkd, vv)
     rad = dsk_get_radius(dkd, vv_disk[*,1,*])
     hit = where((vv_disk[*,0,*] GT rad[*,0,*]) AND (vv_disk[*,0,*] LT rad[*,1,*]))
    end

   ;---------------------------------------------------
   ; reform results to match original inputs
   ;---------------------------------------------------
   vvv[*,*,w] = vv

   mark = bytarr(nv, nt)
   if(hit[0] NE -1) then mark[hit] = 1
   mark1 = bytarr(nv, ntt)
   mark1[*,w] = mark
   hit = where(mark1 NE 0)
  end

 return, vvv
end
;===========================================================================



