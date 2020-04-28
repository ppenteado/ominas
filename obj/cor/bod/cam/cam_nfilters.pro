;=============================================================================
;+
; NAME:
;	cam_nfilters
;
;
; PURPOSE:
;	Returns an integer indicating the maximum number of filters allowed 
;	in the 'filters' fields of the camera descriptor.  This number can 
;	be adjusted using the environment variable 'CAM_NFILTERS'.  The default
;	is 4.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	nfilters = cam_nfilters()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;
;  OUTPUT: NONE
;
;
; ENVIRONMENT VARIABLES:
;	CAM_NFILTERS:	Sets the maximum number of filters.
;
;
; RETURN:
;	Current nfilters value.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cam_nfilters
@core.include

 nfilt_string = nv_getenv('OMINAS_CAM_NFILTERS')
 if(keyword_set(nfilt_string)) then nfilt=strtrim(nfilt_string, 2) else nfilt=4

 return, nfilt
end
;===========================================================================



