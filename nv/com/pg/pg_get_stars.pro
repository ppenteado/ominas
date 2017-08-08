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
;    Descriptor Select Keywords
;    --------------------------
;    Descriptor select keywords are combined with OR logic.  They are implemented
;    in this routine as described below after the translators have been called,
;    but they are also added to the translator keywords.  The purpose of sending
;    then to the translators as well is to give the translators an opportunity
;    to filter their outputs before potentially generating a huge array of
;    descriptors that would mostly be filtered out by this routine.   
;
;	fov/cov:	Select all stars that fall within this many fields of
;			view (fov) (+/- 10%) from the center of view (cov).
;			Default cov is the camera optic axis.
;
;	pix:		Select all stars whose apparent size (in pixels) is 
;			greater than or equal to this value.
;
;	radmax:		Select all stars whose radius is greater than or 
;			equal to this value.
;
;	radmin:		Select all stars whose radius is less than or 
;			equal to this value.
;
;	distmax:	Select all stars whose distance is greater than or 
;			equal to this value.
;
;	distmin:	Select all stars whose distance is less than or 
;			equal to this value.
;
;	nlarge:		Select n largest stars.
;
;	nsmall:		Select n smallest stars.
;
;	nclose:		Select n closst stars.
;
;	nfar:		Select n farthest stars.
;
;	faint:		Select stars with magnitudes less than or equal to
;			this value.
;
;	bright:		Select stars with magnitudes greater than or equal to
;			this value.
;
;	nbright:	Select this many brightest stars.
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



;===========================================================================
; pggs_select_stars
;
;
;===========================================================================
pro pggs_select_stars, dd, sd, od=od, select

 ;------------------------------------------------------------------------
 ; standard body filters
 ;------------------------------------------------------------------------
 sel = pg_select_bodies(dd, sd, od=od, select)

 ;------------------------------------------------------------------------
 ; filters specific to stars
 ;------------------------------------------------------------------------
 n = n_elements(sd)
 mag = str_get_mag(sd)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 ; faint -- faintest magnitude to select
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 faint = struct_get(select, 'faint')
 if(keyword_set(faint)) then $
  begin
   w = where(mag LE faint)
   sel = append_array(sel, w)
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 ; bright -- brightest magnitude to select
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 bright = struct_get(select, 'bright')
 if(keyword_set(bright)) then $
  begin
   w = where(mag GE bright)
   sel = append_array(sel, w)
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 ; nbright -- number of brightest stars to select
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 nbright = struct_get(select, 'nbright')
 if(keyword_set(nbright)) then $
  if(n GT nbright) then $ 
   begin
    ss = sort(mag)
    ii = lindgen(n)
    w = (ii[ss])[0:(nbright<n)-1]
    sel = append_array(sel, w)
   end


 ;------------------------------------------------------------------------
 ; implement any selections
 ;------------------------------------------------------------------------
 if(keyword_set(sel)) then $
  begin
   sel = unique(sel)

   w = complement(sd, sel)
   if(w[0] NE -1) then nv_free, sd[w]

   if(sel[0] EQ -1) then sd = obj_new() $
   else sd = sd[sel]
  end

end
;===========================================================================



;===========================================================================
; pg_get_stars
;
;===========================================================================
function pg_get_stars, dd, trs, sd=_sd, od=od, _extra=select, $
                     override=override, verbatim=verbatim, raw=raw, $
@str__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ndd = n_elements(dd)

 ;-----------------------------------------------
 ; add selection keywords to translator keywords
 ;-----------------------------------------------
 if(keyword_set(select)) then pg_add_selections, trs, select

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(od)) then od = dat_gd(gd, dd=dd, /od)

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword__set(override)) then $
  begin
   n = n_elements(name)

   if(keyword_set(dd)) then gd = dd
   sd = str_create_descriptors(n, $
@str__keywords.include
end_keywords)
   gd = !null

  end $
 ;-------------------------------------------------------------------
 ; otherwise, get star descriptors from the translators
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
;   if(NOT keyword__set(od)) then nv_message,'No observer descriptor.'

   sd=dat_get_value(dd, 'STR_DESCRIPTORS', key1=od, key4=_sd, $
                 key7=time, key8=name, trs=trs, $
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
   ; perform aberration corrections
   ;------------------------------------------------------------------
   if(keyword_set(od) AND (NOT keyword_set(raw))) then $
    for i=0, ndd-1 do $
     begin
      w = where(cor_gd(sd, /dd) EQ dd[i])
;      if(w[0] NE -1) then stellab, od[i], sd[w], c=pgc_const('c')
      if(w[0] NE -1) then abcorr, od[i], sd[w], c=pgc_const('c')
     end

   ;-------------------------------------------------------------------
   ; override the specified values (name cannot be overridden)
   ;-------------------------------------------------------------------
   if(defined(name)) then _name = name & name = !null
   str_assign, sd, /noevent, $
@str__keywords.include
end_keywords
    if(defined(_name)) then name = _name

  end

 ;--------------------------------------------------------
 ; filter stars
 ;--------------------------------------------------------
 if(NOT keyword_set(sd)) then return, obj_new()
 if(keyword_set(select)) then pggs_select_stars, dd, sd, od=od, select
 if(NOT keyword_set(sd)) then return, obj_new()


 ;--------------------------------------------------------
 ; update generic descriptors
 ;--------------------------------------------------------
 if(keyword_set(dd)) then dat_set_gd, dd, gd, od=od
 dat_set_gd, sd, gd, od=od

 return, sd
end
;===========================================================================



