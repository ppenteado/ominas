;=============================================================================
;+
; NAME:
;       cat_points
;
;
; PURPOSE:
;       To concatenate arrays of image points.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = cat_points(ps)
;
;
; ARGUMENTS:
;  INPUT:
;       ps:     An array of image point arrays.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Concatenated array of image points.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function cat_points, ps, flags_ps=flags_ps

 n_ps=n_elements(ps)

 ;----------------------------------
 ; set up concatenated points array
 ;----------------------------------
 n_points=0
 nn=intarr(n_ps)
 nnt=intarr(n_ps)
 ntot=intarr(n_ps)
 for i=0, n_ps-1 do $
  begin
   s=size(*ps[i])
   if(s[0] GE 2) then nn[i]=s[2] $
   else nn[i]=1
   if(s[0] EQ 3) then nnt[i]=s[3] $
   else nnt[i]=1

   ntot[i]=nn[i]*nnt[i]
  end
 n_points=total(ntot)

 points=dblarr(2,n_points,/nozero)


 ;----------------------------------
 ; populate the points array
 ;----------------------------------
 n=0
 for i=0, n_ps-1 do $
  begin
   points[0:1,n:n+nn[i]*nnt[i]-1]=(*ps[i])[0:1,*,*]
   n=n+nn[i]*nnt[i]
  end


 return, points
end
;===========================================================================
