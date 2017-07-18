;=============================================================================
; dhh_parse_keyword
;
;=============================================================================
pro dhh_parse_keyword, rkw, kw, elm_index, obj_index, hist_index

 kw='' & obj_index=(hist_index=(elm_index=0))

 ;-------------------------------
 ; extract element index
 ;-------------------------------
 elm_index_s = str_ext(rkw, '(', ')', estring, pos=pos)
 if(pos NE -1) then elm_index = long(elm_index_s)

 ;-------------------------------
 ; extract object index
 ;-------------------------------
 obj_index_s = str_ext(estring, '[', ']', ostring, pos=pos)
 if(pos NE -1) then obj_index = long(obj_index_s)

 ;-------------------------------
 ; extract history index
 ;-------------------------------
 hist_index_s = str_ext(ostring, '{', '}', kw, pos=pos)
 if(pos NE -1) then hist_index = long(hist_index_s)

end
;=============================================================================
