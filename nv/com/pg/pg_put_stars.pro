;=============================================================================
;+
; NAME:
;	pg_put_stars
;
;
; PURPOSE:
;	Outputs star descriptors through the translators.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_put_stars, dd, sd=sd
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
;	sds:	Star descriptors to output.
;
;	str_*:		All star override keywords are accepted.
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
;	CameStarra descriptors are passed to the translators.  Any star
;	keywords are used to override the corresponding quantities in the
;	output descriptors.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_put_planets, pg_put_rings, pg_put_cameras, pg_put_maps
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================
pro pg_put_stars, dd, trs, sds=_sds, ods=ods, $
@str__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 sds = nv_clone(_sds)


 ;-------------------------------------------------------------------
 ; override the specified values (name cannot be overridden)
 ;-------------------------------------------------------------------
 if(n_elements(lum) NE 0) then str_set_lum, sds, lum
 if(n_elements(sp) NE 0) then str_set_sp, sds, sp
 if(n_elements(orient) NE 0) then bod_set_orient, sds, orient
 if(n_elements(avel) NE 0) then bod_set_avel, sds, avel
 if(n_elements(pos) NE 0) then bod_set_pos, sds, pos
 if(n_elements(str__vel) NE 0) then bod_set_vel, sds, str__vel
 if(n_elements(time) NE 0) then bod_set_time, sds, time
 if(n_elements(radii) NE 0) then glb_set_radii, sds, radii
 if(n_elements(lora) NE 0) then glb_set_lora, sds, lora


 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 dat_put_value, dd, 'STR_DESCRIPTORS', sds, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords


 nv_free, sds
end
;===========================================================================



