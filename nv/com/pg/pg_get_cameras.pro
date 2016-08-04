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
;	cds:		Input camera descriptors; used by some translators.
;
;	gd:		Generic descriptor containing the above descriptors.
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
function pg_get_cameras, dd, trs, cds=_cds, od=od, pd=pd, gd=gd, $
                          override=override, verbatim=verbatim, default_orient=default_orient, $
                          no_default=no_default, $
@camera_keywords.include
@nv_trs_keywords_include.pro
		end_keywords

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, od=od, pd=pd, dd=dd

 if(keyword_set(od)) then $
   if(n_elements(od) NE n_elements(dd)) then $
               nv_message, name='pg_get_cameras', $
                    'One observer descriptor required for each data descriptor'

 ;-------------------------------------------------------------------
 ; if /override, create descriptors without calling translators
 ;-------------------------------------------------------------------
 if(keyword_set(override)) then $
  begin
   n = n_elements(cam__name)

   cds=cam_create_descriptors(n, $
	name=cam__name, $
	orient=cam__orient, $
	avel=cam__avel, $
	pos=cam__pos, $
	vel=cam__vel, $
	time=cam__time, $
	fn_focal_to_image=cam__fn_focal_to_image, $
	fn_image_to_focal=cam__fn_image_to_focal, $
	fi_data=cam__fi_data, $
;	fn_filter=cam__fn_filter, $
	filters=cam__filters, $
	scale=cam__scale, $
	fn_psf=cam__fn_psf, $
	size=cam__size, $
	opaque=cam__opaque, $
	exposure=cam__exposure, $
	oaxis=cam__oaxis)
  end $
 else $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; default orientation is identity matrix unless otherwise specifed
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(NOT keyword_set(default_orient)) then default_orient = idgen(3)


   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if names requested, the force tr_first
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(cam__name)) then tr_first = 1
;tr_first = 1

   cds = dat_get_value(dd, 'CAM_DESCRIPTORS', key1=od, key2=pd, key4=_cds, key3=default_orient, $
                             key7=cam__time, key8=cam__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

   if(NOT keyword_set(cds)) then return, obj_new()
   n = n_elements(cds)

   ;---------------------------------------------------
   ; If cam__name given, determine subscripts such that
   ; only values of the named objects are returned.
   ;
   ; Note that each translator has this opportunity,
   ; but this code guarantees that it is done.
   ;
   ; If cam__name is not given, then all descriptors
   ; will be returned.
   ;---------------------------------------------------
   if(keyword__set(cam__name)) then $
    begin
     tr_names = cor_name(cds)
     sub = nwhere(strupcase(tr_names), strupcase(cam__name))
     if(sub[0] EQ -1) then return, obj_new()
     if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
    end $
   else sub=lindgen(n)

   n = n_elements(sub)
   cds = cds[sub]

   ;-------------------------------------------------------------------
   ; override the specified values (cam__name cannot be overridden)
   ;-------------------------------------------------------------------
   w = nwhere(dd, cor_assoc_xd(cds))
   if(n_elements(cam__orient) NE 0) then bod_set_orient, cds, cam__orient[*,*,w]
   if(n_elements(cam__avel) NE 0) then bod_set_avel, cds, cam__avel[*,*,w]
   if(n_elements(cam__pos) NE 0) then bod_set_pos, cds, cam__pos[*,*,w]
   if(n_elements(cam__vel) NE 0) then bod_set_vel, cds, cam__vel[*,*,w]
;   if(n_elements(cam__time) NE 0) then bod_set_time, cds, cam__time[w]
   if(n_elements(cam__fn_focal_to_image) NE 0) then $
                 cam_set_fn_focal_to_image, cds, cam__fn_focal_to_image[w]
   if(n_elements(cam__fn_image_to_focal) NE 0) then $
                 cam_set_fn_image_to_focal, cds, cam__fn_image_to_focal[w]
   if(n_elements(cam__fi_data) NE 0) then cam_set_fi_data, cds, cam__fi_data[w]
   if(n_elements(cam__filters) NE 0) then $
                                    cam_set_filters, cds, cam__filters[*,w]
   if(n_elements(cam__scale) NE 0) then  cam_set_scale, cds, cam__scale[*,w]
   if(n_elements(cam__oaxis) NE 0) then  cam_set_oaxis, cds, cam__oaxis[*,w]
   if(n_elements(cam__fn_psf) NE 0) then  cam_set_fn_psf, cds, cam__fn_psf[w]
   if(n_elements(cam__size) NE 0) then  cam_set_size, cds, cam__size[*,w]
   if(n_elements(cam__opaque) NE 0) then  bod_set_opaque, cds, cam__opaque[w]
   if(n_elements(cam__exposure) NE 0) then $
                                   cam_set_exposure, cds, cam__exposure[w]
  end


 return, cds
end
;===========================================================================








