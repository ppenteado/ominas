;=============================================================================
; vgr_spice_ik_detect
;
;=============================================================================
function vgr_spice_ik_detect, dd, kpath, time=time, reject=reject, $
                                                  strict=strict, all=all

 sc = vgr_parse_inst(dat_instrument(dd), cam=cam)
 all_files = file_search(kpath + sc + '_iss' + cam + '_v??.ti')

 return, all_files
end
;=============================================================================
