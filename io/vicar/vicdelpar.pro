;=============================================================================
; vicdelpar
;
;
;=============================================================================
pro vicdelpar, label, keyword

 keyword= keyword + '='

 p = strpos(label, keyword)
 if(p[0] EQ -1) then return

 result = ''
 if(p[0] NE 0) then result = strmid(label, 0, p[0])

 s = strmid(label, p[0]+strlen(keyword), strlen(label)-p[0]-strlen(keyword))
 p = strpos(s, '=')
 if(p[0] EQ -1) then $
  begin
   label = result
   return
  end

 ss = strmid(s, 0, p[0])
 p = strpos(ss, ' ', /reverse_search)
 result = result + strmid(s, p[0]+1, strlen(s)-p[0]-1)

 label = result
end
;=============================================================================
