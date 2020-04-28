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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function bod_replicate, bd, dim
@core.include
 new_bd = dat_replicate(bd, dim, fn='nv_clone')
 return, new_bd
end
;==============================================================================
