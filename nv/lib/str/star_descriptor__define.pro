;=============================================================================
;+
; NAME:
;	star_descriptor__define
;
;
; PURPOSE:
;	Class structure for the STAR class.
;
;
; CATEGORY:
;	NV/LIB/STR
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
;	lum:	Luminosity value.
;
;		Methods: str_lum, str_set_lum
;
;
;	sp:	Spectral class string.
;
;		Methods: str_sp, str_set_sp
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
pro star_descriptor__define

 struct = $
    { star_descriptor, $
	gbd:		 nv_ptr_new(), $	; ptr to globe descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class
	lum: 		 double(0), $		; Luminosity
	sp:		 '' $			; Spectral type
    }

end
;===========================================================================



