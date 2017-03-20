;=============================================================================
;+
; NAME:
;	pg_get_cameras
;
;
; PURPOSE:
;	Obtains a camera descriptor for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_cameras(dd)
;	result = pg_get_cameras(dd, trs)
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
;	cd:		Input camera descriptors; used by some translators.
;
;	gd:		Generic descriptor containing the above descriptors.
;			Note this keyword is inherited from the CORE keywords 
;			list.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	cam_*:		All camera override keywords are accepted.  See
;			camera_keywords.include. 
;
;			If cam_name is specified, then only descriptors with
;			those names are returned.
;
;	verbatim:	If set, the descriptors requested using cam_name
;			are returned in the order requested.  Otherwise, the 
;			order is determined by the translators.
;
;	tr_override:	String giving a comma-separated list of translators
;			to use instead of those in the translators table.  If
;			this keyword is specified, no translators from the 
;			table are called, but the translators keywords
;			from the table are still used.  
;
;	default_orient:		Default orientation matrix to use if camera
;				orientation is not available.  If not specified, 
;				the identity matrix is used.
;
;
; RETURN:
;	Array of camera descriptors, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a camera descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except cam_name) can still be overridden by specifying 
;	them as keyword parameters.  If cam_name is specified, then
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
function pg_get_cameras, dd, trs, cd=_cd, od=od, pd=pd, $
                          override=override, verbatim=verbatim, default_orient=default_orient, $
                          no_default=no_default, $
@cam__keywords.include
@nv_trs_keywords_include.pro
		end_keywords

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)

 if(keyword_set(od)) then $
   if(n_elements(od) NE n_elements(dd)) then $
           nv_message, 'One observer descriptor required for each data descriptor'

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword_set(override)) then $
  begin
   n = n_elements(name)

   cd=cam_create_descriptors(n, $
	gd=dd, $
	name=name, $
	orient=orient, $
	avel=avel, $
	pos=pos, $
	vel=vel, $
	time=time, $
	fn_focal_to_image=fn_focal_to_image, $
	fn_image_to_focal=fn_image_to_focal, $
	fi_data=fi_data, $
;	fn_filter=fn_filter, $
	filters=filters, $
	scale=scale, $
	fn_psf=fn_psf, $
	size=size, $
	opaque=opaque, $
	exposure=exposure, $
	oaxis=oaxis)
  end $
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; default orientation is identity matrix unless otherwise specifed
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(NOT keyword_set(default_orient)) then default_orient = idgen(3)


   ;-----------------------------------------------
   ; call translators
   ;-----------------------------------------------

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;   if(keyword_set(name)) then tr_first = 1
;tr_first = 1

   cd = dat_get_value(dd, 'CAM_DESCRIPTORS', key1=od, key2=pd, key4=_cd, key3=default_orient, $
                             key7=time, key8=name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword_set(cd)) then return, obj_new()
   n = n_elements(cd)

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
     tr_names = cor_name(cd)
     sub = nwhere(strupcase(tr_names), strupcase(name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   cd = cd[sub]

   ;---------------------------------------------------------------------
   ; override the specified values (name and time cannot be overridden)
   ;---------------------------------------------------------------------
; this might be cleaner using the _extra mechanism
   if(defined(name)) then _name = name & name = !null
   if(defined(time)) then _time = time & time = !null
   cam_assign, cd, /noevent, $
@cam__keywords.include
end_keywords
    if(defined(_name)) then name = _name
    if(defined(_time)) then time = _time

  end


 ;--------------------------------------------------------
 ; update generic descriptors
 ;--------------------------------------------------------
 if(keyword_set(dd)) then dat_set_gd, dd, gd, bx=bx
 dat_set_gd, cd, gd, bx=bx

 return, cd
end
;===========================================================================








