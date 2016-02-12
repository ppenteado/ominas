;=============================================================================
;++
; NAME:
;	pg_crop_points
;
;
; PURPOSE:
;	Hides image points that lie outside the field of view.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_crop_points, cd, ps
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	points_struct containing points to be cropped.
;
;  OUTPUT:
;	ps:	The input points structure is modified.
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Camera descriptor, used to determine image dimenesions.
;
;	slop:	Number of pixels outside image to include.  Defautl is 1.
;
;  OUTPUT:
;	indices: Indices of retained points.
;
;
; RETURN:
;	NONE
;
;
; RESTRICTIONS:
;	The given points structure is modified.
;
;
; STATUS:
;	xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale; 5/2005
;	
;-
;=============================================================================
pro pg_crop_points, ps, cd=cd, slop=slop, indices=ww
@ps_include.pro

 if(NOT keyword_set(slop)) then slop = 1
 n = n_elements(ps)

 ;------------------------------------------------
 ; hide external points
 ;------------------------------------------------
 for i=0, n-1 do $
  begin
   ps_get, ps[i], p=p, f=f
   ww = in_image(cd, p, slop=slop)
   w = complement(p[0,*], ww)

   if(w[0] NE -1) then $
    begin
     f[w] = f[w] OR PS_MASK_INVISIBLE
     ps_set, ps[i], p=p, f=f
    end
  end


end
;=============================================================================



