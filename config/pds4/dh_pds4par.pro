;=============================================================================
; dh_pds4par.pro
;
;=============================================================================
pro dh_pds4par, label, keyword, get=get, set=set


stop



 if(arg_present(get)) then get = pdspar(label, keyword)

; NOTE the pds package does not seem to include a routine for writing keywords.

end
;=============================================================================
