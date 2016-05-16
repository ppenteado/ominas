;=============================================================================
; vgr_spice_spk_detect
;
;=============================================================================
function vgr_spice_spk_detect, dd, kpath, reject=spk_reject_files, $
                   strict=strict, all=all, time=_time

 sc = vgr_parse_inst(dat_instrument(dd), cam=cam)
 all_files = findfile(kpath + sc + '_???.bsp')

 return, all_files
end
;=============================================================================
