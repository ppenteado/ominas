;===========================================================================
; detect_vgr_pps.pro
;
;===========================================================================
function detect_vgr_pps, label, udata

 w = where(strpos(label, 'VG1 PPS') NE -1)
 if(w[0] NE -1) then return, 'VGR_PPS'
 w = where(strpos(label, 'VG2 PPS') NE -1)
 if(w[0] NE -1) then return, 'VGR_PPS'

 return, ''
end
;===========================================================================
