;------------------------------------------------------------------------------
; NAME: CLEANARR
;     
; PURPOSE: To remove all unprintable characters from the given string
; 
; CALLING SEQUENCE: Result = CLEANARR (textarr, [/SPACE])
; 
; INPUTS:
;    Text: array of scalar strings of characters to be cleaned
; OUTPUTS:
;    Result: array of scalar string of characters removed of all unprintable 
;            characters
;
; OPTIONAL INPUTS:
;    SPACE: removes all unprintable characters including all space chars.
;
; EXAMPLE:
;    To remove all unprintable chars except space
;       IDL> arr = ['the [tab]file','is [lf][cr]']
;       IDL> word = CLEANARR (arr)
;       IDL> print, word
;            the file is
;    To remove all unprintable chars including space
;       IDL> word = CLEANARR (arr,/SPACE)
;       IDL> print, word
;            thefile is
;
; PROCEDURES USED: CLEAN
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [October 2, 2003]
;    For a complete list of modifications, see changelog.txt file.
;
;------------------------------------------------------------------------------

function CLEANARR, textarr, SPACE=space
   if keyword_set(SPACE) then space = 1 else space = 0
   stat = size(textarr)
   dim = stat[0]
   if (dim EQ 1) then begin
      i = long(0)
      imax = stat[1]-1
      while i LE imax do begin
         if space EQ 1 then $
            textarr[i] = CLEAN(textarr[i],/SPACE) $
         else textarr[i] = CLEAN(textarr[i])
         i = i + 1
      endwhile
   endif else if (dim EQ 2) then begin
      i = long(0)
      j = long(0)
      imax = stat[1]-1
      jmax = stat[2]-1
      while i LE imax do begin
         while j LE jmax do begin
            if space EQ 1 then $
               textarr[i,j] = CLEAN(textarr[i,j],/SPACE) $
            else textarr[i,j] = CLEAN(textarr[i,j])
            j = j + 1
         endwhile
         i = i + 1
      endwhile
   endif else if (dim EQ 0) then begin
      if space EQ 1 then $
         textarr = CLEAN(textarr,/SPACE) $
      else textarr = CLEAN(textarr)
   endif

   return, textarr   
end
