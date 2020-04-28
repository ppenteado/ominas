;===========================================================================
; spice_read_targets
;
; Reads target list file.  One target per line, lines beginning with '#'
; ignored.
;
;===========================================================================
function spice_read_targets, fname

 if(NOT keyword__set(fname)) then return, ''

 targets = read_txt_file(fname, status=status)
 if(status EQ -1) then return, '' 

 w = where(strmid(targets, 0, 1) NE '#')
 targets = targets[w]

 return, strtrim(strupcase(targets), 2)
end
;===========================================================================
