;=============================================================================
; dhh_parse_line
;
;=============================================================================
pro dhh_parse_line, line, rkw, val

 rkw='' & val=''

 ;---------------------
 ; ignore blank lines
 ;---------------------
 if(strtrim(line,2) EQ '') then return

 ;-------------------------------
 ; strip off the keyword
 ;-------------------------------
 s = str_split(line, '=')
 if(n_elements(s) LT 2) then return   ;!! error !!
 rkw = strtrim(s[0], 2) & kline = s[1]

 ;-------------------------------------------------------------------------
 ; strip off the comment - note that this does not allow for '/' to appear
 ; within a quoted string; this should be rectified.
 ;-------------------------------------------------------------------------
 val = strtrim((str_split(kline, '/'))[0], 2)


end
;=============================================================================
