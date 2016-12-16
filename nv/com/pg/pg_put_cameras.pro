;=============================================================================
;+
; NAME:
;	pg_put_cameras
;
;
; PURPOSE:
;	Outputs camera descriptors through the translators.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_put_cameras, dd, cd=cd
;	pg_put_cameras, dd, gd=gd
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	trs:	String containing keywords and values to be passed directly
;		to the translators as if they appeared as arguments in the
;		translators table.  These arguments are passed to every
;		translator called, so the user should be aware of possible
;		conflicts.  Keywords passed using this mechanism take 
;		precedence over keywords appearing in the translators table.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	cds:	Camera descriptors to output.
;
;	gd:	Generic descriptor.  If present, camera descriptors are
;		taken from the gd.cd field.
;
;	cam_*:		All camera override keywords are accepted.
;
;	tr_override:	String giving a comma-separated list of translators
;			to use instead of those in the translators table.  If
;			this keyword is specified, no translators from the 
;			table are called, but the translators keywords
;			from the table are still used.  
;
;  OUTPUT:
;	NONE
;
;
; SIDE EFFECTS:
;	Translator-dependent.  The data descriptor may be affected.
;
;
; PROCEDURE:
;	Camera descriptors are passed to the translators.  Any camera
;	keywords are used to override the corresponding quantities in the
;	output descriptors.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_put_planets, pg_put_rings, pg_put_stars, pg_put_maps
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================
pro pg_put_cameras, dd, trs, gd=gd, cds=cds, $
@cam__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword__set(gd)) then $
  begin
   if(NOT keyword__set(cds)) then cds=gd.cd
  end
 if(NOT keyword__set(cds)) then nv_message, 'No camera descriptor.'

 ;-------------------------------------------------------------------
 ; override the specified values (name cannot be overridden)
 ;-------------------------------------------------------------------
 if(n_elements(orient) NE 0) then bod_set_orient, cds, orient
 if(n_elements(avel) NE 0) then bod_set_avel, cds, avel
 if(n_elements(pos) NE 0) then bod_set_pos, cds, pos
 if(n_elements(vel) NE 0) then bod_set_vel, cds, vel
 if(n_elements(time) NE 0) then bod_set_time, cds, time
 if(n_elements(fn_focal_to_image) NE 0) then $
                cam_set_fn_focal_to_image, cds, fn_focal_to_image
 if(n_elements(fn_image_to_focal) NE 0) then $
                cam_set_fn_image_to_focal, cds, fn_image_to_focal
 if(n_elements(fi_data) NE 0) then cam_set_fi_data, cds, fi_data
 if(n_elements(scale) NE 0) then cam_set_scale, cds, scale
 if(n_elements(oaxis) NE 0) then cam_set_oaxis, cds, oaxis
 if(n_elements(size) NE 0) then cam_set_size, cds, size
 if(n_elements(exposure) NE 0) then cam_set_exposure, cds, exposure


 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 dat_put_value, dd, 'CAM_DESCRIPTORS', cds, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords


end
;===========================================================================



