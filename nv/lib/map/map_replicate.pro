;=============================================================================
;+
; NAME:
;	map_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	mds = map_replicate(md, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	 MAP descriptor.
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
function map_replicate, mdp, dim
@nv_lib.include
 new_mdp = nv_replicate(mdp, dim, fn='nv_clone')
 return, new_mdp
end
;==============================================================================
