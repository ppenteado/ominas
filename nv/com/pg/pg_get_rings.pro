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
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	rng_*:		All ring override keywords are accepted.  See
;			ring_keywords.include.
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
;	Ring descriptors obtained from the translators, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a ring descriptor is created and initialized
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
function pg_get_rings, dd, trs, rd=_rd, pd=pd, od=od, $
                      override=override, verbatim=verbatim, $
@rng__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(od)) then od = dat_gd(gd, dd=dd, /od)
 if(NOT keyword_set(pd)) then pd = dat_gd(gd, dd=dd, /pd)

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword__set(override)) then $
  begin
   n = n_elements(name)

   if(NOT keyword__set(orient)) then orient = bod_orient(pd)
;   if(NOT keyword__set(avel)) then avel = bod_avel(pd)
   if(NOT keyword__set(pos)) then pos = bod_pos(pd)
   if(NOT keyword__set(vel)) then vel = bod_vel(pd)
   if(NOT keyword__set(time)) then time = bod_time(pd)

   rd=rng_create_descriptors(n, $
	gd=dd, $
	name=name, $
	primary=primary, $
	orient=orient, $
	avel=avel, $
	pos=pos, $
	vel=vel, $
	time=time, $
	sma=sma, $
	ecc=ecc, $
	dap=dap, $
	opaque=opaque, $
	opacity=opacity, $
	nm=nm, $
	_m=m, $
	em=em, $
	tapm=rng__tapm, $
	dtapmdt=rng__dtapmdt)
  end $
 ;-------------------------------------------------------------------
 ; otherwise, get ring descriptors from the translators
 ;-------------------------------------------------------------------
 else $
  begin
   ;-----------------------------------------------
   ; call translators
   ;-----------------------------------------------

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;   if(keyword_set(name)) then tr_first = 1

   rd = dat_get_value(dd, 'RNG_DESCRIPTORS', key1=pd, key2=od, key4=_rd, $
                            key7=time, key8=name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword__set(rd)) then return, obj_new()

   n = n_elements(rd)

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
     tr_names = cor_name(rd)
     sub = nwhere(strupcase(tr_names), strupcase(name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   _rs = rd[sub]

   ;-------------------------------------------------------------------
   ; override the specified values (name cannot be overridden)
   ;-------------------------------------------------------------------
   w = nwhere(dd, cor_gd(rd, /dd))
   if(n_elements(time) NE 0) then bod_set_time, rd, time[w]
   if(n_elements(primary) NE 0) then rng_set_primary, rd, primary[w]
   if(n_elements(orient) NE 0) then bod_set_orient, rd, orient[*,*,w]
   if(n_elements(avel) NE 0) then bod_set_avel, rd, avel[*,*,w]
   if(n_elements(pos) NE 0) then bod_set_pos, rd, pos[*,*,w]
   if(n_elements(vel) NE 0) then bod_set_vel, rd, vel[*,*,w]
   if(n_elements(opacity) NE 0) then sldd_set_opacity, rd, opacity[w]
   if(n_elements(sma) NE 0) then dsk_set_sma, rd, sma[*,*,w]
   if(n_elements(ecc) NE 0) then dsk_set_ecc, rd, ecc[*,*,w]
   if(n_elements(dap) NE 0) then dsk_set_dap, rd, dap[*,*,w]
   if(n_elements(opaque) NE 0) then bod_set_opaque, rd, opaque[w]
   if(n_elements(nm) NE 0) then dsk_set_nm, rd, nm[w]
   if(n_elements(m) NE 0) then dsk_set_m, rd, m[*,*,w]
   if(n_elements(em) NE 0) then dsk_set_em, rd, em[*,*,w]
   if(n_elements(rng__tapm) NE 0) then dsk_set_tapm, rd, rng__tapm[*,*,w]
   if(n_elements(rng__dtapmdt) NE 0) then dsk_set_dtapmdt, rd, rng__dtapmdt[*,*,w]
  end


 ;--------------------------------------------------------
 ; update generic descriptors
 ;--------------------------------------------------------
 if(keyword_set(dd)) then dat_set_gd, dd, gd, pd=pd, od=od
 dat_set_gd, rd, gd, pd=pd, od=od

 return, rd
end
;===========================================================================



