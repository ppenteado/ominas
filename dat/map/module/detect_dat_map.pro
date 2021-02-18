;===========================================================================
; detect_dat_map.pro
;
;===========================================================================
function detect_dat_map, dd, arg, query=query
 if(keyword_set(query)) then return, 'INSTRUMENT'

 dh = dat_dh(dd)

 s = size(dh)
 type = s[s[0]+1]
 if(type NE 7) then return, ''

 w = where(strpos(dh, 'map_name') NE -1)
 if(w[0] EQ -1) then return, ''

 w = where(strpos(dh, 'map_projection') NE -1)
 if(w[0] EQ -1) then return, ''

 w = where(strpos(dh, 'map_size') NE -1)
 if(w[0] EQ -1) then return, ''

 return, 'MAP'
end
;===========================================================================
