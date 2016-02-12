;=============================================================================
;+
; NAME:
;	str_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	sds = str_replicate(sd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	sd:	 Star descriptor.
;
;	dim:	 Dimensions of the result.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of the given dimensions containing cloned versions of the input 
;	descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function str_replicate, sdp, dim
@nv_lib.include
 new_sdp = nv_replicate(sdp, dim, fn='nv_clone')
 return, new_sdp
end
;==============================================================================
