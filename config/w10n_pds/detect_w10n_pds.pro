;===========================================================================
; detect_w10n_pds.pro
;
;===========================================================================
function detect_w10n_pds, dd

 header = dat_header(dd)
 if(keyword_set(header)) then return, 0

 filename = dat_filename(dd)
 if(filename EQ 'www......') then return, 1

 return, 0
end
;===========================================================================
