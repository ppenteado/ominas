;=============================================================================
;+
; NAME:
;	dsk_apply_scale
;
;
; PURPOSE:
;	Computes scaled radii.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	scaled_radii = dsk_apply_scale(dkx, radii)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 A single disk descriptors.
;
;	radii:	 Array of radii to convert.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	inverse:	If set, the operation is performed in reverse.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Scaled radii based onthe scale parameters in the disk descriptor.
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
function dsk_apply_scale, dkxp, radii, inverse=inverse, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1, noevent=noevent
 dkd = nv_dereference(dkdp)
 
 scale = dkd.scale

 if(keyword_set(inverse)) then return, (radii - scale[0]) / scale[1]
 return, scale[0] + radii*scale[1]
end
;===========================================================================
