;=============================================================================
;+
; NAME:
;	pg_get_maps
;
;
; PURPOSE:
;	Obtains a map descriptor for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_maps(dd)
;	result = pg_get_maps(dd, trs)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	data descriptor
;
;	trs:	String containing keywords and values to be passed directly
;		to the translators as if they appeared as arguments in the
;		translators table.  These arguments are passed to every
;		translator called, so the user should be aware of possible
;		conflicts.  Keywords passed using this mechanism take 
;		precedence over keywords appearing in the translators table.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	mds:		Input map descriptors; used by some translators.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	map_*:		All map override keywords are accepted.  See
;			map_keywords.include.
;
;			If map_name is specified, then only descriptors with
;			those names are returned.
;
;			If /override and map name is not specified, then
;			the name is taken from the globe descriptor.
;
;	verbatim:	If set, the descriptors requested using map_name
;			are returned in the order requested.  Otherwise, the 
;			order is determined by the translators.
;
;	tr_override:	String giving a comma-separated list of translators
;			to use instead of those in the translators table.  If
;			this keyword is specified, no translators from the 
;			table are called, but the translators keywords
;			from the table are still used.   
;
;
; RETURN:
;	Array of map descriptors, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a map descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except map_name) can still be overridden by specifying 
;	them as keyword parameters.  If map_name is specified, then
;	only descriptors corresponding to those names will be returned.
;	
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	Modified:	Spitale, 8/2001
;	
;-
;=============================================================================
function pg_get_maps, dd, trs, mds=_mds, gbx=gbx, dkx=dkx, bx=bx, gd=gd, $
                        override=override, verbatim=verbatim, $
@map_keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, gbx=gbx, dkx=dkx, bx=bx, dd=dd


 ;----------------------------------------------------------
 ; Determine body type, GLOBE or DISK.
 ;----------------------------------------------------------
 if(keyword__set(bx)) then $
  begin
   if(cor_isa(bx, 'GLOBE')) then gbx = bx
   if(cor_isa(bx, 'DISK')) then dkx = bx
  end

 ;----------------------------------------------------------
 ; Use globe radii for map reference radii.
 ;----------------------------------------------------------
 if(NOT keyword_set(map__radii)) then $ 
  if(keyword_set(gbx)) then map__radii = glb_radii(gbx)


 ;----------------------------------------------------------
 ; use disk eccentricities to compute map reference radii.
 ;----------------------------------------------------------
 if(keyword_set(dkx)) then $
  begin
   sma = 0.5d*total((dsk_sma(dkx))[0,*])
   ecc = 0.5d*total((dsk_ecc(dkx))[0,*])
   map__radii = [sma*(1d - ecc), sma*(1d - ecc^2), 0d]
   bx = dkx
  end

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword_set(override)) then $
  begin
   n = n_elements(map__name)
   if(n EQ 0) then $
    begin
     n = 1
     map__name = cor_name(bx)
    end


   mds=map_create_descriptors(n, $
	name=map__name, $
	graphic=map__graphic, $
	rotate=map__rotate, $
	type=map__type, $
	units=map__units, $
	fn_data=map__fn_data, $
	size=map__size, $
	origin=map__origin, $
	center=map__center, $
	range=map__range, $
	scale=map__scale, $
	radii=map__radii)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get map descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   mds=dat_get_value(dd, 'MAP_DESCRIPTORS', key1=ods, key4=_mds, key8=map__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

;   if(NOT keyword__set(mds)) then mds=map_create_descriptors(1)
   if(NOT keyword__set(mds)) then return, obj_new()

   n = n_elements(mds)

   ;---------------------------------------------------
   ; If map__name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If map__name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword__set(map__name)) then $
    begin
     tr_names = cor_name(mds)
     sub = nwhere(strupcase(tr_names), strupcase(map__name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   mds = mds[sub]

   ;-------------------------------------------------------------------
   ; override the specified values (map__name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(map__type) NE 0) then map_set_type, mds, map__type
   if(n_elements(map__size) NE 0) then map_set_size, mds, map__size
   if(n_elements(map__graphic) NE 0) then map_set_graphic, mds, map__graphic
   if(n_elements(map__rotate) NE 0) then map_set_rotate, mds, map__rotate
   if(n_elements(map__scale) NE 0) then map_set_scale, mds, map__scale
   if(n_elements(map__radii) NE 0) then map_set_radii, mds, map__radii
   if(n_elements(map__origin) NE 0) then map_set_origin, mds, map__origin
   if(n_elements(map__center) NE 0) then map_set_center, mds, map__center
   if(n_elements(map__range) NE 0) then map_set_range, mds, map__range
   if(n_elements(map__fn_data) NE 0) then map_set_fn_data, mds, map__fn_data
  end


 return, mds
end
;===========================================================================




