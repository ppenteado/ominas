;===========================================================================
; detect_cas_vims.pro
;
;===========================================================================
function detect_cas_vims, dd

 label = (dat_header(dd))[0]
 
 groupre='([[:<:]]GROUP[[:space:]]*=[[:space:]]*ISIS_INSTRUMENT[[:>:]])(.*)'+$
   '([[:<:]]END_GROUP[[:space:]]*=[[:space:]]*ISIS_INSTRUMENT[[:>:]])'
 if stregex(label,groupre,/boolean) then begin
   group=(stregex(label,groupre,/subexpr,/extract))[2]
   if stregex(group,'[[:<:]]INSTRUMENT_ID[[:space:]]*=[[:space:]]*("VIMS")|(VIMS)',/boolean) then begin
     channel=stregex(group,'[[:<:]]CHANNEL[[:space:]]*=[[:space:]]*(("([[:alnum:]]+)")|([[:alnum:]]+))',/extract,/subexpr)
     channel=channel[-1] ? channel[-1] : channel[-2]
     return,channel ? 'CAS_VIMS_'+channel : ''
   endif
 endif

 if( (strpos(label, 'CAS-ISS1') NE -1) $
      OR ((strpos(label, "'ISSNA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISS_NA'
 if( (strpos(label, 'CAS-ISS2') NE -1) $
      OR ((strpos(label, "'ISSWA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISS_WA'


 return, ''
end
;===========================================================================
