;=============================================================================
;+
; NAME:
;	extract_doc
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
;	extract_doc, filespec, doc_fname 
;
;
; ARGUMENTS
;  INPUT: 
;	filespec:	File specification string indicating all files
; 			to be searched for documentation.  i.e; './*'.
;
;	doc_fname:	Name of the documentation file to be created.
;
;  OUTPUT: NONE
;
;
;
; KEYWORDS 
;  INPUT: 
;	title:		String containing a title to place at the top of the
;			output file.
;
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
;	header_fname:	Name of a file containing text to be inserted at
; 			the top of the output file. 
;
;	append:		If set, output will be appended to the existing file
;			instead of overwriting.
;
;	page:		If set, blank lines will be inserted such that each  
;			header starts on a new page.
;
;	lines_per_page:	Number of lines per page, default is 66, to use with
;			page keyword.
;
;	type:		String indicating which documentation type to retrieve.
;			If set, only doc headers of that type will appear in the
;			output file.  Default type is ''.  If type is
;			'ALL_TYPES', then all types will be included in the
;			output.
;
;	title:		String to use as the title of the document.
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
; exd_get_doc
;
;=============================================================================
function ___exd_get_doc, fname, sum_ps, names, conv_func=conv_func, type=type

 DOC_BEGIN_SYM = ';+' 
 DOC_END_SYM = ';-' 
 DOC_TYPE_SYM = ';&' 

 DOC_PAGE_SYM = ''

 SUM_BEGIN_SYM = '; PURPOSE:' 
 SUM_END_SYM = '; CATEGORY:' 

 SUM_EXCLUDE_SYMS = [SUM_BEGIN_SYM, SUM_END_SYM]

 NAME_SYM = '; NAME:' 

 TYPE_ALL_SYM='ALL_TYPES'

 line=''
 doc=['']
 sum=['']
 names=['']

 doc_ps=[nv_ptr_new()]
 sum_ps=[nv_ptr_new()]

 print, 'Reading '+fname
 openr, unit, fname, /get_lun

 if(NOT keyword__set(type)) then type=''
 all_types=0
 if(type EQ TYPE_ALL_SYM) then $
  begin
   type=''
   all_types=1
  end


 ;-------------------------------------
 ; scan file for documentation headers
 ;-------------------------------------
 in_doc_header=0
 in_summary=0
 this_type=''
 ln = -1

 while(NOT eof(unit)) do $
  begin
   readf, unit, line
   ln = ln + 1

   ;-------------------------
   ; silent control symbols
   ;-------------------------
   if(strmid(line, 0, 2) EQ DOC_TYPE_SYM) then $
    begin
     if(NOT all_types) then this_type=strmid(line, 2, strlen(line)-2)
    end $
   else $
    begin
     ;-------------------
     ; end of doc header
     ;-------------------
     if(line EQ DOC_END_SYM) then $
      begin
       if(in_doc_header AND this_type EQ type) then $
        begin 
         if(NOT keyword__set(name_ln)) then message, 'Parse error.', /continue $
         else $
          begin
           name=doc[name_ln+1]
           remchar, name, ';'
           names=[names, strtrim(name, 2)]

           doc_p=nv_ptr_new(doc[name_ln+2:*])
           if(n_elements(sum) GT 1) then $
            begin
             sum=sum[1:*]
             sum=arrtrim(sum,2)
             if(sum[0] EQ '') then sum_p=nv_ptr_new() $
             else sum_p=nv_ptr_new(sum)
            end $
           else sum_p=nv_ptr_new()

           doc_ps=[doc_ps, doc_p]
           sum_ps=[sum_ps, sum_p]
          end
        end


       in_doc_header=0
       line=''
       this_type=''
       doc=['']
       sum=['']
      end

     ;-----------------
     ; name
     ;-----------------
     if(strpos(line, NAME_SYM) EQ 0) then name_ln = ln+1

     ;-----------------
     ; end of summary
     ;-----------------
     if(strpos(line, SUM_END_SYM) EQ 0) then in_summary=0

     ;------------------------------------------
     ; inside doc header - convert and append.
     ;------------------------------------------
     if(in_doc_header) then $
       doc=[doc, call_function(conv_func, strmid(line, 1, strlen(line)-1) )]

     ;---------------------------------------
     ; inside summary - Convert and append.
     ;---------------------------------------
     if(in_summary) then $
      begin
       summary_exclude = 0
       for i=0, n_elements(SUM_EXCLUDE_SYMS)-1 do $
            if(strpos(line, SUM_EXCLUDE_SYMS[i]) NE -1) then summary_exclude=1

       if(NOT summary_exclude) then $
         sum=[sum, call_function(conv_func, strmid(line, 1, strlen(line)-1) )]
      end

     ;---------------------
     ; start of doc header
     ;---------------------
     if(line EQ DOC_BEGIN_SYM) then $
      begin
       ln = 0
       in_doc_header=1
       doc=[doc, DOC_PAGE_SYM]
      end

     ;-------------------
     ; start of summary
     ;-------------------
     if(strpos(line, SUM_BEGIN_SYM) EQ 0) then in_summary=1

    end
  end




 if(n_elements(doc_ps) GT 1) then doc_ps=doc_ps[1:*]
 if(n_elements(sum_ps) GT 1) then sum_ps=sum_ps[1:*]
 if(n_elements(names) GT 1) then names=names[1:*]


 close, unit
 free_lun, unit

 return, doc_ps
end
;=============================================================================



;=============================================================================
; exd_fill_page
;
;=============================================================================
pro exd_fill_page, text, lines_per_page

 n = lines_per_page - (n_elements(text) mod lines_per_page)
 text=[text, make_array(n, val='')]

end
;=============================================================================



;=============================================================================
; extract_doc
;
;=============================================================================
pro extract_doc, filespec, doc_fname, title=title, no_summary=no_summary, $
   no_doc=no_doc, delim=delim, conv_func=conv_func, header_fname=header_fname, $
   append=append, lines_per_page=lines_per_page, page=page, type=type, $
   text=text

 if(NOT keyword__set(lines_per_page)) then lines_per_page=66
 if(NOT keyword__set(type)) then type=''

 if(NOT keyword__set(conv_func)) then conv_func='exd_identity'

 DOC_DELIM = $
  '---------------------------------------------------------------------'


 ;---------------------------------------
 ; get all files that match filespec
 ;---------------------------------------
; spawn, 'ls -1 '+filespec, temp_files
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

 for i=0, n_elements(files)-1 do $
  begin
   doc = exd_get_doc(files[i], sum, name, conv_func=conv_func, type=type)
   if(ptr_valid(doc[0])) then $
    begin
     doc_ps=[doc_ps, doc]
     sum_ps=[sum_ps, sum]
     names=[names, name]
    end
  end

 if(n_elements(doc_ps) LE 1) then $
  begin
   message, 'No documentation.', /continue
   return
  end

 doc_ps=doc_ps[1:*]
 sum_ps=sum_ps[1:*]
 names=names[1:*]


 ;-------------------------
 ; alphabetize the names
 ;-------------------------
 indices=sort(strupcase(names))

 names=names[indices]
 doc_ps=doc_ps[indices]
 sum_ps=sum_ps[indices]


 ;----------------------------
 ; build html reference pages
 ;----------------------------


 ;----------------------------
 ; build html index
 ;----------------------------


 ;----------------
 ; build doc file
 ;----------------
 if(keyword__set(doc_fname)) then print, 'Building '+doc_fname

 get_date, date
 doc_text='									'+date

 if(keyword__set(title)) then $
  begin
   ul = '='
   for i=1, strlen(title)-1 do ul=ul+'='
   doc_text=[doc_text, title, ul]
  end

 doc_text=[doc_text, '']

 ;---------------------
 ; header file
 ;---------------------
 if(keyword__set(header_fname)) then $
  begin
   htext=read_txt_file(header_fname, status=status)
   if(status EQ 0) then doc_text=[doc_text, htext]
  end


 ;----------------
 ; summaries
 ;----------------
 n=n_elements(doc_ps)      ; should be the same for doc_ps, sum_ps, names

 if(NOT keyword__set(no_summary)) then $
  begin
   doc_text=[doc_text, ' Summary', ' -------']

   for i=0, n-1 do $
    begin
     doc_text=[doc_text, '  - '+names[i]]

     if(NOT ptr_valid(sum_ps[i])) then $
                   doc_text=[doc_text, '            No summary available.'] $
     else $
      begin
       sum=*sum_ps[i]
       doc_text=[doc_text, sum]
      end

     doc_text=[doc_text, '']
    end
  end

 ;----------------------------
 ; go to new page if desired
 ;----------------------------
 if(keyword__set(page)) then exd_fill_page, doc_text, lines_per_page


 ;----------------------
 ; complete doc headers
 ;----------------------
 if(NOT keyword__set(no_doc)) then $
  begin
   for i=0, n-1 do $
    begin
     if(keyword__set(delim)) then doc_text=[doc_text, DOC_DELIM]
     doc=*doc_ps[i]

     ul=''
     for k=0, strlen(names[i])-1 do ul = ul + '-'
     doc_text=[doc_text, strupcase(names[i]), ul, doc]

     if(keyword__set(page)) then exd_fill_page, doc_text, lines_per_page
    end
  end


 if(arg_present(text)) then text=doc_text $
 else $
  begin
   print, 'Writing '+doc_fname
   write_txt_file, doc_fname, doc_text, append=keyword__set(append)
  end


 ;-----------
 ; clean up
 ;-----------
 nv_ptr_free, doc_ps
 nv_ptr_free, sum_ps

end
;=============================================================================
