;===============================================================================
; dat_slice_offset
;
;===============================================================================
function dat_slice_offset, dd
 _dd = cor_dereference(dd)

 slice = dat_slice(_dd, dd0=dd0)
 m = n_elements(slice)

 dim0 = dat_dim(dd0)

 dim = dat_dim(_dd)
 ndim = n_elements(dim)
 nelm = long(product(dim))

 offset = 0

 nn = nelm

 for i=0, m-1 do $
  begin
   offset = offset + nn*slice[i]
   nn = nn*dim0[ndim+i]
  end

 return, offset
end
;===============================================================================
