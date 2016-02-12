;=============================================================================
;+
; NAME:
;	globe_descriptor__define
;
;
; PURPOSE:
;	Class structure fo the GLOBE class.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	sld:	SOLID class descriptor.  
;
;		Methods: glb_solid, glb_set_solid
;
;
;	type:	String giving the type.  ELLIPSOID, FACET, or HARMONIC.
;		Currently only ellipsoids are supported.
;
;
;		Methods: glb_type, glb_set_type
;
;	lref:	Longitude reference note.  Used to describe the longitude
;		reference system.
;
;		Methods: glb_lref, glb_set_lref
;
;
;	radii:	3-element array giving the ellipsoid radii.
;
;		Methods: glb_radii, glb_set_radii
;
;
;	lora:	Longitude of first ellipsoid radius.
;
;		Methods: glb_lora, glb_set_lora
;
;
;	rref:	Reference radius.
;
;		Methods: glb_rref, glb_set_rref
;
;
;	J:	Array (nj) giving the zonal harmonics.  Indices in the 
;		array correspond to the standard harmonic orders, i.e.,
;		J[2] is J2.
;
;		Methods: glb_j, glb_set_j
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
pro globe_descriptor__define

 nj = glb_nj()
 npht = glb_npht()

 struct = $
    { globe_descriptor, $
	sld:		 nv_ptr_new(), $	; ptr to solid descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class
	type:		 '', $			; ELLIPSOID, FACET, or HARMONIC

	lref:	 	 '', $			; longitude reference note

	;----------------------------------------
	; ellipsoid parameters
	;----------------------------------------
	radii:		 dblarr(3), $		; triaxial ellipsoid radii
	lora:		 0d, $			; east longitude of first
						; ellipsoid radius.  

	;----------------------------------------
	; dynamical parameters
	;----------------------------------------
	rref:		0d, $			; reference radius
	J:		dblarr(nj) $		; Zonal grav. harmonics
;	S:	tesseral harmonics not implemented.
;	C:

    }

end
;===========================================================================
