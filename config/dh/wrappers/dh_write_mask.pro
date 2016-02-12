;=============================================================================
; dh_write_mask.pro
;
;=============================================================================
pro dh_write_mask, filename, data, header, udata, nodata=nodata, silent=silent
 if(NOT keyword__set(nodata)) then write_mask, filename, data, header
end
;=============================================================================
