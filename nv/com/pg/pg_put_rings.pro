;=============================================================================
;+
; NAME:
;	pg_put_rings
;
;
; PURPOSE:
;	Outputs ring descriptors through the translators.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_put_rings, dd, rd=rd
;	pg_put_rings, dd, gd=gd
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
;	rds:	Ring descriptors to output.
;
;	gd:	Generic descriptor.  If present, ring descriptors are
;		taken from the gd.rd field.
;
;	rng_*:		All ring override keywords are accepted.
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
;	Ring descriptors are passed to the translators.  Any ring
;	keywords are used to override the corresponding quantities in the
;	output descriptors.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_put_planets, pg_put_cameras, pg_put_stars, pg_put_maps
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================
pro pg_put_rings, dd, trs, rds=rds, ods=ods, gd=gd, $
@rng__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword_set(gd)) then $
  begin
   if(NOT keyword_set(rds)) then rds=gd.rds
   if(NOT keyword_set(ods)) then ods=gd.ods
  end
 if(NOT keyword_set(rds)) then nv_message, 'No ring descriptor.'
 if(NOT keyword_set(ods)) then nv_message, 'No observer descriptor.'


   ;-------------------------------------------------------------------
   ; override the specified values (name cannot be overridden)
   ;-------------------------------------------------------------------
   if(n_elements(primary) NE 0) then rng_set_primary, rds, primary

   if(n_elements(orient) NE 0) then bod_set_orient, rds, orient
   if(n_elements(avel) NE 0) then bod_set_avel, rds, avel
   if(n_elements(pos) NE 0) then bod_set_pos, rds, pos
   if(n_elements(rng__vel) NE 0) then bod_set_vel, rds, rng__vel
   if(n_elements(time) NE 0) then bod_set_time, rds, time

   if(n_elements(sma) NE 0) then dsk_set_sma, rds, sma
   if(n_elements(ecc) NE 0) then dsk_set_ecc, rds, ecc
   if(n_elements(nm) NE 0) then dsk_set_nm, rds, nm
   if(n_elements(m) NE 0) then dsk_set_m, rds, m
   if(n_elements(em) NE 0) then dsk_set_em, rds, em
   if(n_elements(wm) NE 0) then dsk_set_wm, rds, wm
   if(n_elements(dwmdt) NE 0) then dsk_set_dwmdt, rds, dwmdt


 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 dat_put_value, dd, 'RNG_DESCRIPTORS', rds, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords


end
;===========================================================================


