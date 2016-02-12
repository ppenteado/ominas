;=============================================================================
;+
; NAME:
;	ring_descriptor__define
;
;
; PURPOSE:
;	Class structure for the RING class.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	dkd:	DISK class descriptor.  
;
;		Methods: rng_disk, rng_set_disk
;
;
;	primary:	String giving the name of the primary body.
;
;			Methods: rng_primary, rng_set_primary
;
;	desc:	String giving the description of the ring.  Valid values
;		are 'EDGE', 'PEAK', 'TROUGH'.
;
;		Methods: rng_desc, rng_set_desc
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
pro ring_descriptor__define

 struct = $
    { ring_descriptor, $
	dkd:		 nv_ptr_new(), $		; ptr to disk descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class
	desc:		 '', $			; 'EDGE', 'PEAK', 'TROUGH'
	primary:	 '' $			; Name of primary planet
    }

end
;===========================================================================



