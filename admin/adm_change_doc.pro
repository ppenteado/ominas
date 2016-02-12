;============================================================================
;============================================================================
pro adm_change_doc, filename

 lines = read_txt_file(filename, /raw)


 p = strpos(lines, 'SYNOPSIS:')
 w = where(p NE -1)
 if(w[0] NE -1) then return


 p = strpos(lines, 'PURPOSE:')
 w0 = (where(p NE -1))[0]

 p = strpos(lines, 'CATEGORY:')
 w1 = (where(p NE -1))[0]


 if((w0 EQ -1) OR (w1 EQ -1)) then $
  begin
   p = strpos(lines, 'NAME:')
   w = where(p NE -1)
   if(w[0] NE -1) then print, filename
   return
  end


 block = lines[w0+1:w1-1]
 head = lines[w0[0]]


 lines = [lines[0:w0-1], $
          strep_s(head, 'PURPOSE:', 'SYNOPSIS:'), $
          block, $
          strep_s(head, 'PURPOSE:', 'DESCRIPTION:'), $
          block, $
          lines[w1:*]]




 write_txt_file, filename, lines
end
;============================================================================
