;=============================================================================
;+
; NAME:
;	pg_get_planets
;
;
; PURPOSE:
;	Obtains planet descriptors for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_planets(dd, od=od)
;	result = pg_get_planets(dd, od=od, trs)
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
;	pd:		Input planet descriptors; used by some translators.
;
;	od:		Observer descriptor, typically a camera descriptor.
;			If given, then planet positions will be corrected
;			for light travel time and stellar aberration relative
;			to this observer unless /raw is set.
;
;	sd:		Primary star descriptor; needed by some translators.
;
;	gd:		Generic descriptors.  Can be used in place of od and sd.
;
;	raw:		If set, no aberration corrections are performed.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	plt_*:		All planet override keywords are accepted.  See
;			planet_keywords.include.  
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
;	Array of planet descriptors, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a planet descriptor is created and initialized
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
function pg_get_planets, dd, trs, pd=_pd, od=od, sd=sd, gd=gd, $
                             override=override, verbatim=verbatim, raw=raw, $
@planet_keywords.include
@nv_trs_keywords_include.pro
		end_keywords

 ndd = n_elements(dd)

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, od=od, sd=sd, dd=dd

 if(keyword_set(od)) then $
   if(n_elements(od) NE n_elements(dd)) then $
               nv_message, name='pg_get_planets', $
                    'One observer descriptor required for each data descriptor'


 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------s
 if(keyword_set(override)) then $
  begin
   n = n_elements(plt__name)

   pd = plt_create_descriptors(n, $
		name=plt__name, $
		orient=plt__orient, $
		avel=plt__avel, $
		pos=plt__pos, $
		vel=plt__vel, $
		time=plt__time, $
		radii=plt__radii, $
		mass=plt__mass, $
		albedo=plt__albedo, $
		refl_fn=plt__refl_fn, $
		refl_parm=plt__refl_parm, $
		phase_fn=plt__phase_fn, $
		phase_parm=plt__phase_parm, $
		opaque=plt__opaque, $
		opacity=plt__opacity, $
		lora=plt__lora)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get planet descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(plt__name)) then tr_first = 1

   pd = dat_get_value(dd, 'PLT_DESCRIPTORS', key1=od, key2=sd, key4=_pd, $
                                key7=plt__time, key8=plt__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword_set(pd)) then return, obj_new()
   n = n_elements(pd)

   ;---------------------------------------------------
   ; If plt__name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If plt__name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword_set(plt__name)) then $
    begin
     tr_names = cor_name(pd)
     sub = nwhere(strupcase(tr_names), strupcase(plt__name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   pd = pd[sub]

   ;-----------------------------------
   ; perform aberration corrections
   ;-----------------------------------
   if(keyword_set(od) AND (NOT keyword_set(raw))) then $
    for i=0, ndd-1 do $
     begin
      w = where(cor_assoc_xd(pd) EQ dd[i])
      if(w[0] NE -1) then pd[w] = abcorr(od[i], pd[w], c=pgc_const('c'));, /iterate)
     end

   ;-------------------------------------------------------------------
   ; override the specified values (plt__name cannot be overridden)
   ;-------------------------------------------------------------------
   w = nwhere(dd, cor_assoc_xd(pd))
   if(n_elements(plt__time) NE 0) then bod_set_time, pd, plt__time[w]
   if(n_elements(plt__orient) NE 0) then bod_set_orient, pd, plt__orient[*,*,w]
   if(n_elements(plt__avel) NE 0) then bod_set_avel, pd, plt__avel[*,*,w]
   if(n_elements(plt__pos) NE 0) then bod_set_pos, pd, plt__pos[*,*,w]
   if(n_elements(plt__vel) NE 0) then bod_set_vel, pd, plt__vel[*,*,w]
   if(n_elements(plt__radii) NE 0) then glb_set_radii, pd, plt__radii[*,w]
   if(n_elements(plt__mass) NE 0) then sld_set_mass, pd, plt__mass[w]
   if(n_elements(plt__lora) NE 0) then glb_set_lora, pd, plt__lora[w]
   if(n_elements(plt__albedo) NE 0) then sld_set_albedo, pd, plt__albedo[w]
   if(n_elements(plt__refl_fn) NE 0) then sld_set__refl_fn, pd, plt__refl_fn[w]
   if(n_elements(plt__refl_parm) NE 0) then sld_set__refl_parm, pd, plt__refl_parm[w]
   if(n_elements(plt__phase_fn) NE 0) then sld_set__phase_fn, pd, plt__phase_fn[w]
   if(n_elements(plt__phase_parm) NE 0) then sld_set__phase_parm, pd, plt__phase_parm[w]
   if(n_elements(plt__opaque) NE 0) then bod_set_opaque, pd, plt__opaque[w]
   if(n_elements(plt__opacity) NE 0) then sld_set_opacity, pd, plt__opacity[w]
  end



return, pd
end
;===========================================================================





