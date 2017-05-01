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
;	pg_crop_points, cd, ptd
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	POINT object containing points to be cropped.
;
;  OUTPUT:
;	ptd:	The input POINT object is modified.
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
;	The given POINT object is modified.
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
pro pg_crop_points, ptd, cd=cd, slop=slop, indices=ww
@pnt_include.pro

 if(NOT keyword_set(slop)) then slop = 1
 n = n_elements(ptd)

 ;------------------------------------------------
 ; hide external points
 ;------------------------------------------------
 for i=0, n-1 do if(obj_valid(ptd[i])) then $
  begin
   pnt_query, ptd[i], p=p, f=f
   ww = in_image(cd, p, slop=slop)
   w = complement(p[0,*], ww)

   if(w[0] NE -1) then $
    begin
     f[w] = f[w] OR PTD_MASK_INVISIBLE
     pnt_assign, ptd[i], p=p, f=f
    end
  end


end
;=============================================================================



