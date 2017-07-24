;=============================================================================
;+
; NAME:
;	dsk_apply_radial_scale
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
;	scaled_radii = dsk_apply_radial_scale(dkd, radii)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 A single disk descriptors.
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
;	Scaled radii based on the scale parameters in the disk descriptor.
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
function dsk_apply_radial_scale, dkd, radii, inverse=inverse, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)
 
 radial_scale = _dkd.radial_scale

 if(keyword_set(inverse)) then return, (radii - radial_scale[0]) / radial_scale[1]
 return, radial_scale[0] + radii*radial_scale[1]
end
;===========================================================================
