;===========================================================================
; glb_intersect_iter.pro
;
; Inputs and outputs are in BODY coordinates
;
; computes vectors at which rays with origins v(nv,3,nt) and directions
; r(nv,3,nt) intersect the globe.
;
; Returns array points(2*nv,3,nt), where points[0:nv-1,*,*] correspond to the 
; negative sign in the quadratic formula and points[nv:2*nv-1,*,1] correspond
; to the positive sign.  Zero vector is returned for points with no solution.
;
;===========================================================================
function glb_intersect_iter, gbxp, v, r, valid=valid, nosolve=nosolve
 gbdp = class_extract(gbxp, 'GLOBE')
@nv_lib.include

 ;----------------------------
 ; compute the discriminant
 ;----------------------------
 discriminant = glb_intersect_discriminant(gbdp, v, r, $
                                           alpha=alpha, beta=beta, gamma=gamma)

 ;----------------------------------
 ; compute the intersection points
 ;----------------------------------
 points = glb_intersect_points_iter(gbdp, v, r, alpha, beta, gamma, valid=valid, nosolve=nosolve)


 return, points
end
;===========================================================================
