;==============================================================================
;+
; NAME:
;	glb_replicate
;
;
; PURPOSE:
;	Replicates the given globe descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	new_gbx = cam_replicate(gbx, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	 One descriptor of any subclass of GLOBE descriptor
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
;	globe descriptor.
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
;==============================================================================
function glb_replicate, gbdp, dim
 new_gbdp = nv_replicate(gbdp, dim, fn='nv_clone')
 return, new_gbdp
end
;==============================================================================
