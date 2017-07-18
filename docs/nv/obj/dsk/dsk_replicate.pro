;=============================================================================
;+
; NAME:
;	dsk_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	xd = dsk_replicate(dkd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Any superclass of DISK.
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
function dsk_replicate, dkd, dim
@core.include
 new_dkd = dat_replicate(dkd, dim, fn='nv_clone')
 return, new_dkd
end
;==============================================================================
