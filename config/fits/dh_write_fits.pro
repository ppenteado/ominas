;=============================================================================
; dh_write_fits.pro
;
;=============================================================================
pro dh_write_fits, filename, data, header, udata, abscissa=abscissa, nodata=nodata, silent=silent
 dh_write, dh_fname(/write, filename), tag_list_get(udata, 'DETACHED_HEADER'), silent=silent
 if(NOT keyword__set(nodata)) then $
         write_fits, filename, data, header, silent=silent
end
;=============================================================================
