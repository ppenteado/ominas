;===========================================================================
; detect_cas_iss.pro
;
;===========================================================================
function detect_cas_iss, dd

 label = dat_header(dd) 

 if( (strpos(label, 'CAS-ISS1') NE -1) $
      OR ((strpos(label, "'ISSNA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISS_NA'
 if( (strpos(label, 'CAS-ISS2') NE -1) $
      OR ((strpos(label, "'ISSWA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISS_WA'


 return, ''
end
;===========================================================================
