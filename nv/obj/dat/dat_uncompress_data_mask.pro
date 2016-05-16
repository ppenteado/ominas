;=============================================================================
; dat_uncompress_data_mask
;
;=============================================================================
function dat_uncompress_data_mask, _dd, cdata

 dat = *_dd.compress_data_p

 s = dat.size

 ndim = s[0]
 dim = s[1:ndim]
 type = s[ndim+1]

 data = make_array(dim=dim, type=type)
 if(dat.mask[0] NE -1) then data[dat.mask] = cdata

 return, data
end
;=============================================================================
