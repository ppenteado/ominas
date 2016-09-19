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
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	str_*:		All star override keywords are accepted.  See
;			star_keywords.include.
;
;			If name is specified, then only descriptors with
;			those names are returned.
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
;	Star descriptors obtained from the translators, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a star descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except name) can still be overridden by specifying 
;	them as keyword parameters.  If name is specified, then
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
                     override=override, verbatim=verbatim, raw=raw, $
                     radec=radec, corners=corners, $
@str__keywords.include
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
   n = n_elements(name)

 sd=str_create_descriptors(n, $
	name=name, $
	orient=orient, $
	avel=avel, $
	pos=pos, $
	vel=str__vel, $
	time=time, $
	radii=radii, $
	lora=lora, $
	lum=lum, $
	opaque=opaque, $
	opacity=opacity, $  
	sp=sp)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get star descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(name)) then tr_first = 1

;   if(NOT keyword__set(od)) then nv_message, $
;                               name='pg_get_stars', 'No observer descriptor.'

   sd=dat_get_value(dd, 'STR_DESCRIPTORS', key1=od, key2=sund, key4=_sd, $
                 key5=corners, key6=radec, key7=time, key8=name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword__set(sd)) then return, obj_new()

   n = n_elements(sd)

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
     tr_names = cor_name(sd)
     sub = nwhere(strupcase(tr_names), strupcase(name))
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
   ; override the specified values (name cannot be overridden)
   ;-------------------------------------------------------------------
   w = nwhere(dd, cor_assoc_xd(sd))
   if(n_elements(time) NE 0) then bod_set_time, sd, time[w]
   if(n_elements(lum) NE 0) then str_set_lum, sd, lum[w]
   if(n_elements(sp) NE 0) then str_set_sp, sd, sp[w]
   if(n_elements(orient) NE 0) then bod_set_orient, sd, orient[*,*,w]
   if(n_elements(avel) NE 0) then bod_set_avel, sd, avel[*,*,w]
   if(n_elements(pos) NE 0) then bod_set_pos, sd, pos[*,*,w]
   if(n_elements(str__vel) NE 0) then bod_set_vel, sd, str__vel[*,*,w]
   if(n_elements(radii) NE 0) then glb_set_radii, sd, radii[*,w]
   if(n_elements(lora) NE 0) then glb_set_lora , sd, lora[w]
   if(n_elements(opaque) NE 0) then bod_set_opaque, sd, opaque[w]
   if(n_elements(opacity) NE 0) then sld_set_opacity, sd, opacity[w]
  end



 return, sd
end
;===========================================================================



