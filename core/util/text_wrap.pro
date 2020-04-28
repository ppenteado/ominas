;==============================================================================
; text_wrap
;
;==============================================================================
function text_wrap, inlines, ncol

 if(NOT keyword_set(ncol)) then ncol = 80

 nlines = n_elements(inlines)

 for i=0, nlines-1 do $
  begin
   if(strtrim(inlines[i],2) EQ '') then lines = append_array(lines, [inlines[i]]) $
     else $
      begin
     p = 0
     repeat $
      begin
       pp = -1
       test = strmid(inlines[i], p, ncol)
       if(strlen(test) LT ncol) then lines = append_array(lines, test) $
       else $
        begin
         pp = strpos(test, ' ', /reverse_search)
         if(pp[0] NE -1) then $
          begin
           lines = append_array(lines, strmid(test, 0, pp))
           p = p + pp + 1
          end
        end
      endrep until(pp[0] EQ -1)
    end
  end

 return, lines
end
;==============================================================================
