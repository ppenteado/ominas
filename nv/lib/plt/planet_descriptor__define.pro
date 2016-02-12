;=============================================================================
;+
; NAME:
;	planet_descriptor__define
;
;
; PURPOSE:
;	Class structure for the PLANET class.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	gbd:	GLOBE class descriptor.  
;
;		Methods: str_globe, str_set_globe
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
pro planet_descriptor__define

 struct = $
    { planet_descriptor, $
	gbd:		 nv_ptr_new(), $	; ptr to globe descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '' $			; Abbreviation of descriptor class
    }

end
;===========================================================================



