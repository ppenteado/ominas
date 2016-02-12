;=============================================================================
; dh_write_tdl.pro
;
;=============================================================================
pro dh_write_tdl, filename, data, label, udata, nodata=nodata, silent=silent
 dh_write, dh_fname(filename), tag_list_get(udata, 'DETACHED_HEADER'), silent=silent
 if(NOT keyword__set(nodata)) then $
       write_tdl, filename, data, label, silent=silent
end
;=============================================================================
