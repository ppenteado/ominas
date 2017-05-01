;================================================================================
; _dat_compress_data
;
;================================================================================
pro _dat_compress_data, _dd, cdata=cdata, cabscissa=cabscissa

 if(defined(cdata)) then $
  begin
   data_archive_set, _dd.data_dap, cdata, index=_dd.dap_index, /noarchive
   if(keyword_set(cabscissa)) then $
        data_archive_set, _dd.abscissa_dap, cabscissa, index=_dd.dap_index, /noarchive
   return
  end

 if(keyword_set(_dd.compress)) then $
                   call_procedure, 'dat_compress_data_' + _dd.compress, _dd

end
;================================================================================
