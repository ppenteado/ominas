;=============================================================================
; poly_flux
;
;=============================================================================
function poly_flux, image, p, ext_flux=ext_flux, norm=norm, show=show, $
                     ext_indices=ext_indices, indices=indices

 ext_flux = 0

 s = size(image)

; indices = polyfillv(p[0,*], p[1,*], s[1], s[2])
 indices = poly_fillv(p, s)
 if(indices[0] EQ -1) then return, 0

 ext_indices = complement(image, indices)

 flux = total(image[indices])
 ext_flux = 0d
 if(ext_indices[0] NE -1) then ext_flux = total(image[ext_indices])

 if(keyword__set(norm)) then $
  begin
   flux = flux/double(n_elements(indices))
   ext_flux = ext_flux/double(n_elements(ext_indices))
  end

 return, flux
end
;=============================================================================
