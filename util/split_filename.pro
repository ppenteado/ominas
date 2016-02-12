;=============================================================================
;+
; NAME:
;	split_filename
;
;
; PURPOSE:
;	Divides a path in to directory and filename.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	split_filename, filename, dir, name
;
;
; ARGUMENTS:
;  INPUT:
;	filename:	filenames to split
;
;  OUTPUT:
;	dir:	directories
;
;	name:	base filenames
;
;	ext:	If this argument is given, the file extension is returned
;		and the 'name' output contains only the base name without
;		the extension.
;
;
; RETURN:
;	NONE
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2001
;	
;-
;=============================================================================
pro split_filename, filename, dir, name, ext

 n = n_elements(filename)

 name = filename & dir = make_array(n, val='')
; if((strpos(filename, '/'))[0] EQ -1) then return

 if((strpos(filename, '/'))[0] NE -1) then $
  begin
   ff = str_flip(filename)
   front = str_nnsplit(ff, '/', rem=back)
   dir = str_flip(back)
   name = str_flip(front)
  end

 if(arg_present(ext)) then $
  begin
   p = strpos(name, '.', /reverse_search)
   w = where(p EQ -1)
   if(w[0] NE -1) then p[w] = strlen(name[w])

    ext = strmid_11(name, p+1, strlen(name)-p-1)
    name = strmid_11(name, 0, p)
  end


end
;=============================================================================




;=============================================================================
; the old one....
;
;=============================================================================
pro _split_filename, filename, dir, name

 n = n_elements(filename)

 dir = strarr(n)
 name = strarr(n)

 for i=0, n-1 do $
  begin
   p = rstrpos(filename[i], '/')
   if(p EQ -1) then $
    begin
     dir[i] = ''
     name[i] = filename[i]
    end $
   else $
    begin
     dir[i] = strmid(filename[i], 0, p+1)
     name[i] = strmid(filename[i], p+1, strlen(filename[i])-p)
    end

  end


end
;=============================================================================
