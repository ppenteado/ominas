;=============================================================================
; text_frame
;
;=============================================================================
function text_frame, inlines, ncol, c=c

 if(NOT keyword_set(ncol)) then ncol = 80
 if(NOT keyword_set(c)) then c = '*'

 bar = str_pad('', ncol, c=c)
 len = max(strlen(inlines))

 text = str_pad(inlines, len)
 nspace = (ncol - len)/2 - 1
 space = str_pad('', nspace)

 text = str_pad(c + space + inlines, ncol-1) + c

 return, [bar, text, bar]
end
;=============================================================================
