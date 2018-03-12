;===========================================================================
;+
; NAME:
;	cam_image_to_focal_juno_epo
;
;
; PURPOSE:
;       Transforms the given array of points in the image coordinate
;       system to an array of points in the camera focal plane
;       coordinate system using JunoCam distortion model.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	focal_pts = cam_image_to_focal_poly(cd, image_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	        Array (nt) of CAMERA descriptors.
;
;	image_pts:	Array (2,nv,nt) of points in the image coordinate system.
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
;       Array (2,nv,nt) of points in the camera focal frame.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function cam_image_to_focal_juno_epo, cd, v
@core.include

 cam_get_juno_epo_matrices, cd, k1, k2, cx, cy, fl

 camvx= v[0,*] - cx[0]
 camvy= v[1,*] - cy[0]
 camv=[camvx,camvy]
 cami = camv
 xx=cami[0,*]
 yy=cami[1,*]
 FOR i=0,4 DO BEGIN
  x2=xx*xx
  y2=yy*yy
  r2=x2+y2
  dr=1+k1[0]*r2+k2[0]*r2*r2
  xx=cami[0,*]/dr
  yy=cami[1,*]/dr
 ENDFOR

 cami=[xx,yy]
 s=size(xx)
 
 v=[cami[0,*],cami[1,*],fl[0]*make_array(s[1],val=1)]
 
 return, v
; return, poly_transform(PP, QQ, double(v))
end
;===========================================================================



