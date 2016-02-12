;=============================================================================
;+
; NAME:
;	rng_evolve
;
;
; PURPOSE:
;	Computes new ring descriptors at the given time offsets from the 
;	given ring descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given ring 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rdt = rng_evolve(rx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	rx:	 Any subclass of RING.
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
;	Array (nrd,ndt) of newly allocated descriptors, of class RING,
;	evolved by time dt, where nrd is the number of rx, and ndt
;	is the number of dt.
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
function rng_evolve, rxp, dt, nodv=nodv
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 rds = nv_dereference(rdp)

 ndt = n_elements(dt)
 nrd = n_elements(rds)

 trds = _rng_evolve(rds, dt, nodv=nodv)


 trdps = ptrarr(nrd, ndt)
 nv_rereference, trdps, trds

 return, trdps
end
;===========================================================================



