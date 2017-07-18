;=============================================================================
;+
; NAME:
;	cam_create_descriptors
;
;
; PURPOSE:
;	Init method for the CAMERA class.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cd = cam_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	Number of descriptors to create.
;
;  OUTPUT: NONE
;
;
; KEYWORDS (in addition to those accepted by all superclasses):
;  INPUT:  
;	cd:	Camera descriptor(s) to initialize, instead of creating a new 
;		one.
;
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
;
;	scale:	Array (2,n) of scales for each camera.
;
;	oaxis:	Array (2,n) of optic axis values for each camera.
;
;	exposure:	Array (n) of exposure times for each camera.
;
;	size:	Array (2,n) of sizes for each camera.
;
;	filters:	Array (nfilt,n) of filter names for each camera.
;
;	fn_focal_to_image:	Array (n) of focal-to-image function names 
;				for each camera.
;
;	fn_image_to_focal:	Array (n) of image-to-focal function names 
;				for each camera.
;
;	fn_psf:	Array (n) of point-spread function names for each camera.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized camera descriptors, depending
;	on the presence of the cd keyword.
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
;=============================================================================
function cam_create_descriptors, n, crd=_crd0, bd=_bd0, cd=_cd0, $
@cam__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 cd = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]
   if(keyword_set(_bd0)) then bd0 = _bd0[i]
   if(keyword_set(_cd0)) then cd0 = _cd0[i]

   cd[i] = ominas_camera(i, crd=crd0, bd=bd0, cd=cd0, $
@cam__keywords.include
end_keywords)

  end
 

 return, cd
end
;===========================================================================



