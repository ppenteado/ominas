;=============================================================================
; dh_get.pro
;
; Extracts a detached header from the given data descriptor
;
;=============================================================================
function dh_get, dd
 dh=nv_udata(dd, 'DETACHED_HEADER')
 if(keyword__set(dh)) then return, dh
 return, ''
end
;=============================================================================
