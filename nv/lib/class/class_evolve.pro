;=============================================================================
;+
; NAME:
;	class_evolve
;
;
; PURPOSE:
;	Calls the 'evolve' method appropriate for the given descriptor.
;
;
; CATEGORY:
;	NV/LIB/CLASS
;
;
; CALLING SEQUENCE:
;	xdt = class_evolve(xd, dt)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	 Any subclass of BODY.
;
;	dt:	 Time offset.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nodv:	 If set, velocities will not be evolved.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nxd,ndt) of newly allocated descriptors, of the same class 
;	as xd, evolved by time dt, where nxd is the number of xd, and ndt
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
function class_evolve, xd, dt, nodv=nodv

 abbrev = cor_abbrev(xd[0])
 fn = abbrev + '_EVOLVE'

 return, call_function(fn, xd, dt, nodv=nodv)
end
;===========================================================================



