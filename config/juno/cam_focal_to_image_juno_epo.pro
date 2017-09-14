;===========================================================================
;+
; NAME:
;	cam_focal_to_image_juno_epo
;
;
; PURPOSE:
;       Transforms the given array of points in the camera focal plane
;       coordinate system to an array of points in the image
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
function cam_focal_to_image_juno_epo, cd, v
@core.include

 cam_get_juno_epo_matrices, cd, k1, k2, cx, cy, fl

; camv = v
 camv = transpose(cam_focal_to_body(cd, v))
 ; camv is 3D vecor with columns X,Z,Y
 alpha = camv[1,*]/fl[0]
 cami = camv[0:2:2,*]
 xx=cami[0,*]/alpha
 yy=cami[1,*]/alpha
 x2=xx*xx
 y2=yy*yy
 r2=x2+y2
 dr=1+k1[0]*r2+k2[0]*r2*r2
; print,dr[0],dr[25600/2],dr[25600-1]
 xx=xx*dr+cx[0]
 yy=yy*dr+cy[0]
 cami=[xx,yy]
 
 v=cami
 
 return, v
; return, poly_transform(PP, QQ, double(v))
end
;===========================================================================



