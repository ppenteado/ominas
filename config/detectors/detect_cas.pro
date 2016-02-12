;===========================================================================
; detect_cas.pro
;
;===========================================================================
function detect_cas, label, udata

 if( (strpos(label, 'CAS-ISS1') NE -1) $
      OR ((strpos(label, "'ISSNA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISSNA'
 if( (strpos(label, 'CAS-ISS2') NE -1) $
      OR ((strpos(label, "'ISSWA'") NE -1) AND $
          (strpos(label, 'CASSINI') NE -1)) ) then return, 'CAS_ISSWA'


 return, ''
end
;===========================================================================
