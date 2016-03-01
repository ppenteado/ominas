;=============================================================================
;+
; NAME:
;	camera_descriptor__define
;
;
; PURPOSE:
;	Class structure fo the CAMERA class.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	bd:	BODY class descriptor.  
;
;		Methods: cam_body, cam_set_body
;
;
;	scale:	2-element array giving the camera scale (radians/pixel) in 
;		each direction.  The meaning of this quantity depends on the
;		distortion model.
;
;		Methods: cam_scale, cam_set_scale
;
;
;	oaxis:	2-element array giving the image coordinates corresponding 
;		to the camera optic axis.
;
;		Methods: cam_oaxis, cam_set_oaxis
;
;
;	exposure:	Exposure duration.  BODY time refers to the 
;			center of this interval.
;
;			Methods: cam_exposure, cam_set_exposure
;
;
;	size:	Image size in pixels.
;
;		Methods: cam_size, cam_set_size
;
;	filters:	String array giving the names of each filter.
;
;
;	fn_focal_to_image:	String giving the name of a function
;				that transforms points in the focal
;				plane coordinate system to points in 
;				the image coordinate system.  Default is
;				cam_image_to_focal_linear().
;
;				Methods: cam_fn_focal_to_image, 
;				         cam_set_fn_focal_to_image
;
;
;	fn_image_to_focal:	String giving the name of a function
;				that transforms points in the image
;				coordinate system to points in the focal-
;				plane coordinate system.  Default is
;				cam_image_to_focal_linear().
;
;				Methods: cam_fn_image_to_focal 
;				         cam_set_fn_image_to_focal
;
;
;	fn_data_p:	Pointer to generic data intended to be used by 
;			the above user-defined focal <--> image functions. 
;
;
;	fn_psf:	String giving the name of a function to be defined as 
;		follows:
;
;		function <name>, cd, x, y, default=default
;
;		The function should return an array of PSF values at the given 
;		coordinates, subject to the following rules:
;
;		1) If neither x nor y are given, then a PSF function is returned
;		   on some default grid, which is application-specific.
;
;		2) If only x is given, then PSF values are returned for each x, 
;		   with y values set to zero.
;
;		3) If x and y are given, then PSF values are returned at all 
;		   points (x,y).
;
;
;		Methods: cam_fn_psf, cam_set_fn_psf, cam_psf, cam_psf_attrib
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
pro camera_descriptor__define

 nfilt = cam_nfilters()

 struct = $
    { camera_descriptor, $
	bd:		 nv_ptr_new(), $		; ptr to body descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class

	scale:		 dblarr(2), $		; camera scale in each direction
						; (radians/pixel)
	oaxis:		 dblarr(2), $		; image coordinates of optical
						; axis
	size:		 dblarr(3), $		; Image size, pixels
	exposure:	 0d, $			; exposure duration; body time
						; is specified at center of this
						; interval
	filters:	strarr(nfilt), $	; Filter names

	fn_psf:		'', $			; Point-spread fn.

	fn_focal_to_image:   '', $		; user procedures to tranform
	fn_image_to_focal:   '', $		; between focal and image
	fn_data_p:	 nv_ptr_new() $		; data for functions
    }

end
;===========================================================================



