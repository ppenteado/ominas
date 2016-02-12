;=============================================================================
; strip_comment
;
;=============================================================================
function strip_comment, _lines, comment_char=comment_char, $
      only_char=only_char, exclude_char=exclude_char, w=_w

 if(NOT keyword_set(_lines)) then return, ''

 if(NOT keyword__set(comment_char)) then comment_char = '#'
 if(NOT keyword__set(only_char)) then only_char = '+'
 if(NOT keyword__set(exclude_char)) then exclude_char = '-'

 lines = _lines
 _w = -1


 ;---------------------------------
 ; remove comments
 ;---------------------------------
 p = strpos(lines, comment_char)
 w = where(p EQ -1)

 if(w[0] NE -1) then lines[w] = lines[w] + comment_char
 new_lines = strtrim(str_nnsplit(lines, comment_char), 2)

 w = where(new_lines NE '')
 if(w[0] EQ -1) then return, ''

 new_lines = new_lines[w]
 _w = w


 ;--------------------------------------------------------------------
 ; accept only lines starting with "only" char, unless there are none
 ;--------------------------------------------------------------------
 p = strpos(new_lines, only_char)
 w = where(p EQ 0)
 if(w[0] NE -1) then $
  begin
   junk = str_nnsplit(new_lines[w], only_char, rem=new_lines)
   new_lines = strtrim(new_lines, 2)
   _w = _w[w]
  end


 ;--------------------------------------------------------------------
 ; exclude lines with starting "exclude" char, unless there are none
 ;--------------------------------------------------------------------
; p = strpos(new_lines, exclude_char)
; w = complement(p, where(p EQ 0))
; if(w[0] NE -1) then $
;  begin
;   new_lines = new_lines[w]
;   _w = _w[w]
;  end



 return, new_lines
end
;=============================================================================



