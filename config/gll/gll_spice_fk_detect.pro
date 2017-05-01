;=============================================================================
; gll_spice_fk_detect
;
;=============================================================================
function gll_spice_fk_detect, dd, kpath, sc=sc, time=time, $
                                                    strict=strict, all=all

 sc = 'gll'
 all_files = file_search(kpath + sc + '_v??.tf')

 return, all_files
end
;=============================================================================
