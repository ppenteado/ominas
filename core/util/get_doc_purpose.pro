;=============================================================================
;+
; NAME:
;       get_doc_purpose
;
;
; PURPOSE:
;       To extract the purpose from header documentation
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = get_doc_purpose(filespec)
;
;
; ARGUMENTS:
;  INPUT:
;       filespec:       Filespec to extract documentation from.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;         nospec:       Only works under UNIX unless /nospec
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       String containing documentation text.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_doc_purpose, filespec, nospec=nospec

 fnames=filespec(filespec)

 result=['']

 for i=0, n_elements(fnames)-1 do $
  begin

   ;---------------------
   ; open file
   ;---------------------
   openr, unit, fnames[i], /get_lun

   ;---------------------
   ; read line by line
   ;---------------------
   text=['']
   line=''
   active=0

   while NOT EOF(unit) do $
    begin
     readf, unit, line
     if(NOT active) then $
      begin
       if(strpos(line, '; NAME:') EQ 0) then active=1
      end $
     else $
      begin
       if(strpos(line, '; CATEGORY:') EQ 0) then active=0 $
       else if(strpos(line, '; PURPOSE:') EQ -1 AND strlen(line) GT 1) then $
                                    text=[text,strmid(line, 1, strlen(line)-1)]
      end
    end

   close, unit
   free_lun, unit


   ;---------------------------------
   ; remove leading tab from name
   ;---------------------------------
   if(n_elements(text) GT 1) then $
    begin
     text[1] = strmid(text[1], 1, strlen(text[1])-1)
     result=[result,text[1:*],'']
    end
  end


 return, transpose(result[1:*])
end
;=============================================================================
