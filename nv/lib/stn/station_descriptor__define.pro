;=============================================================================
;+
; NAME:
;	station_descriptor__define
;
;
; PURPOSE:
;	Class structure for the STATION class.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	bd:	BODY class descriptor.  
;
;		Methods: stn_body, stn_set_body
;
;
;	primary:	String giving the name of the primary body.
;
;			Methods: stn_primary, stn_set_primary
;
;	surface_pt:	Vector giving the surface coordinates of the 
;			stations location on the primary.  This 
;			is redeundant with the location of bd, but it 
;			allows one to compute map coordinates without
;			a body descriptor present.
;
;			Methods: stn_surface_pt, stn_set_surface_pt
;
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
pro station_descriptor__define

 struct = $
    { station_descriptor, $
	bd:		 nv_ptr_new(), $	; ptr to body descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class
	surface_pt:	 dblarr(1,3), $		; Surface coords of location.
        primary:         '' $                   ; Name of primary planet
    }

end
;===========================================================================



