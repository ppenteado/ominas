;===========================================================================
; detect_map.pro
;
;===========================================================================
function detect_map, label, udata

 dh = tag_list_get(udata, 'DETACHED_HEADER')

 s = size(dh)
 type = s[s[0]+1]
 if(type NE 7) then return, ''

 w = where(strpos(dh, 'map_name') NE -1)
 if(w[0] EQ -1) then return, ''

 w = where(strpos(dh, 'map_type') NE -1)
 if(w[0] EQ -1) then return, ''

 w = where(strpos(dh, 'map_size') NE -1)
 if(w[0] EQ -1) then return, ''

 return, 'MAP'
end
;===========================================================================
