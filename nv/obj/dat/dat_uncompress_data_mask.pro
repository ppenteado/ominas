;=============================================================================
; dat_uncompress_data_mask
;
;=============================================================================
function dat_uncompress_data_mask, _dd, cdata, abscissa=cabscissa

 dat = *_dd.compress_data_p

 s = dat.size

 ndim = s[0]
 dim = s[1:ndim]
 type = s[ndim+1]

 data = make_array(dim=dim, type=type)
 if(keyword_set(cabscissa)) then abscissa = make_array(dim=dim, type=type)
 if(dat.mask[0] NE -1) then $
  begin
   data[dat.mask] = cdata
   if(keyword_set(abscissa)) then abscissa[dat.mask] = cabscissa
  end

 return, data
end
;=============================================================================
