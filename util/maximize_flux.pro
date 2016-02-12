;=============================================================================
; mxfx_show
;
;=============================================================================
pro mxfx_show, image, outline_pts, t, show

 if(n_elements(show) EQ 1) then tvim, image $
 else tvim, image, xsize=show[0], ysize=show[1]

 n = n_elements(outline_pts)/2
 tt = t#make_array(n, val=1d)

 plots, outline_pts+tt, psym=3
end
;=============================================================================



;=============================================================================
; mxfx_compute_flux
;
;=============================================================================
function mxfx_compute_flux, image, outline_pts, t, corners=corners,  $
             norm=norm, flux=flux, ext_flux=ext_flux, $
             ext_indices=ext_indices, indices=indices


 n = n_elements(outline_pts)/2
 tt = t#make_array(n, val=1d)

 flux = poly_flux(image, outline_pts+tt, ext_flux=ext_flux, /norm, $
                                  ext_indices=ext_indices, indices=indices) 

 if((NOT keyword__set(flux)) AND (NOT keyword__set(ext_flux))) then $
                                                  return, -(flux + ext_flux)
 return, flux - ext_flux
end
;=============================================================================



;=============================================================================
; maximize_flux
;
;=============================================================================
function maximize_flux, image, outline_pts, correlation, $
   show=show, nsamples=nsamples, nohome=nohome, $
   corners=corners, kill_char=kill_char, region=region, data=data, $
   wx=wx, wy=wy, no_width=no_width, bias=bias, fn_show=fn_show, nsig=nsig, $
   flux=flux, ext_flux=ext_flu, nofit=nofit, verbose=verbose

 verbose = keyword_set(verbose)
 if(NOT keyword__set(nsamples)) then nsamples = [4,4]

 t = [0d,0d]
 if(NOT keyword_set(nofit)) then $
   t = grid_correlate(image, outline_pts, correlation, $
	function_max='mxfx_compute_flux', fn_show='mxfx_show', $
	show=show, nsamples=nsamples, nohome=nohome, $
	corners=corners, kill_char=kill_char, region=region, data=data, $
	wx=wx, wy=wy, no_width=no_width, bias=bias)


 if(keyword__set(nsig)) then $
  begin
   xx = mxfx_compute_flux(image, outline_pts, t, corners=corners,  $
             norm=norm, flux=flux, ext_flux=ext_flux, $
             ext_indices=ext_indices, indices=indices)

   if(NOT keyword__set(ext_indices)) then return, 0
   if(n_elements(ext_indices) LT 10) then return, 0
   if(ext_indices[0] EQ -1) then return, 0
   ext_sigma = stdev(image[ext_indices])

   if(n_elements(indices) EQ 1) then return, 0
   sigma = stdev(image[indices])
   if(verbose) then help, flux, ext_flux, ext_sigma
   if(abs(flux - ext_flux) LE nsig*ext_sigma) then return, 0
  end


 return, t
end
;=============================================================================

