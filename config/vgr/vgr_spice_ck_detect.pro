;=============================================================================
; vgr_spice_ck_detect
;
;=============================================================================
function vgr_spice_ck_detect, dd, kpath, djd=djd, time=time, $
                             all=all, reject=reject, strict=strict

 sc = vgr_parse_inst(dat_instrument(dd), cam=cam)
 all_files = file_search(kpath + sc + '_???_???_' + cam + '.bc')

 return, all_files
end
;=============================================================================
