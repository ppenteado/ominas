;=============================================================================
; dh_read_vgr_cd.pro
;
;=============================================================================
function dh_read_vgr_cd, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0

 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
 dim = [800l, 800l]
 type = 1
min=0
max=0
 return, read_vgr_cd(filename, label, silent=silent, nodata=nodata)
end
;=============================================================================
