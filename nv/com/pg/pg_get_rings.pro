;=============================================================================
;+
; NAME:
;	pg_get_rings
;
;
; PURPOSE:
;	Obtains ring descriptors for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_rings(dd, od=od)
;	result = pg_get_rings(dd, od=od, trs)
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
;	rd:		Input ring descriptors; used by some translators.
;
;	pd:		Planet descriptors for primary objects.  
;
;	od:		Observer descriptors.  
;
;	gd:		Generic descriptors.  Can be used in place of od.
;
;	no_sort:	Unless this keyword is set, only the first descriptor 
;			encountered with a given name is returned.  This allows
;			translators to be arranged in the translators table such
;			by order of priority.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	rng_*:		All ring override keywords are accepted.  See
;			ring_keywords.include.
;
;			If rng_name is specified, then only descriptors with
;			those names are returned.
;
;	verbatim:	If set, the descriptors requested using rng_name
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
;	Ring descriptors obtained from the translators, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a ring descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except rng_name) can still be overridden by specifying 
;	them as keyword parameters.  If rng_name is specified, then
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
function pg_get_rings, dd, trs, rd=_rd, pd=pd, od=od, gd=gd, $
                      no_sort=no_sort, override=override, verbatim=verbatim, $
@ring_keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, pd=pd, od=od, dd=dd

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword__set(override)) then $
  begin
   n = n_elements(rng__name)

   if(NOT keyword__set(rng__orient)) then rng__orient = bod_orient(pd)
;   if(NOT keyword__set(rng__avel)) then rng__avel = bod_avel(pd)
   if(NOT keyword__set(rng__pos)) then rng__pos = bod_pos(pd)
   if(NOT keyword__set(rng__vel)) then rng__vel = bod_vel(pd)
   if(NOT keyword__set(rng__time)) then rng__time = bod_time(pd)

   rd=rng_create_descriptors(n, $
	name=rng__name, $
	primary=rng__primary, $
	orient=rng__orient, $
	avel=rng__avel, $
	pos=rng__pos, $
	vel=rng__vel, $
	time=rng__time, $
	sma=rng__sma, $
	ecc=rng__ecc, $
	opaque=rng__opaque, $
	opacity=rng__opacity, $
	nm=rng__nm, $
	_m=rng__m, $
	em=rng__em, $
	lpm=rng__lpm, $
	dlpmdt=rng__dlpmdt)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get ring descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(rng__name)) then tr_first = 1

   rd = dat_get_value(dd, 'RNG_DESCRIPTORS', key1=pd, key2=od, key4=_rd, $
                            key7=rng__time, key8=rng__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword__set(rd)) then return, obj_new()

   n = n_elements(rd)

   ;---------------------------------------------------
   ; If rng__name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If rng__name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword__set(rng__name)) then $
    begin
     tr_names = cor_name(rd)
     sub = nwhere(strupcase(tr_names), strupcase(rng__name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   _rs = rd[sub]

   ;-------------------------------------------------------------------
   ; override the specified values (rng__name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(rng__primary) NE 0) then rng_set_primary, rd, rng__primary

   if(n_elements(rng__orient) NE 0) then bod_set_orient, rd, rng__orient
   if(n_elements(rng__avel) NE 0) then bod_set_avel, rd, rng__avel
   if(n_elements(rng__pos) NE 0) then bod_set_pos, rd, rng__pos
   if(n_elements(rng__vel) NE 0) then bod_set_vel, rd, rng__vel
   if(n_elements(rng__time) NE 0) then bod_set_time, rd, rng__time
   if(n_elements(rng__opaque) NE 0) then bod_set_opaque, grd, rng__opaque
   if(n_elements(rng__opacity) NE 0) then sldd_set_opacity, grd, rng__opacity

   if(n_elements(rng__sma) NE 0) then dsk_set_sma, rd, rng__sma
   if(n_elements(rng__ecc) NE 0) then dsk_set_ecc, rd, rng__ecc
   if(n_elements(rng__opaque) NE 0) then bod_set_opaque, rd, rng__opaque
   if(n_elements(rng__nm) NE 0) then dsk_set_nm, rd, rng__nm
   if(n_elements(rng__m) NE 0) then dsk_set_m, rd, rng__m
   if(n_elements(rng__em) NE 0) then dsk_set_em, rd, rng__em
   if(n_elements(rng__lpm) NE 0) then dsk_set_lpm, rd, rng__lpm
   if(n_elements(rng__dlpmdt) NE 0) then dsk_set_dlpmdt, rd, rng__dlpmdt
  end



 ;------------------------------------------------------------
 ; Make sure that for a given name, only the first 
 ; descriptor obtained from the translators is returned.
 ; Thus, translators can be arranged in order in the table
 ; such the the first occurence has the highest priority.
 ;------------------------------------------------------------
 if(NOT keyword__set(no_sort)) then rd=rd[pgs_name_sort(cor_name(rd))]

 return, rd
end
;===========================================================================



