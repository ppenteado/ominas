;=============================================================================
;+
; NAME:
;	bod_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	xd = bod_replicate(bx, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	 Any superclass of BODY.
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
function bod_replicate, bdp, dim
@nv_lib.include
 new_bdp = nv_replicate(bdp, dim, fn='nv_clone')
 return, new_bdp
end
;==============================================================================
