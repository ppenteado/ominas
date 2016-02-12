;=============================================================================
; exd_get_doc
;
;=============================================================================
function exd_get_doc, fname, sum_ps, names, conv_func=conv_func, type=type, primaries=primaries


 DOC_BEGIN_SYM = ';+' 
 DOC_PRIMARY_SYM = ';+-+' 
 DOC_END_SYM = ';-' 
 DOC_TYPE_SYM = ';&' 

 DOC_PAGE_SYM = ''

 SUM_BEGIN_SYM = '; PURPOSE:' 
 SUM_END_SYM = '; CATEGORY:' 

 SUM_EXCLUDE_SYMS = [SUM_BEGIN_SYM, SUM_END_SYM]

 NAME_SYM = '; NAME:' 

 TYPE_ALL_SYM='ALL_TYPES'

 line=''
 primaries = [0]
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
     begin_sym = 0
     primary_sym = 0

     if(line EQ DOC_BEGIN_SYM) then begin_sym = 1
     if(line EQ DOC_PRIMARY_SYM) then primary_sym = 1

     if(begin_sym OR primary_sym) then $
      begin
       ln = 0
       in_doc_header=1
       doc=[doc, DOC_PAGE_SYM]
       primaries = [primaries, primary_sym]
      end

     ;-------------------
     ; start of summary
     ;-------------------
     if(strpos(line, SUM_BEGIN_SYM) EQ 0) then in_summary=1

    end
  end




 if(n_elements(doc_ps) GT 1) then doc_ps=doc_ps[1:*]
 if(n_elements(sum_ps) GT 1) then sum_ps=sum_ps[1:*]
 if(n_elements(names) GT 1) then names=strupcase(names[1:*])
 if(n_elements(primaries) GT 1) then primaries=primaries[1:*]


 close, unit
 free_lun, unit

 return, doc_ps
end
;=============================================================================



