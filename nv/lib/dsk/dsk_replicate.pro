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
;	xd = dsk_replicate(dkx, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Any superclass of DISK.
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
function dsk_replicate, dkdp, dim
@nv_lib.include
 new_dkdp = nv_replicate(dkdp, dim, fn='nv_clone')
 return, new_dkdp
end
;==============================================================================
