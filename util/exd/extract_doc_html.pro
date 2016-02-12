;=============================================================================
;+
; NAME:
;	extract_doc_html
;
;
; PURPOSE:
;	Extracts documentation headers from program files and creates
;	a text file containing a list of the procedures with a summary, 
;	and a list of all of the documentation headers.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;
;	extract_doc_html, filespec, html_fname 
;
;
; ARGUMENTS
;  INPUT: 
;	filespec:	File specification string indicating all files
; 			to be searched for documentation.  i.e; './*'.
;
;	html_fname:	Name of the documentation file to be created.
;
;  OUTPUT: NONE
;
;
;
; KEYWORDS 
;  INPUT: 
;	no_summary:	If set, summaries will not be included in the output
;			file.
;
;	no_doc:		If set, only summaries will be included in the output
;			file.
;
;	delim:		If  set, a delimiting line will be placed between each
;			header in the output file.
;
;	conv_func:	Function to convert text format.  Input is array
;			of strings of text.  Returns array of new text.	
;
;	append:		If set, output will be appended to the existing file
;			instead of overwriting.
;
;	page:		If set, blank lines will be inserted such that each  
;			header starts on a new page.
;
;	type:		String indicating which documentation type to retrieve.
;			If set, only doc headers of that type will appear in the
;			output file.  Default type is ''.  If type is
;			'ALL_TYPES', then all types will be included in the
;			output.
;
;          
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; PROCEDURE:
;	For each file matching the filespec, extract_doc will attempt to
;	parse any text which lies between the symbols ";+" and ";-".  These
;	symbols are only recognized if there is nothing else on the line.
;	The routine name and purpose are treated specially, but all other text
;	is copied exactly, except that the first character on each line is
;	ignored since it is assumed to be ";".  The name and purpose are
;	extracted separately and used to create al list of routine summaries at
;	the beginning of the output.
;
;	The control symbol ";&" can be used to define documentation types, which
;	can then be filtered using the type keyword above.  Lines beginning
;	with this symbol will not appear in the output.
;
;	There is no limit to the number of documentation headers which can
;	be extracted from a program file.
;
;	doc_template.pro can be used as a template for documentation headers.
;
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1995
;
;
;-
;=============================================================================


;=============================================================================
; exd_add_html
;
;=============================================================================
function exd_add_html, name, intext

 ;--------------------------------------
 ; html header stuff
 ;--------------------------------------
 outtext = ['<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">', $
            '<html>']


 outtext = [outtext, $
            '<head>', $
            '<title>MINAS -- ' + strupcase(name) + '</title>', $
            '</head>']

 outtext = [outtext, $
            '<body style="color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">', $
            '<table style="text-align: left; margin-left: auto; margin-right: auto; width: 800px;"border="0" cellpadding="5" cellspacing="2">', $
             '<tbody>', $
             '<tr align="justify">', $
             '<td style="background-color: rgb(170, 170, 70); color: rgb(255, 255, 255); vertical-align: middle; text-align: left;">', $
             '<b>' + strupcase(name) + '</b> </td>', $
             '</tr>', $
             '<tr>', $
             '<td style="vertical-align: top;">', $
             '<br />']

 outtext = [outtext, $
            '<h1>' + strupcase(name) + '</h1>']



 ;--------------------------------------
 ; add tags to body
 ;--------------------------------------
 nlines = n_elements(intext)
 w = where(strpos(intext, ':') NE -1)
 if(w[0] NE -1) then $
  begin
   nw = n_elements(w)
   hlevel = 1
   indent = 0
   for i=0, nw-1 do $
    begin
     line = intext[w[i]]

     ;- - - - - - - - - - - - - - - - - - - -
     ; measure indentation
     ;- - - - - - - - - - - - - - - - - - - -
     nspace = strxpos(line, ' ')
     ntab = strxpos(line, '	')
     nn = nspace + 8*ntab


     ;- - - - - - - - - - - - - - - - - - - -
     ; change hlevel if indentation changed
     ;- - - - - - - - - - - - - - - - - - - -
     if(nn GT indent) then hlevel = hlevel + 1 $
     else if(nn LT indent) then hlevel = hlevel - 1
     indent = nn

     ;- - - - - - - - - - - - - - - - - - - -
     ; create html level tags
     ;- - - - - - - - - - - - - - - - - - - -
     h1 = 'h' + strtrim(hlevel,2)
     h2 = '/'+h1
     h1 = '<' + h1 + '>'
     h2 = '<' + h2 + '>'
 
     ;- - - - - - - - - - - - - - - - - - - -
     ; parse line
     ;- - - - - - - - - - - - - - - - - - - -
     p = strpos(line, ':')
     heading = strtrim(strmid(line, 0, p+1), 2)
     rem = strtrim(strmid(line, p+1, 1000), 2)

     ;- - - - - - - - - - - - - - - - - - - -
     ; add tags to line
     ;- - - - - - - - - - - - - - - - - - - -
;     outtext = [outtext, '<ul>']
     outtext = [outtext, h1+heading+h2 + ' ' + rem ]
;     outtext = [outtext, '</ul>']

     ;- - - - - - - - - - - - - - - - - - - -
     ; add text to next heading
     ;- - - - - - - - - - - - - - - - - - - -
     ii = nlines-1
     if(i NE nw-1) then ii = w[i+1]-1
     if(ii GT w[i]) then $
      begin
       text = intext[w[i]+1:ii]

       if(heading EQ 'SEE ALSO:') then $
        begin
         also_names = strtrim(strlowcase(str_sep(text[0], ',')),2)
         text = str_comma_list('<a href="./' + also_names + '.html">' + strupcase(also_names) + '</a>')
        end

       outtext = [outtext, '<ul>', text, '</ul>']
      end
    end

  end

 ;--------------------------------------
 ; html closing stuff
 ;--------------------------------------
 outtext = [outtext, $
            '</td>', '</tr>', '</tbody>', '</table>', '</body>', '</html>']


 return, outtext
end
;=============================================================================



;=============================================================================
; extract_doc_html
;
;=============================================================================
pro extract_doc_html, filespec, _html_dir, gen_dir, top_dir, no_summary=no_summary, $
   no_doc=no_doc, delim=delim, conv_func=conv_func, $
   append=append, type=type, exclude_dir=exclude_dir, $
   sum_ps=_sum_ps, names=_names

 if(NOT keyword__set(type)) then type=''
 if(NOT keyword__set(conv_func)) then conv_func='exd_identity'

  rout_dir = (html_dir = _html_dir)


 ;---------------------------------------
 ; get subdirectories
 ;---------------------------------------
  p = strpos(filespec, '*')
  cur_dir = strmid(filespec, 0, p)
  new_dir = gen_dir + strmid(cur_dir, strlen(top_dir), 1000)

  top_dir = str_reduce(top_dir, '/')
  cur_dir = str_reduce(cur_dir, '/')
  new_dir = str_reduce(new_dir, '/')

  spawn, 'ls -F ' + cur_dir, files
  s = str_flip(files)
  p = strpos(s, '/')
  w = where(p EQ 0)

  cd = str_sep(cur_dir, '/')
  td = str_sep(top_dir, '/')
  level = n_elements(cd) - n_elements(td) + 3

  for i=0, level-1 do html_dir = '../' + html_dir


 ;---------------------------------------
 ; create topics
 ;---------------------------------------
 if(w[0] NE -1) then $
  begin
   topics = strtrim(strep_char(files[w], '/', ' '), 2)

   old_dirs = cur_dir + '/' + topics + '/'
   for i=0, n_elements(old_dirs)-1 do old_dirs[i] = str_reduce(old_dirs[i], '/')
   for i=0, n_elements(exclude_dir)-1 do $
    begin
     p = strpos(old_dirs, exclude_dir[i])
     w = where(p NE -1)
     if(w[0] NE -1) then old_dirs[w] = ''
    end

   w = where(old_dirs NE '')
   if(w[0] NE -1) then $
    begin
     topics = topics[w]
     new_dirs = new_dir + '/' + topics

     spawn, 'mkdir -p ' + str_comma_list(new_dirs, delim=' ')
    end $
   else topics = ''

  end

 desc_file = exd_get_description(cur_dir)
 spawn, 'cp -f ' + cur_dir + '/' + desc_file + ' ' + new_dir 
 tsum = exd_create_topic_summary(topics, cur_dir, desc_file)



 ;---------------------------------------
 ; get all files that match filespec
 ;---------------------------------------
 temp_files = findfile(filespec)

 if(temp_files[0] EQ '') then $
  begin
   message, 'No matching files.', /continue
   return
  end


 ;---------------
 ; verify paths 
 ;---------------
 current_dir=''
 files=['']

 for i=0, n_elements(temp_files)-1 do $
  begin
   n = strpos(temp_files(i), ':')
   if(n NE -1) then current_dir=strmid(temp_files(i), 0, n)+'/' $
   else if(strmid(temp_files(i), strlen(temp_files(i))-4, 4) EQ '.pro')  then $
     files=[files, current_dir+temp_files(i)]
  end
 files=files[1:*]


 ;---------------------------------------------------------
 ; scan files list and extract doc headers and summaries
 ;---------------------------------------------------------
 doc_ps=[nv_ptr_new()]
 sum_ps=[nv_ptr_new()]
 names=['']

; NOTE primaries need to be handled inside this loop... (i.e., per file)
 primaries = 0b
 for i=0, n_elements(files)-1 do $
  begin
   doc = exd_get_doc(files[i], sum, name, conv_func=conv_func, type=type, primaries=_primaries)

   w = where(_primaries NE 0)
   if(w[0] NE -1) then $
    begin
     _primaries = _primaries[w]
     doc = doc[w]
     sum = sum[w]
     name = name[w] 
    end

   if(ptr_valid(doc[0])) then $
    begin
     primaries = [primaries, _primaries]
     doc_ps = [doc_ps, doc]
     sum_ps = [sum_ps, sum]
     names = [names, name]
    end
  end


 ;--------------------------------
 ; select only primaries if given
 ;--------------------------------
;p = strpos(cur_dir, 'nv/gr')
;w = where(p NE -1)
;if(w[0] NE -1) then stop
 w = where(primaries NE 0)
 if(w[0] NE -1) then $
  begin
   doc_ps = doc_ps[w]
   sum_ps = sum_ps[w]
   names = names[w] 
  end


 ;---------------------------------------
 ; write topic summary
 ;---------------------------------------
 exd_write_summary, 'topic.html', new_dir, html_dir, sum_ps, names, pre=tsum


 if(n_elements(doc_ps) LE 1) then $
  begin
   message, 'No documentation.', /continue
   return
  end

 primaries = primaries[1:*]
 doc_ps = doc_ps[1:*]
 sum_ps = sum_ps[1:*]
 names = names[1:*]


 ;-------------------------
 ; alphabetize the names
 ;-------------------------
 indices=sort(strupcase(names))

 names=names[indices]
 doc_ps=doc_ps[indices]
 sum_ps=sum_ps[indices]


 ;----------------
 ; build html file
 ;---------------- 
 get_date, date
 doc_text='									'+date


 ;----------------------
 ; complete ref pages
 ;----------------------
 n = n_elements(doc_ps)      ; should be the same for doc_ps, sum_ps, names
 if(NOT keyword__set(no_doc)) then $
  begin
   for i=0, n-1 do $
    begin
;     text = exd_add_html(names[i], *doc_ps[i])
;     html_fname = rout_dir + strlowcase(names[i]) + '.html'

     text = [strupcase(names[i]), *doc_ps[i]]
     html_fname = rout_dir + strlowcase(names[i]) + '.txt'

     print, 'Writing ' + html_fname
     write_txt_file, html_fname, text, append=keyword__set(append)

    end
  end


 if(keyword_set(sum_ps)) then $
  begin
   _sum_ps = append_array(_sum_ps, sum_ps)
   _names = append_array(_names, names)
  end

 ;-----------
 ; clean up
 ;-----------
 nv_ptr_free, doc_ps
; nv_ptr_free, sum_ps

;stop
end
;=============================================================================
