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
;	md:		Input map descriptors; used by some translators.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	map_*:		All map override keywords are accepted.  See
;			map_keywords.include.
;
;			If name is specified, then only descriptors with
;			those names are returned.
;
;			If /override and name is not specified, then
;			the name is taken from the core descriptor.
;
;	verbatim:	If set, the descriptors requested using name
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
;	values (except name) can still be overridden by specifying 
;	them as keyword parameters.  If name is specified, then
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
function pg_get_maps, dd, trs, md=_md, gbx=gbx, dkx=dkx, bx=bx, $
                        override=override, verbatim=verbatim, $
@map__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)
 if(NOT keyword_set(gbx)) then gbx = dat_gd(gd, dd=dd, /gbx)
 if(NOT keyword_set(dkx)) then dkx = dat_gd(gd, dd=dd, /dkx)


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
 if(NOT keyword_set(radii)) then $ 
  if(keyword_set(gbx)) then radii = glb_radii(gbx)


 ;----------------------------------------------------------
 ; use disk eccentricities to compute map reference radii.
 ;----------------------------------------------------------
 if(keyword_set(dkx)) then $
  begin
   a = 0.5d*total((dsk_sma(dkx))[0,*])
   e = 0.5d*total((dsk_ecc(dkx))[0,*])
   radii = [a*(1d - e), a*(1d - e^2), 0d]
   bx = dkx
  end

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword_set(override)) then $
  begin
   n = n_elements(name)
   if(n EQ 0) then $
    begin
     n = 1
     name = cor_name(bx)
    end


   md = map_create_descriptors(n, $
	  gd=dd, $
	  name=name, $
	  graphic=graphic, $
	  rotate=rotate, $
	  type=type, $
	  units=units, $
	  fn_data=fn_data, $
	  size=size, $
	  origin=origin, $
	  center=center, $
	  range=range, $
	  scale=scale, $
	  radii=radii)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get map descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   md = dat_get_value(dd, 'MAP_DESCRIPTORS', key1=ods, key4=_md, key8=name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

;   if(NOT keyword__set(md)) then md=map_create_descriptors(1)
   if(NOT keyword__set(md)) then return, obj_new()

   n = n_elements(md)

   ;---------------------------------------------------
   ; If name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword__set(name)) then $
    begin
     tr_names = cor_name(md)
     sub = nwhere(strupcase(tr_names), strupcase(name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   md = md[sub]

   ;-------------------------------------------------------------------
   ; override the specified values (name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(type) NE 0) then map_set_type, md, type
   if(n_elements(size) NE 0) then map_set_size, md, size
   if(n_elements(graphic) NE 0) then map_set_graphic, md, graphic
   if(n_elements(rotate) NE 0) then map_set_rotate, md, rotate
   if(n_elements(scale) NE 0) then map_set_scale, md, scale
   if(n_elements(radii) NE 0) then map_set_radii, md, radii
   if(n_elements(origin) NE 0) then map_set_origin, md, origin
   if(n_elements(center) NE 0) then map_set_center, md, center
   if(n_elements(range) NE 0) then map_set_range, md, range
   if(n_elements(fn_data) NE 0) then map_set_fn_data, md, fn_data
  end


 ;--------------------------------------------------------
 ; update generic descriptors
 ;--------------------------------------------------------
 if(keyword_set(dd)) then dat_set_gd, dd, gd, gbx=gbx, dkx=dkx, bx=bx
 dat_set_gd, md, gd, gbx=gbx, dkx=dkx, bx=bx

 return, md
end
;===========================================================================




