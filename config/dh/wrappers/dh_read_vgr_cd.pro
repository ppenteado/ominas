;=============================================================================
; dh_read_vgr_cd.pro
;
;=============================================================================
function dh_read_vgr_cd, filename, label, udata, dim, type, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
 dim = [800l, 800l]
 type = 1
 return, read_vgr_cd(filename, label, silent=silent, nodata=nodata)
end
;=============================================================================
