;=============================================================================
;+
; NAME:
;	pg_put_planets
;
;
; PURPOSE:
;	Outputs planet descriptors through the translators.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_put_planets, dd, pd=pd
;	pg_put_planets, dd, gd=gd
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
;	pds:	Planet descriptors to output.
;
;	gd:	Generic descriptor.  If present, planet descriptors are
;		taken from the gd.pd field.
;
;	plt_*:		All planet override keywords are accepted.
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
;	Planet descriptors are passed to the translators.  Any planet
;	keywords are used to override the corresponding quantities in the
;	output descriptors.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_put_cameras, pg_put_rings, pg_put_stars, pg_put_maps
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================
pro pg_put_planets, dd, trs, pds=pds, ods=ods, gd=gd, $
@planet_keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword_set(gd)) then $
  begin
   if(NOT keyword_set(pds)) then pds=gd.pds
   if(NOT keyword_set(ods)) then ods=gd.ods
  end
 if(NOT keyword_set(pds)) then nv_message, $
                                name='pg_put_planets', 'No planet descriptor.'
 if(NOT keyword_set(ods)) then nv_message, $
                               name='pg_put_planets', 'No observer descriptor.'


 ;-------------------------------------------------------------------
 ; override the specified values (plt__name cannot be overridden)
 ;-------------------------------------------------------------------
 if(n_elements(plt__orient) NE 0) then bod_set_orient, pds, plt__orient
 if(n_elements(plt__avel) NE 0) then bod_set_avel, pds, plt__avel
 if(n_elements(plt__pos) NE 0) then bod_set_pos, pds, plt__pos
 if(n_elements(plt__vel) NE 0) then bod_set_vel, pds, plt__vel
 if(n_elements(plt__time) NE 0) then bod_set_time, pds, plt__time
 if(n_elements(plt__radii) NE 0) then glb_set_radii, pds, plt__radii
 if(n_elements(plt__lora) NE 0) then glb_set_lora, pds, plt__lora


 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 nv_put_value, dd, 'PLT_DESCRIPTORS', pds, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords


end
;===========================================================================



