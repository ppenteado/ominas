;=============================================================================
;+
; NAME:
;	nv_help
;
;
; PURPOSE:
;	Prints information about various OMINAS objects.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_help, p
;
;
; ARGUMENTS:
;  INPUT:
;	p:	Object to query.  Actions that depend on this input are
;		as follows:
;
;		 p		action
;		 ----------------------------------------------------
;		 No value	Print the full paths of all NV tables. 
;		 Numeric	Call IDL function 'help'.
;		 Ptr or struct	Descend recursively, printing info on all
;				fields.
;		 String		Assumes p is the name of an OMINAS routine
;				and prints the documentation page if
;				available.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;       event:		If set, the event tables are printed and p
;			is ignored.
;
;       print:		If set, any arrays ith this many elements or fewer
;			are printed out.
;
;  OUTPUT: 
;       capture:	If present, the output in returned in this
;			keyword instead of being printed.
;
;
; ENVIRONMENT VARIABLES:
;       OMINAS_DIR:	OMINAS top directory; used to find documentation files.
;
;
; RETURN: NONE
;
;
; STATUS:
;       The routine help is currently not working because it relied on the old
;       documentation system.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================



;===========================================================================
; nv_help_print
;
;===========================================================================
pro nv_help_print, s, capture=capture
 if(NOT keyword_set(s)) then s = ''

 if(defined(capture)) then $
  begin
   if(n_elements(size(s, /dim)) GT 1) then s = tr(s)
   capture = append_array(capture, s)
  end $
 else print, s
end
;===========================================================================


;===========================================================================
; nv_sep
;
;===========================================================================
pro nv_help_sep

 nv_help_print, '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'

end
;===========================================================================


;===========================================================================
; nv_help_state
;
;===========================================================================
pro nv_help_state, capture=capture
@nv_block.common

 nv_help_print, 'Translators table:	' + *nv_state.translators_filenames_p, capture=capture
 nv_help_print, capture=capture

 if(keyword__set(*nv_state.transforms_filenames_p)) then $
  begin
   nv_help_print, 'Transforms table:	' + *nv_state.transforms_filenames_p, capture=capture
   nv_help_print, capture=capture
  end

 nv_help_print, 'I/O Table:		' + *nv_state.io_filenames_p, capture=capture
 nv_help_print, capture=capture

 nv_help_print, 'Filetype table:		' + *nv_state.ftp_detectors_filenames_p, capture=capture
 nv_help_print, capture=capture

 nv_help_print, 'Instrument detector table:	' + *nv_state.ins_detectors_filenames_p, capture=capture

end
;===========================================================================


;===========================================================================
; nv_help_descend
;
;===========================================================================
pro nv_help_descend, dp0, indent, string, index, capture=capture, print=print

 dp = dp0
 type = size(dp, /type)
 n = n_elements(dp)

 nullval = 'null'

 ;----------------------------------------
 ; object: dereference and continue
 ;----------------------------------------
 if(type EQ 11) then $
  begin
   for i=0, n-1 do $
    begin
     if(NOT obj_valid(dp[i])) then return
     _dp = cor_dereference(dp[i])
     nv_help_descend, _dp, indent+1, string, i, capture=capture, print=print
    end
  end


 ;----------------------------------------
 ; pointer: dereference and descend again
 ;----------------------------------------
 if(type EQ 10) then $
  begin
   for i=0, n-1 do $
    begin
     if(ptr_valid(dp[i])) then val = *dp[i] $
     else val = 'null'

     tt = size(val, /type)
     if((tt EQ 8)) then $
      begin
       if(keyword_set(string)) then nv_help_print, string, capture=capture
       string = ''
      end
     nv_help_descend, val, indent+1, string, i, capture=capture, print=print
    end
   return
  end

 ;----------------------------------------
 ; not a structure -- print value
 ;----------------------------------------
 if(type NE 8) then $
  begin
   null = 0
   if(type EQ 7) then if(dp[0] EQ nullval) then null = 1

   if(null) then hh = nullval $
   else $
    begin
     help, dp, output=h
     l = strlen(h) 
     hh = strmid(h, 16, l-16)
    end

   ss = string + hh

   if(keyword_set(print)) then $
     if(n_elements(dp) LE print) then ss = [ss, string(dp, /print)]

   if(defined(index)) then $
    begin
     nn = strtrim(index,2)
     l = strlen(ss)
     p = strpos(ss, '[')
     pp = strpos(ss, ']')
     ppp = strpos(ss, ':')

     if(p[0] NE -1) then $
      begin
       if(nn EQ 0) then ss = strmid(ss, 0, ppp[0]+1)  + ' ' + nullval $
       else ss = strmid(ss, 0, p[0]+1) + nn + strmid(ss, pp[0], l-pp[0])
      end
    end

   ss = str_pad(ss, 80)
   nv_help_print, ss, capture=capture
   return
  end

 ;--------------------------------------------
 ; structure --  record tag names and descend
 ;--------------------------------------------
 for j=0, n-1 do $
  begin
   s = dp[j]
   tags = tag_names(s)
   ntags = n_elements(tags)

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; GD -- just print stucture; do not descend
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(tags[ntags-1] EQ 'GD') then $
    begin
     help, s.gd, out=out
     nv_help_print, out[1:*], capture=capture

     ntags = 0
    end

   for i=0, ntags-1 do $
    begin
     name = tags[i]
     ind = 2*indent
     pad = 24
     if(size(s.(i),/type) EQ 10) then $
      begin
;       name = '*' + name
help, s.(i), out=out
pname = (strmid(out, strpos(out, '<Ptr'), 100))[0]
name = name+pname
       ind = ind-1
       pad = pad + 1
       if(ptr_valid(s.(i))) then $
        begin
         np = n_elements(*s.(i))
         tp = size(*s.(i), /type)
         ndig = fix(alog10(np)) + 1
         if((np GT 1) AND (tp EQ 10)) then $
                        name = name + '[' + str_pad(' ', ndig) + ']'
        end
      end

     string = str_pad(' ', ind) + str_pad(name + ':', pad)

     nv_help_descend, s.(i), indent+1, string, capture=capture, print=print
    end
  end

end
;===========================================================================



;===========================================================================
; nv_help_dump_events
;
;===========================================================================
pro nv_help_dump_events, capture=capture, items

 if(NOT keyword_set(items)) then $
  begin
   nv_help_print, capture=capture, 'No entries'
   return
  end

 n = n_elements(items) 
 i = 0l
 repeat $
  begin
   xd = items[i].xd

   class = cor_class(xd)
   desc = cor_name(xd)

   type = 'READ'
   if(items[i].type EQ 0) then type = 'WRITE'

   help, out=s, xd[0]
   ptr = str_flip(str_nnsplit(str_flip(s), ' '))

   s = str_pad(ptr, 18) + str_pad(class, 7) + str_pad(type, 6) + $
       str_pad(desc, 20) + str_pad(items[i].handler, 29)

   nv_help_print, capture=capture, s

   i = i + 1
  endrep until(i GE n)


end
;===========================================================================



;===========================================================================
; nv_help_event
;
;===========================================================================
pro nv_help_event, capture=capture
@nv_notify_block.common

 ;-------------------------------------
 ; dump handler list
 ;-------------------------------------
 nv_help_print, capture=capture, $
  '-------------------------------- Event Registry --------------------------------'
 nv_help_print, capture=capture, ''
 nv_help_dump_events, capture=capture, list

 nv_help_print, capture=capture, ''

 ;-------------------------------------
 ; dump event buffer
 ;-------------------------------------
 nv_help_print, capture=capture, $
  '--------------------------------- Event Buffer ---------------------------------'
 nv_help_print, capture=capture, ''
 nv_help_dump_events, capture=capture, buf

 

end
;===========================================================================



;===========================================================================
; nv_help_doc_parse
;
;===========================================================================
function nv_help_doc_parse, lines

 delim = '___________________________'

 w = where(strpos(lines, delim) EQ 0)

 if(w[0] NE -1) then $
  begin
   doc_lines = list()
   for i=0, n_elements(w)-1, 2 do doc_lines.add, lines[w[i]+1:w[i+1]-1]
   return, doc_lines
  end


 return, !null
end
;===========================================================================



;===========================================================================
; nv_help_doc
;
;===========================================================================
pro nv_help_doc, iname, capture=capture

 name=strlowcase(iname)

 ;------------------------------------------------------
 ; find the doc files
 ;------------------------------------------------------
 doc_dir = getenv('OMINAS_DIR') + '/docs/rst/'
 doc_files = file_search(doc_dir,'*.txt')
 doc_pfs = str_nnsplit(str_flip(str_nnsplit(str_flip(doc_files), '_')), '.')


 ;------------------------------------------------------------------------
 ; search the documentation
 ;------------------------------------------------------------------------
 n = n_elements(doc_files)

 for i=0, n-1 do $
  begin
   lines = read_txt_file(doc_files[i], /raw)
   docs = nv_help_doc_parse(lines)
   if(keyword_set(docs)) then for j=0, n_elements(docs)-1 do $
    begin
     doc_lines = docs[j]
     w = where(strpos(doc_lines, iname) EQ 0)
     if(w[0] NE -1) then $
      begin
       nv_help_print, tr(doc_lines[3:*]), capture=capture
       return
      end
    end

  end

 
 nv_message, 'No documentation available for ' + name + '.'

end
;===========================================================================



;===========================================================================
; nv_help_doc
;
;===========================================================================
pro __nv_help_doc, iname, capture=capture

 ;------------------------------------------------------
 ; find the doc files
 ;------------------------------------------------------
 doc_dir = getenv('OMINAS_DIR') + '/docs/rst/'
 doc_files = file_search(doc_dir,'*.txt')
 doc_pfs = str_nnsplit(str_flip(str_nnsplit(str_flip(doc_files), '_')), '.')


 ;------------------------------------------------------------------------
 ; search the documentation
 ;------------------------------------------------------------------------
 n = n_elements(doc_files)

 for i=0, n-1 do $
  begin
   lines = read_txt_file(doc_files[i], /raw)
   lines=strtrim(lines,2)
   nlines=list()
   prevl='a'
   foreach line,lines,iline do begin
    if (strlen(line) eq 0) && (strlen(prevl) eq 0) then continue
    nlines.add,strjoin(strsplit(line,'\\_',/regex,/extract),'_')
    prevl=line
   endforeach
   lines=nlines.toarray()

   ;name = strupcase(name)
   name=strlowcase(iname)
   ;name=strjoin(strsplit(name,'_',/extract),'\_')

   p = strpos(lines, name)
   w = where(p EQ 0)
   w = where(stregex(lines,'^'+name+'(\.pro)?',/boolean))
   if(w[0] NE -1) then $
    begin
     ii = w[0]
     if stregex(strtrim(lines[ii],2),'^'+name+'(\.pro)?',/boolean) then $
      begin
       ;p = strpos(lines[ii+2:*], '-')
       nn = min(where(p EQ 0))
       w=where(stregex(lines,'^(__)|(==)',/boolean))
       nn=min(w)
       if(nn EQ -1) then nn = n_elements(lines) - ii

       ;- - - - - - - - - - - - - - - - - - - - - - -
       ; extract relevant lines
       ;- - - - - - - - - - - - - - - - - - - - - - -
       doc_lines = lines[ii:ii+nn-2]

       ;- - - - - - - - - - - - - - - - - - - - - - -
       ; get rid of trailing blank lines
       ;- - - - - - - - - - - - - - - - - - - - - - -
       w = max(where(strtrim(doc_lines, 2) NE ''))
       if(w[0] NE -1) then doc_lines = doc_lines[0:w[0]]

;       nv_help_sep
       nv_help_print, tr(doc_lines), capture=capture
       return
      end
    end
  end

 
 nv_message, 'No documentation available for ' + name + '.'

end
;===========================================================================



;===========================================================================
; nv_help
;
;===========================================================================
pro nv_help, dp, capture=capture, print=print, event=event

 if(keyword_set(print)) then if(print EQ 1) then print = 100

 ;--------------------------------------------
 ; show event info if /event
 ;--------------------------------------------
 if(keyword_set(event)) then $
  begin
   nv_help_event, capture=capture
   return
  end


 ;----------------------------------------------------
 ; just print documentation if argument is a string
 ;----------------------------------------------------
 if(size(dp, /type) EQ 7) then $
  begin
   nv_help_doc, dp, capture=capture
   return
  end

 ;----------------------------------------------------
 ; otherwise describe the object
 ;----------------------------------------------------
; nv_help_sep
 if(keyword_set(dp)) then nv_help_descend, dp, 0, '', capture=capture, print=print $
 else nv_help_state, capture=capture


 nv_help_print, capture=capture

end
;===========================================================================



