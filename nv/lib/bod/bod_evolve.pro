;=============================================================================
;+
; NAME:
;	bod_evolve
;
;
; PURPOSE:
;	Computes new body descriptors at the given time offsets from the 
;	given body descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given body 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bdt = bod_evolve(bx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Any subclass of BODY.
;
;	dt:	 Time offset.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nodv:	 If set, derivatives will not be evolved.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nbd,ndt) of newly allocated descriptors, of class BODY,
;	evolved by time dt, where nbd is the number of bx, and ndt
;	is the number of dt.
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
function bod_evolve, bxp, dt, nodv=nodv
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bds = nv_dereference(bdp)

 nbd = n_elements(bds)
 ndt = n_elements(dt)


 tbds = _bod_evolve(bds, dt, nodv=nodv)


 tbdps = ptrarr(nbd, ndt)
 nv_rereference, tbdps, tbds

 return, tbdps
end
;===========================================================================



