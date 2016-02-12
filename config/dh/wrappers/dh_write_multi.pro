;=============================================================================
; dh_write_multi.pro
;
;=============================================================================
pro dh_write_multi, filename, data, label, udata, nodata=nodata, silent=silent
; dh_write, dh_fname(filename), tag_list_get(udata, 'DETACHED_HEADER'), silent=silent
 if(NOT keyword_set(nodata)) then write_multi, filename, data, silent=silent
end
;=============================================================================
