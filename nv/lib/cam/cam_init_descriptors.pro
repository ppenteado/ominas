;=============================================================================
;+
; NAME:
;	cam_init_descriptors
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
;	cd = cam_init_descriptors(n)
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
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
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
;	fn_data_p:	Array (n) of data pointers for each camera.
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
;	
;-
;=============================================================================
function cam_init_descriptors, n, crd=crd, bd=bd, cd=cd, $
@cam__keywords.include
end_keywords
@nv_lib.include

 if(NOT keyword_set(n)) then n = n_elements(cd)

 if(NOT keyword_set(cd)) then cd=replicate({camera_descriptor}, n)
 cd.class=decrapify(make_array(n, val='CAMERA'))
 cd.abbrev=decrapify(make_array(n, val='CAM'))

 if(keyword_set(scale)) then cd.scale=scale
 if(keyword_set(oaxis)) then cd.oaxis=oaxis
 if(keyword_set(exposure)) then cd.exposure=decrapify(exposure)

 if(keyword_set(fn_psf)) then cd.fn_psf = fn_psf

 if(keyword_set(filters)) then cd.filters[0:n_elements(filters)-1] = filters

 if(keyword_set(size)) then cd.size = size

 if(keyword_set(bd)) then cd.bd = bd $
 else cd.bd=bod_init_descriptors(n, crd=crd, $
@bod__keywords.include
end_keywords)

 if(keyword_set(fn_focal_to_image)) then $
                            cd.fn_focal_to_image=decrapify(fn_focal_to_image) $
 else cd.fn_focal_to_image = $
                     decrapify(make_array(n, val='cam_focal_to_image_linear'))

 if(keyword_set(fn_image_to_focal)) then $
                            cd.fn_image_to_focal=decrapify(fn_image_to_focal) $
 else cd.fn_image_to_focal = $
                      decrapify(make_array(n, val='cam_image_to_focal_linear'))

 if(keyword_set(fn_data_p)) then cd.fn_data_p=decrapify(fn_data_p)

 cdp = ptrarr(n)
 nv_rereference, cdp, cd



 return, cdp
end
;===========================================================================



