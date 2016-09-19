;=============================================================================
; dat_uncompress_data_mask
;
;=============================================================================
pro dat_uncompress_data_mask, _dd

 dat = *_dd.compress_data_p
 cdata = data_archive_get(_dd.data_dap, _dd.dap_index)
 cabscissa = data_archive_get(_dd.abscissa_dap, _dd.dap_index)

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

 data_archive_set, _dd.data_dap, data, index=_dd.dap_index
 if(keyword_set(abscissa)) then $
        data_archive_set, _dd.abscissa_dap, abscissa, index=_dd.dap_index
end
;=============================================================================



