;===========================================================================
;+
; NAME:
;	glb_set_mass
;
;
; PURPOSE:
;       Replaces the mass for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_mass, gbx, mass
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	j:	 Array (nj,nt) of new masses.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
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
pro glb_set_mass, gbxp, mass, nosynch=nosynch
@nv_lib.include
nv_message, /stop, name='glb_set_mass', 'Obsolete routine.  Use sld_set_mass instead.'
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 if(NOT keyword__set(nosynch)) then gbd.gm = gbd.gm * mass/gbd.mass
 gbd.mass = mass

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0
end
;===========================================================================
