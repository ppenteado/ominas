;=============================================================================
;+
; NAME:
;	dsk_reflect
;
;
; PURPOSE:
;	Computes ray reflections with a DISK object. 
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	v_int = dsk_reflect(dkd, v, r)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	v:	 Array (nv x 3 x nt) of column vectors giving the observer
;		 position in the body frame.
;
;	r:	 Array (nv x 3 x nt) of column vectors giving the source
;		 position in the body frame.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	hit: 	Array giving the subscripts of the input rays that actually
;	 	reflect on the disk. 
;
;
; RETURN:
;	Array (nv x 3 x nt) of column vectors giving the ray/disk
;	reflections in the body frame. 
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_reflect, dkd, v, r, hit=hit
@core.include
 

 nt = n_elements(dkd)
 nv = (size(v))[1]

 ;-----------------------------------------
 ; compute v, r projections in disk plane
 ;-----------------------------------------
 n = (bod_orient(dkd))[2,*,*]				; nv x 3 x nt

 vn = (v_inner(v,n))[linegen3y(nv,3,nt)]		; nv x 3 x nt
 rn = (v_inner(r,n))[linegen3y(nv,3,nt)]		; nv x 3 x nt

 vp = v + n*vn 						; nv x 3 x n
 rp = r + n*rn 						; nv x 3 x n



 ;--------------------------------------
 ; compute reflection points
 ;--------------------------------------
 vv = (v_mag(vn))[linegen3y(nv,3,nt)]			; nv x 3 x nt
 rr = (v_mag(rn))[linegen3y(nv,3,nt)]			; nv x 3 x nt
 p = vp + (rp-vp) * vv/(vv+rr)


 ;---------------------------------------------------------------
 ; determine where reflection lies within radial limits
 ;---------------------------------------------------------------
 if(arg_present(hit)) then $
  begin
   p_disk = dsk_body_to_disk(dkd, p)
   rad = dsk_get_radius(dkd, p_disk[*,1,*])
   hit = where((p_disk[*,0,*] GT rad[*,0,*]) AND (p_disk[*,0,*] LT rad[*,1,*]))

   ;-------------------------------------------
   ; disks with only one edge cannot be 'hit'
   ;-------------------------------------------
   mark = bytarr(nv, nt)
   if(hit[0] NE -1) then mark[hit] = 1

   sma = (dsk_sma(dkd))[0,*,*]
   w = where((sma[0,0,*] EQ -1) OR (sma[0,1,*] EQ -1))
   if(w[0] NE -1) then mark[w] = 0

   hit = where(mark NE 0)
  end



 return, p
end
;===========================================================================


