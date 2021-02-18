;===========================================================================
; detect_trs_cas_cirscube.pro
;
;===========================================================================
function detect_trs_cas_cirscube, dd, arg, query=query
 if(keyword_set(query)) then return, 'INSTRUMENT'

 compile_opt idl2,logical_predicate
 label = (dat_header(dd));[0]
 if size(label,/type) ne 7 then return,''
 if total(stregex(label,'^INSTRUMENT_((NAME)|(ID))[[:blank:]]*=[[:blank:]]*"?((CIRS)|(COMPOSITE INFRARED SPECTROMETER))"?',/boolean,/fold_case)) then return, 'CAS_CIRSCUBE'

 return, ''
end
;===========================================================================

