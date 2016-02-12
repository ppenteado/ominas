;=============================================================================
;+
; NAME:
;	pg_photom
;
;
; PURPOSE:
;	Photometric image correction for disk or globe objects.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_photom(dd, cd=cd, gbx=gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor containing image to correct.
;
;
;  OUTPUT:
;	NONE
;
; KEYWORDS:
;  INPUT:
;	cd:	Camera descriptor
;
;	gbx:	Globe descriptor
;
;	dkx:	Disk descriptor
;
;	sund:	Sun descriptor
;
;	gd:	Generic descriptor.  If present, cd, dkx, and gbx are taken 
;		from here if contained.
;
; 	outline_ps:	points_struct with image points outlining the 
;			region of the image to correct.  To correct the entire
;			planet, this input could be generated using pg_limb(). 
;			If this keyword is not given, the entire image is used.
;
;	refl_fn:	String naming reflectance function to use.  Default is
;			'pht_minneart'.
;
;	refl_parms:	Array of parameters for the photometric function named
;			by the 'refl_fn' keyword.
;
;	phase_fn:	String naming phase function to use.  Default is none.
;
;	phase_parms:	Array of parameters for the photometric function named
;			by the 'phase_fn' keyword.
;
;  OUTPUT:
;	emm_out:	Image emission angles.
;
;	inc_out:	Image incidence angles.
;
;	phase_out:	Image phase angles.
;
;
; RETURN:
;	Data descriptor containing the corrected image.  The photometric angles
;	emm, inc, and phase are placed in the user data arrays with the tags
;	'EMM', 'INC', and 'PHASE' respectively.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2004
;	
;-
;=============================================================================
function pg_photom, dd, outline_ps=outline_ps, $
                  cd=cd, gbx=gbx, dkx=dkx, sund=sund, gd=gd, $
                  refl_fn=refl_fn, phase_fn=phase_fn, $
                  refl_parm=refl_parm, phase_parm=phase_parm, $
                  emm_out=emm_out, inc_out=inc_out, phase_out=phase_out


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx, dkx=dkx, sund=sund, dd=dd


 ;-----------------------------------------------
 ; call appropriate routine
 ;-----------------------------------------------
 if(keyword__set(gbx)) then $
  return, pg_photom_globe(dd, outline_ps=outline_ps, $
                  cd=cd, gbx=gbx, sund=sund, gd=gd, $
                  refl_fn=refl_fn, phase_fn=phase_fn, $
                  refl_parm=refl_parm, phase_parm=phase_parm, $
                  emm_out=emm_out, inc_out=inc_out, phase_out=phase_out)
  
 return, pg_photom_disk(dd, outline_ps=outline_ps, $
                  cd=cd, dkx=dkx, sund=sund, gd=gd, $
                  refl_fn=refl_fn, phase_fn=phase_fn, $
                  refl_parm=refl_parm, phase_parm=phase_parm, $
                  emm_out=emm_out, inc_out=inc_out, phase_out=phase_out)

end
;=============================================================================
