;=============================================================================
; gll_spice_ik_detect
;
;=============================================================================
function gll_spice_ik_detect, dd, kpath, sc=sc, time=time, $
                                        strict=strict, all=all

 sc = 'gll'
 all_files = file_search(kpath + sc + '_ssi' + '_v??.ti')

 return, all_files
end
;=============================================================================
