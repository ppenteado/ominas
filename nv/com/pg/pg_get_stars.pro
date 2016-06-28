;=============================================================================
;+
; NAME:
;	pg_get_stars
;
;
; PURPOSE:
;	Obtain star descriptors for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_stars(dd, od=od)
;	result = pg_get_stars(dd, od=od, trs)
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
;	sd:		Input star descriptors; used by some translators.
;
;	od:		Observer descriptor, typically a camera descriptor.
;			If given, then star positions will be corrected
;			for stellar aberration (but not light-travel time,
;			which is inherently accounted for in star catalogs) 
;			relative to this observer, unless /raw is set.  
;
;	sund:		Star descriptors for the sun.  Used to correct for
;			stellar aberration.  
;
;	gd:		Generic descriptors.  Can be used in place of od.
;
;	raw:		If set, no aberration corrections are performed.
;
;	no_sort:	Unless this keyword is set, only the first descriptor 
;			encountered with a given name is returned.  This allows
;			translators to be arranged in the translators table such
;			by order of priority.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	str_*:		All star override keywords are accepted.  See
;			star_keywords.include.
;
;			If str_name is specified, then only descriptors with
;			those names are returned.
;
;	verbatim:	If set, the descriptors requested using str_name
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
;	Star descriptors obtained from the translators, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a star descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except str_name) can still be overridden by specifying 
;	them as keyword parameters.  If str_name is specified, then
;	only descriptors corresponding to those names will be returned.
;	
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	Modified:	Spitale, 8/2001
;	
;-
;=============================================================================
function pg_get_stars, dd, trs, sd=_sd, od=od, sund=sund, gd=gd, $
                     no_sort=no_sort, override=override, verbatim=verbatim, raw=raw, $
                     radec=radec, corners=corners, $
@star_keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, od=od, sund=sund, dd=dd

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword__set(override)) then $
  begin
   n = n_elements(str__name)

 sd=str_create_descriptors(n, $
	name=str__name, $
	orient=str__orient, $
	avel=str__avel, $
	pos=str__pos, $
	vel=str__vel, $
	time=str__time, $
	radii=str__radii, $
	lora=str__lora, $
	lum=str__lum, $
	opaque=str__opaque, $
	opacity=str__opacity, $  
	sp=str__sp)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get star descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(str__name)) then tr_first = 1

;   if(NOT keyword__set(od)) then nv_message, $
;                               name='pg_get_stars', 'No observer descriptor.'

   sd=dat_get_value(dd, 'STR_DESCRIPTORS', key1=od, key2=sund, key4=_sd, $
                 key5=corners, key6=radec, key7=str__time, key8=str__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword__set(sd)) then return, obj_new()

   n = n_elements(sd)

   ;---------------------------------------------------
   ; If str__name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If str__name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword__set(str__name)) then $
    begin
     tr_names = cor_name(sd)
     sub = nwhere(strupcase(tr_names), strupcase(str__name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   sd = sd[sub]

   ;------------------------------------------------------------------
   ; perform stellar aberration correction
   ;------------------------------------------------------------------
;   if(keyword_set(od) AND (NOT keyword_set(raw))) then $
;                                        stellab, od, sd, c=pgc_const('c')

   ;-------------------------------------------------------------------
   ; override the specified values (str__name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(str__lum) NE 0) then str_set_lum, sd, str__lum
   if(n_elements(str__sp) NE 0) then str_set_sp, sd, str__sp
   if(n_elements(str__orient) NE 0) then bod_set_orient, sd, str__orient
   if(n_elements(str__avel) NE 0) then bod_set_avel, sd, str__avel
   if(n_elements(str__pos) NE 0) then bod_set_pos, sd, str__pos
   if(n_elements(str__vel) NE 0) then bod_set_vel, sd, str__vel
   if(n_elements(str__time) NE 0) then bod_set_time, sd, str__time
   if(n_elements(str__radii) NE 0) then glb_set_radii, sd, str__radii
   if(n_elements(str__lora) NE 0) then glb_set_lora , sd, str__lora
   if(n_elements(str__opaque) NE 0) then bod_set_opaque, sd, str__opaque
   if(n_elements(str__opacity) NE 0) then sld_set_opacity, sd, str__opacity
  end


 ;------------------------------------------------------------
 ; Make sure that for a given name, only the first 
 ; descriptor obtained from the translators is returned.
 ; Thus, translators can be arranged in order in the table
 ; such the the first occurence has the highest priority.
 ;------------------------------------------------------------
 if(NOT keyword__set(no_sort)) then sd=sd[pgs_name_sort(cor_name(sd))]



 return, sd
end
;===========================================================================



