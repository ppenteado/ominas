;=============================================================================
;+
; NAME:
;	read_txt_table
;
;
; PURPOSE:
;	Reads a text file composed of rows and columns into an array.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = read_txt_table(filename)
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	Name of file to read
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	comment_char:	String giving character to use as line comment.
;			Defaults to '#'.
;
;	continue_char:	String giving character to use for line continuation.
;			Defaults to '\'.
;
;	delim_char:	String giving character to use to delimit columns.
;			Defaults to ' '.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	Array (ncolumns,nrows) of strings.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2002
;	
;-
;=============================================================================
function read_txt_table, filename, lines=lines, header=header, raw=raw, all=all, $
      comment_char=comment_char, continue_char=continue_char, delim_char=delim_char


 if(NOT keyword_set(comment_char)) then comment_char ='#'
 if(NOT keyword_set(continue_char)) then continue_char ='\'
 if(NOT keyword_set(delim_char)) then delim_char =' '


 ;===============================
 ; read file
 ;===============================
 if(NOT keyword_set(lines)) then lines = read_txt_file(filename, all=all, raw=raw)
 if(NOT keyword_set(lines)) then return, ''
 lines = strtrim(lines, 2)

 ;===========================================
 ; remove comment lines
 ;===========================================
 w = where(strmid(lines,0,1) NE comment_char)
 if(w[0] EQ -1) then return, ''
 lines = lines[w]


 ;===========================================
 ; connect continued lines
 ;===========================================
 ll = str_flip(lines)
 w = where(strmid(ll,0,1) EQ continue_char)

 if(w[0] NE -1) then $
  begin
   nw = n_elements(w)
   ii = w[0]
   i = 0l
   while(i LT nw) do $
    begin 
     lines[ii] = lines[ii] + lines[w[i]+1]
     lines[w[i]+1] = ''
     if(i LT nw-1) then if(w[i]+1 NE w[i+1]) then ii = w[i+1]

     i = i + 1
    end
   lines = strep_char(lines, '\', ' ')
  end
 
 ;===========================================
 ; remove empty lines
 ;===========================================
 w = where(lines NE '')
 if(w[0] EQ -1) then return, ''
 lines = lines[w]


 ;=========================================================
 ; get header
 ;=========================================================
 w = where(strmid(lines, 0, 1) EQ '%')
 if(w[0] NE -1) then $
  begin
   header = lines[0:w[0]-1]
   lines = lines[w[0]+1:*]
  end


 ;=========================================================
 ; scan the lines twice -- 1st scan determines dimensions
 ;=========================================================
 nfields = 0
 nlines = n_elements(lines)
 for scan = 0, 1 do $
  begin
   line=''
   i = 0l
   while(i LT nlines) do $
    begin
     line = lines[i]
   
     fields = str_sep(strtrim(strcompress(line),2), delim_char)
     nfields_i = n_elements(fields)

     if(scan EQ 0) then $
      begin
       if(nfields_i GT nfields) then nfields = nfields_i
      end $
     else table[i,0:nfields_i-1] = fields

     i = i + 1
    end

   if(scan EQ 0) then table = strarr(nlines, nfields)
  end


 return, table
end
;=============================================================================
