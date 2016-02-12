;===========================================================================
; glb_intersect_points_iter.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; v and r must have same number of elements
;
; returned array is (2*nv,3,nt); 1st half is near points, 
;  2nd half is far points.
;
;===========================================================================
function glb_intersect_points_iter, gbdp, v, r, alpha, beta, gamma, $
         valid=valid, nosolve=nosolve, dbldbl=dbldbl
@nv_lib.include


 nt = n_elements(gbdp)
 nv = (size(v))[1]

 a = 0.5d*gamma
 b = beta
 c = 0.5d*(alpha - 1d)
 
 t = dblarr(nv, 2, nt)
 valid = bytarr(nv,1,nt)
 for i=0, nt-1 do $
  begin
   t[*,*,i] = quadsolve(a, b, c, valid=_valid, noroots=nosolve)
   valid[*,*,i] = _valid
  end

 ii = linegen3y(nv,3,nt)
 tclose = (t[*,0,*])[ii]
 tfar = (t[*,1,*])[ii]


 points = dblarr(2*nv,3,nt)

 sub = where(valid)
 if(sub[0] EQ -1) then return, points

 ww = colgen(nv,3,nt, sub)

 b = beta[sub]
 g = gamma[sub]

 pp = v[ww] + r[ww]*tclose
 qq = v[ww] + r[ww]*tfar

 points_close = dblarr(nv,3,nt)
 points_far = dblarr(nv,3,nt)
 points_close[ww] = pp
 points_far[ww] = qq

 points[0:nv-1,*,*] = points_close
 points[nv:*,*,*] = points_far


 return, points
end
;===========================================================================





;===========================================================================
; glb_intersect_points_iter.pro
;
; Inputs and outputs are in globe body coordinates.
;
; Points that do not intersect are returned as the zero vector.
;
; v and r must have same number of elements
;
; returned array is (2*nv,3,nt); 1st half is near points, 
;  2nd half is far points.
;
;===========================================================================
function ____glb_intersect_points_iter, gbdp, v, r, alpha, beta, gamma, valid=valid, nosolve=nosolve
@nv_lib.include
common glb_iti_block, a, b, c

 a = 0.5d*gamma
 b = beta
 c = 0.5d*(alpha - 1d)
 
 t = quadsolve(a, b, c, valid=valid, noroots=nosolve)

 points = dblarr(n_elements(a), 3, 2)

 ww = where(valid)
 if(ww[0] EQ -1) then return, points


 ii = make_array(3,val=1d)
 points[ww,*,0] = v[ww,*] + r[ww,*]*t[ww,0]#ii
 points[ww,*,1] = v[ww,*] + r[ww,*]*t[ww,1]#ii


 return, points
end
;===========================================================================
