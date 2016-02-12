;=============================================================================
; read_klist
;
;=============================================================================
function read_klist, fname

 ;------------------------------------------
 ; read file
 ;------------------------------------------
 lines = read_txt_file(fname, status=status)
 if(status NE 0) then nv_message,$
         name = 'read_klist', 'Error opening kernel list file ' + fname + '.'

 nlines = n_elements(lines)
 dirs = ''
 

 ;------------------------------------------
 ; parse ck directories
 ;------------------------------------------
 for i=0, nlines-1 do $
  begin
   words = str_sep(strtrim(strcompress(lines[i]),2), ' ')
   if(strupcase(words[0]) EQ 'CKDIR') then $
    begin
     if(n_elements(words) LT 3) then nv_message, $
                           'read_klist', 'Parse error in kernel list file.'
     if(words[1] NE '=') then nv_message, $
                           'read_klist', 'Parse error in kernel list file.'
     dirs = [dirs,strmid(words[2], 1, strlen(words[2])-2)]
    end
  end
  ndirs = n_elements(dirs) - 1
  if(ndirs EQ 0) then return, ''


 ;------------------------------------------
 ; lookup ck files
 ;------------------------------------------
 dirs = dirs[1:*]

 ck_files = ''
 for i=0, ndirs-1 do $
  begin
   files = findfile(dirs[i] + '/*.bc')
   if(files[0] NE '') then ck_files = [ck_files, files]
  end

 if(n_elements(ck_files) EQ 1) then return, ''
 return, ck_files[1:*]
end
;=============================================================================
