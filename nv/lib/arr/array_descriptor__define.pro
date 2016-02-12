;=============================================================================
;+
; NAME:
;	array_descriptor__define
;
;
; PURPOSE:
;	Class structure for the ARRAY class.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	bd:	BODY class descriptor.  
;
;		Methods: arr_body, arr_set_body
;
;
;	primary:	String giving the name of the primary body.
;
;			Methods: arr_primary, arr_set_primary
;
;	surface_pts:	Vector giving the surface coordinates of the 
;			array points on the primary.  
;
;			Methods: arr_surface_pts, arr_set_surface_pts
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;-
;=============================================================================
pro array_descriptor__define

 struct = $
    { array_descriptor, $
        crd:             nv_ptr_new(), $        ; ptr to core class descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class
	surface_pts_p:	 ptr_new(), $		; Surface coords of location.
        primary:         '' $                   ; Name of primary body
    }

end
;===========================================================================



