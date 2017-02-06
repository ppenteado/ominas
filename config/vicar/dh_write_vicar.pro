;=============================================================================
; dh_write_vicar.pro
;
;=============================================================================
pro dh_write_vicar, filename, data, label, udata, abscissa=abscissa, nodata=nodata, silent=silent
 dh_write, dh_fname(/write, filename), tag_list_get(udata, 'DETACHED_HEADER'), silent=silent
 if(NOT keyword_set(nodata)) then $
       write_vicar, filename, data, label, silent=silent
end
;=============================================================================
