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
;	pd:	Planet descriptors to output.
;
;	plt_*:		All planet override keywords are accepted.
;
;	raw:		If set, no aberration corrections are performed.
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
pro pg_put_planets, dd, trs, pd=_pd, ods=ods, raw=raw, $
@plt__keywords.include
@nv_trs_keywords_include.pro
		end_keywords


 ;-------------------------------------------------------------------
 ; override the specified values (name cannot be overridden)
 ;-------------------------------------------------------------------
 pd = nv_clone(_pd)
 name = ''

 plt_assign, pd, /noevent, $
@plt__keywords.include
end_keywords


 ;-------------------------------------------------------------------
 ; invert aberration corrections
 ;-------------------------------------------------------------------
 if(keyword_set(ods) AND (NOT keyword_set(raw))) then $
  for i=0, n_elements(dd)-1 do $
   begin
    w = where(cor_gd(pd, /dd) EQ dd[i])
    if(w[0] NE -1) then abcorr, ods[i], pd[w], c=pgc_const('c'), /invert
   end


 ;-------------------------------
 ; put descriptor
 ;-------------------------------
 dat_put_value, dd, 'PLT_DESCRIPTORS', pd, trs=trs, $
@nv_trs_keywords_include.pro
                             end_keywords

 nv_free, pd
end
;===========================================================================



