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

 cam_get_juno_epo_matrices, cd, k1, k2, x0, y0

 camv = v
 cami = camv
 x2=cami[0,*]*cami[0,*]
 y2=cami[1,*]*cami[1,*]
 r2=x2+y2
 dr=1+k1[0]*r2+k2[0]*r2*r2
 x2=x2*dr+x0[0]
 y2=y2*dr+y0[0]
 cami=[x2,y2]
 
 v=cami
 
 return, v
; return, poly_transform(PP, QQ, double(v))
end
;===========================================================================



