;=============================================================================
;+
; NAME:
;	pg_put_maps
;
;
; PURPOSE:
;	Outputs map descriptors through the translators.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_put_maps, dd, md=md
;	pg_put_maps, dd, gd=gd
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	trs:	String containing keywords and values to be passed directly
;		to the translators as if they appeared as arguments in the
;		translators table.  These arguments are passed to every
;		translator called, so the user should be aware of possible
;		conflicts.  Keywords passed using this mechanism take 
;		precedence over keywords appearing in the translators table.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	mds:	Map descriptors to output.
;
;	gd:	Generic descriptor.  If present, map descriptors are
;		taken from the gd.md field.
;
;	map_*:		All map override keywords are accepted.
;
;	tr_override:	String giving a comma-separated list of translators
;			to use instead of those in the translators table.  If
;			this keyword is specified, no translators from the 
;			table are called, but the translators keywords
;			from the table are still used.  
;
;  OUTPUT:
;	NONE
;
;
; SIDE EFFECTS:
;	Translator-dependent.  The data descriptor may be affected.
;
;
; PROCEDURE:
;	Map descriptors are passed to the translators.  Any map
;	keywords are used to override the corresponding quantities in the
;	output descriptors.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_put_planets, pg_put_rings, pg_put_stars, pg_put_cameras
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================
pro pg_put_maps, dd, trs, gd=gd, mds=_mds, $
@map__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword_set(gd)) then $
  begin
   if(NOT keyword_set(_mds)) then _mds = gd.md
  end
 if(NOT keyword_set(_mds)) then nv_message, 'No map descriptor.'

 mds = nv_clone(_mds)

 ;-------------------------------------------------------------------
 ; override the specified values 
 ;-------------------------------------------------------------------
 if(n_elements(fn_map_to_image) NE 0) then $
                 map_set_fn_map_to_image, mds, fn_map_to_image
 if(n_elements(fn_image_to_map) NE 0) then $
                 map_set_fn_image_to_map, mds, fn_image_to_map
 if(n_elements(fn_data) NE 0) then map_set_fn_data, mds, fn_data
 if(n_elements(scale) NE 0) then map_set_scale, mds, scale
 ;if(n_elements(ecc) NE 0) then map_set_ecc, mds, ecc ;no such function
 if(n_elements(map__radii) NE 0) then map_set_radii, mds, map__radii
 if(n_elements(origin) NE 0) then map_set_origin, mds, origin
 if(n_elements(center) NE 0) then map_set_center, mds, center
 if(n_elements(map__size) NE 0) then map_set_size, mds, map__size
 if(n_elements(type) NE 0) then map_set_type, mds, type



 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 dat_put_value, dd, 'MAP_DESCRIPTORS', mds, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords

 nv_free, mds
end
;===========================================================================



