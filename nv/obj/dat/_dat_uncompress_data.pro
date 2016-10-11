;================================================================================
; _dat_uncompress_data
;
;================================================================================
pro _dat_uncompress_data, _dd, cdata=cdata, cabscissa=cabscissa

 cdata = data_archive_get(_dd.data_dap, _dd.dap_index)
 cabscissa = data_archive_get(_dd.abscissa_dap, _dd.dap_index)

 if(keyword_set(_dd.compress)) then $
                   call_procedure, 'dat_uncompress_data_' + _dd.compress, _dd

end
;================================================================================
