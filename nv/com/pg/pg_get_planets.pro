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
;	no_sort:	Unless this keyword is set, only the first descriptor 
;			encountered with a given name is returned.  This allows
;			translators to be arranged in the translators table such
;			by order of priority.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	plt_*:		All planet override keywords are accepted.  See
;			planet_keywords.include.  
;
;			If plt_name is specified, then only descriptors with
;			those names are returned. 
;
;	verbatim:	If set, the descriptors requested using plt_name
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
;	values (except plt_name) can still be overridden by specifying 
;	them as keyword parameters.  If plt_name is specified, then
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
function pg_get_planets, dd, trs, pd=_pd, od=od, sd=sd, gd=gd, no_sort=no_sort, $
                             override=override, verbatim=verbatim, raw=raw, $
@planet_keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, od=od, sd=sd, dd=dd



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
     if(cor_isa(od, 'BODY')) then $
                          abcorr, od, pd, c=pgc_const('c');, /iterate

   ;-------------------------------------------------------------------
   ; override the specified values (plt__name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(plt__orient) NE 0) then bod_set_orient, pd, plt__orient
   if(n_elements(plt__avel) NE 0) then bod_set_avel, pd, plt__avel
   if(n_elements(plt__pos) NE 0) then bod_set_pos, pd, plt__pos
   if(n_elements(plt__vel) NE 0) then bod_set_vel, pd, plt__vel
   if(n_elements(plt__time) NE 0) then bod_set_time, pd, plt__time
   if(n_elements(plt__radii) NE 0) then glb_set_radii, pd, plt__radii
   if(n_elements(plt__mass) NE 0) then sld_set_mass, pd, plt__mass
   if(n_elements(plt__lora) NE 0) then glb_set_lora, pd, plt__lora
   if(n_elements(plt__albedo) NE 0) then sld_set_albedo, pd, plt__albedo
   if(n_elements(plt__refl_fn) NE 0) then sld_set__refl_fn, pd, plt__refl_fn
   if(n_elements(plt__refl_parm) NE 0) then sld_set__refl_parm, pd, plt__refl_parm
   if(n_elements(plt__phase_fn) NE 0) then sld_set__phase_fn, pd, plt__phase_fn
   if(n_elements(plt__phase_parm) NE 0) then sld_set__phase_parm, pd, plt__phase_parm
   if(n_elements(plt__opaque) NE 0) then bod_set_opaque, pd, plt__opaque
   if(n_elements(plt__opacity) NE 0) then sld_set_opacity, pd, plt__opacity
  end


 ;------------------------------------------------------------
 ; Make sure that for a given name, only the first 
 ; descriptor obtained from the translators is returned.
 ; Thus, translators can be arranged in order in the table
 ; such the the first occurence has the highest priority.
 ;------------------------------------------------------------
 if(NOT keyword_set(no_sort)) then pd = pd[pgs_name_sort(cor_name(pd))]



return, pd
end
;===========================================================================





