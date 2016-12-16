;=============================================================================
;+
; NAME:
;	pg_photom_disk
;
;
; PURPOSE:
;	Photometric image correction for disk objects.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_photom_globe(dd, cd=cd)
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
;	dkx:	Disk descriptor
;
;	sund:	Sun descriptor
;
;	gd:	Generic descriptor.  If present, cd and dkx are taken from 
;		here if contained.
;
; 	outline_ptd:	POINT with image points outlining the 
;			region of the image to correct.  To correct the entire
;			disk, this input could be generated using pg_ring(). 
;			If this keyword is not given, the entire image is used.
;			If two arrays are given, they are taken as the inner
;			and outer boundaries.
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
;	overwrite:	If set, the output descriptor is the input descriptor
;			with the relevant fields modified.
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
;	New data descriptor containing the corrected image.  The photometric 
;	angles emm, inc, and phase are placed in the user data arrays with 
;	the tags'EMM', 'INC', and 'PHASE' respectively.  Unless /overwrite is
;	set, the nw descriptor is a clone of the input descriptor, with the 
;	relevant fields modified.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002 (pg_photom)
;	 Spitale, 6/2004:	changed to pg_photom_disk
;	
;-
;=============================================================================
function pg_photom_disk, dd, outline_ptd=outline_ptd, $
                  cd=cd, dkx=dkx, sund=sund, gd=gd, $
                  refl_fn=refl_fn, phase_fn=phase_fn, $
                  refl_parm=refl_parm, phase_parm=phase_parm, $
                  emm_out=emm_out, inc_out=inc_out, phase_out=phase_out, overwrite=overwrite

; ;-----------------------------------------
; ; default is Minneart
; ;-----------------------------------------
; if(NOT keyword__set(refl_fn)) then refl_fn = 'pht_minneart'

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dkx=dkx, sund=sund, dd=dd


 ;-----------------------------------------------
 ; validate descriptors
 ;-----------------------------------------------
 if(n_elements(cd) GT 1) then nv_message, 'Only one camera descriptor allowed.'
 if(n_elements(dkx) GT 1) then nv_message, 'Only one disk descriptor allowed.'
 if(n_elements(sund) GT 1) then nv_message, 'Only one sun descriptor allowed.'


 ;---------------------------------------
 ; dereference the data descriptor 
 ;---------------------------------------
 image = dat_data(dd)
 s = size(image)
 xsize = s[1] & ysize = s[2]
 xysize = xsize*ysize

 ;---------------------------------------
 ; find relevant image points 
 ;---------------------------------------
 if(keyword__set(outline_ptd)) then $
  begin
   p = pnt_points(outline_ptd[0])
   ii0 = polyfillv(p[0,*], p[1,*], xsize, ysize)
   if(n_elements(outline_ptd) GT 1) then $
    begin
     p = pnt_points(outline_ptd[1])
     ii1 = polyfillv(p[0,*], p[1,*], xsize, ysize)
     inner = ii0 & outer = ii1
     n0 = n_elements(ii0)
     n1 = n_elements(ii1)
     if(n0 GT n1) then $
      begin
       inner = ii1 & outer = ii0
      end

     indices = complement(image, [complement(image, outer), inner])
    end $
   else indices = ii0
  end $
 else indices = lindgen(xysize)

 xarray = indices mod ysize
 yarray = fix(indices / ysize) + 1

 nn = n_elements(xarray)

 image_pts = dblarr(2, nn)
 image_pts[0,*] = xarray
 image_pts[1,*] = yarray


 ;---------------------------------------
 ; compute photometric angles
 ;---------------------------------------
;;; should be pht_angle, I think...
 pht_angles_disk, image_pts, cd, dkx, sund, emm=mu, inc=mu0, g=g, valid=valid
 if(valid[0] EQ -1) then nv_message, 'No valid points in image region.'

 mu0 = mu0[valid] 
 mu = mu[valid] 
 g = g[valid] 
 indices = indices[valid]


 ;---------------------------------------
 ; correct the image
 ;---------------------------------------
 phase_corr = 1d
 if(keyword__set(phase_fn)) then $
                   phase_corr = call_function(phase_fn, g, phase_parm)
 refl_corr = call_function(refl_fn, mu, mu0, refl_parm)

 new_image = float(image)
 new_image[indices] = new_image[indices] / phase_corr / refl_corr
 new_image = new_image < max(image)

 ;---------------------------------------
 ; modify the data descriptor
 ;---------------------------------------
 if(keyword_set(overwrite)) then dd_pht = dd $
 else dd_pht = nv_clone(dd)
 dat_set_data, dd_pht, new_image

 ;---------------------------------------
 ; fill output arrays
 ;---------------------------------------
 emm = fltarr(xsize,ysize)
 emm[indices] = mu
 cor_set_udata, dd_pht, 'EMM', emm

 inc = fltarr(xsize,ysize)
 inc[indices] = mu0
 cor_set_udata, dd_pht, 'INC', inc

 phase = fltarr(xsize,ysize)
 phase[indices] = g
 cor_set_udata, dd_pht, 'PHASE', phase


 return, dd_pht 
end
;=============================================================================
