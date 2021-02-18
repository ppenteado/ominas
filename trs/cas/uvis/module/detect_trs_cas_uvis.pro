;===========================================================================
; detect_trs_cas_uvis.pro
;
;===========================================================================
function detect_trs_cas_uvis, dd, arg, query=query
 if(keyword_set(query)) then return, 'INSTRUMENT'

 label = (dat_header(dd));[0]
  if ~isa(label,'string') then return,0
  if total(stregex(label,'^INSTRUMENT_((NAME)|(ID))[[:blank:]]*=[[:blank:]]*"?((UVIS)|(ULTRAVIOLET IMAGING SPECTROGRAPH))"?',/boolean,/fold_case)) then return, 'CAS_UVIS'

 return, ''
end
;===========================================================================

