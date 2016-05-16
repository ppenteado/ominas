;=============================================================================
;+
; NAME:
;	str_evolve
;
;
; PURPOSE:
;	Computes new star descriptors at the given time offsets from the 
;	given star descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given star 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	sdt = str_evolve(sx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	sx:	 Any subclass of STAR.
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
;	Array (nsd,ndt) of newly allocated descriptors, of class STAR,
;	evolved by time dt, where nsd is the number of sx, and ndt
;	is the number of dt.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function str_evolve, sd, dt, nodv=nodv
@core.include
 return, glb_evolve(sd, dt, nodv=nodv)
end
;===========================================================================



