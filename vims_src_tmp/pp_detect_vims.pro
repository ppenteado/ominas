;===========================================================================
; pp_detect_vims.pro
;
;===========================================================================
function pp_detect_vims, label, udata

  groupre='([[:<:]]GROUP[[:space:]]*=[[:space:]]*ISIS_INSTRUMENT[[:>:]])(.*)'+$
    '([[:<:]]END_GROUP[[:space:]]*=[[:space:]]*ISIS_INSTRUMENT[[:>:]])'
  if stregex(label,groupre,/boolean) then begin
    group=(stregex(label,groupre,/subexpr,/extract))[2]
    if stregex(group,'[[:<:]]INSTRUMENT_ID[[:space:]]*=[[:space:]]*("VIMS")|(VIMS)',/boolean) then begin
      channel=stregex(group,'[[:<:]]CHANNEL[[:space:]]*=[[:space:]]*(("([[:alnum:]]+)")|([[:alnum:]]+))',/extract,/subexpr)
      channel=channel[-1] ? channel[-1] : channel[-2]
      return,channel ? 'VIMS_'+channel : ''
    endif
  endif
    
; if( (strpos(label, 'CAS-ISS1') NE -1) $
;      OR ((strpos(label, "'ISSNA'") NE -1) AND $
;          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISSNA'
; if( (strpos(label, 'CAS-ISS2') NE -1) $
;      OR ((strpos(label, "'ISSWA'") NE -1) AND $
;          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISSWA'


 return, ''
end
;===========================================================================
