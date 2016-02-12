;==============================================================================
; gll_psf
;
;==============================================================================
function gll_psf, inst

nv_message, /con, name='gll_psf', 'WARNING: Galileo PSF not determined.'
return, 1d


 case inst of
  'ISSNA' :	return, 0.7d
  'ISSWA' :	return, 0.8d
 endcase

end
;==============================================================================
