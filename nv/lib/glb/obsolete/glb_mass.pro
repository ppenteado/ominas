;===========================================================================
;+
; NAME:
;	glb_mass
;
;
; PURPOSE:
;       Returns the mass for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	mass = glb_mass(gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
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
;       Array (nt) of mass values associated with each given globe 
;	descriptor.
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
;===========================================================================
function glb_mass, gbxp
nv_message, /stop, name='glb_mass', 'Obsolete routine.  Use sld_mass instead.'
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)

 return, gbd.mass
end
;===========================================================================
