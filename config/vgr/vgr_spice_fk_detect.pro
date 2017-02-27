;=============================================================================
; vgr_spice_fk_detect
;
;=============================================================================
function vgr_spice_fk_detect, dd, kpath, sc=sc, time=time, $
                                                    strict=strict, all=all

 scname = vgr_parse_inst(dat_instrument(dd), cam=cam)
 all_files = file_search(kpath + scname + '_v??.tf')

 return, all_files
end
;=============================================================================
