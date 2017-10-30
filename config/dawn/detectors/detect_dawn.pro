;===========================================================================
; detect_dawn.pro
;
;===========================================================================
function detect_dawn, dd

 label = (dat_header(dd))[0]

 w1 = where(strpos(label, 'FC1') NE -1)
 w2 = where(strpos(label, 'DAWN MISSION') NE -1)
 if((w1[0] NE -1) AND (w2[0] NE -1)) then return, 'DAWN_FC1'

 w1 = where(strpos(label, 'FC2') NE -1)
 w2 = where(strpos(label, 'DAWN MISSION') NE -1)
 if((w1[0] NE -1) AND (w2[0] NE -1)) then return, 'DAWN_FC2'

 return, ''
end
;===========================================================================
