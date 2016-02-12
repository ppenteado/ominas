;=============================================================================
;+
; NAME:
;	map_descriptor__define
;
;
; PURPOSE:
;	Class structure fo the MAP class.
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
;	crd:	CORE class descriptor.  
;
;		Methods: map_core
;
;
;	type:	String giving the map type, e.g., RECTANGULAR, 
;		ORTHOGRAPHIC.  Map transformation functions are named
;		map_image_to_map_<type> and map_map_to_image_<type>.
;
;		Methods: map_type, map_set_type
;
;
;	units:	2-element array to converts map radians to other
;  		units (map radians/unit).
;
;		Methods: map_units, map_set_units
;
;
;	size:	2-element array giving the map size in pixels.
;
;		Methods: map_size, map_set_size
;
;
;	scale:	Map scale (units/angle) at the center of the map.
;
;		Methods: map_scale, map_set_scale
;
;
;	center:	2-element array giving the map coordinates of the
;		center of the map.
;
;		Methods: map_center, map_set_center
;
;
;	origin:	2-element array giving the image coordinates corresponding
;		to the center of the map.
;
;		Methods: map_origin, map_set_origin
;
;
;	offset:	2-element array giving a lat/lon offset to be applied in 
;		map transformations.
;
;		Methods: map_offset, map_set_offset
;
;
;	rotate:	Code specifying a rotation to be applied to the map, as in the
;		IDL 'rotate' function.
;
;
;	graphic:	Flag indicating whether latitudes are represented
;			using the planetocrntric or planetographic convention.
;
;	radii:	3-element array giving ellipsoid radii to use in projections.  
;		Only the relative ratios are important.  All elements are 
;		set to 1 by default.
;
;	fn_data_p:	Pointer to any data to be passed to transfrmation 
;			functions.
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
pro map_descriptor__define

 struct = $
    { map_descriptor, $
	crd:		 nv_ptr_new(), $	; ptr to core class descriptor
	class:		  '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class

	type:		  '', $			; Name of map projection type
	units:	 	  [1d,1d],$		; Converts map radians to other
						;  units (map radians/unit).
	size:		  lonarr(2), $		; [x,y] size of map in pixels
	scale:		  0d, $			; map 'scale'; Actually zoom.
	origin:		  dblarr(2), $		; image coords of map center
	center:		  dblarr(2), $		; lat,lon of map center
	offset:		  dblarr(2), $		; [lat,lon] offset to be applied
						;  in transformations.
	radii:		  dblarr(3), $		; ref. radii of triaxial ellipsoid

	graphic:	  0b, $			; If set, planetographic 
						;  lats are used.

	rotate:		  0b, $			; Rotate value as in idl 'rotate'

	fn_data_p:	   nv_ptr_new() $		; data for user functions
    }

end
;===========================================================================



