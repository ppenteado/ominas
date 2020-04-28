;=============================================================================
; dh_read_vgr_cd.pro
;
;=============================================================================
function dh_read_vgr_cd, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

 dim = [800l, 800l]
 type = 1
min=0
max=0
 return, read_vgr_cd(filename, label, nodata=nodata)
end
;=============================================================================
