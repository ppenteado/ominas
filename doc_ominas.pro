;============================================================================
; doc_ominas_extract
;
;============================================================================
pro doc_ominas_extract, _dir, doc_dir, nodoc=nodoc, $
             html_dir=html_dir, sum=sum, names=names, $
             exclude_dir=exclude_dir, gen_dir=gen_dir, top_dir=top_dir

 dir = str_reduce(_dir + '/', '/')
 
 if(NOT keyword_set(top_dir)) then top_dir = dir

 if(NOT keyword_set(sum)) then sum = ''

 ;-----------------------------------------------
 ; determine whether dir is excluded
 ;-----------------------------------------------
 for i=0, n_elements(exclude_dir)-1 do $
                    if(strpos(dir, exclude_dir[i]) NE -1) then return


 ;-----------------------------------------------
 ; extract documentation in this directory
 ;-----------------------------------------------
; ss = str_sep(dir, '/')
; w = where(ss NE '')
; ss = ss[w]
; name = ss[n_elements(ss)-2] + '_' + ss[n_elements(ss)-1]
 

 if(NOT keyword_set(nodoc)) then $
  begin
   if(keyword_set(html_dir)) then $
     extract_doc_html, sum=sum, names=names, $
       dir + '/*.pro', html_dir, gen_dir, top_dir, exclude_dir=exclude_dir
  end


 ;-----------------------------------------------
 ; get subdirectories
 ;-----------------------------------------------
 spawn, 'ls -F ' + dir, files
 p = strpos(files, '/')
 w = where(p NE -1)
 if(w[0] EQ -1) then return

 ;-----------------------------------------------
 ; recurse down each directory
 ;-----------------------------------------------
 dirs = dir + '/' + files[w]
 ndirs = n_elements(dirs)
 for i=0, ndirs-1 do doc_ominas_extract, dirs[i], doc_dir, $
                     html_dir=html_dir, sum=sum, names=names, $
                     exclude_dir=exclude_dir, gen_dir=gen_dir, top_dir=top_dir

end
;============================================================================



;============================================================================
; doc_ominas
;
;============================================================================
pro doc_ominas

; dir = getenv('OMINAS_DIR')
 dir = './'

 doc_dir = dir + '/doc'
 html_dir = doc_dir + '/html/routines/'
 gen_dir = doc_dir + '/html/gen/'

 exclude_dir=['util/idl_obsolete/', $
              '/nv/sys/lic/', $
              '/orig/', $
              '/bat/', $
              '/demo/', $
              '/doc/', $
              '/admin/', $
              '/old/', $
              '/gr/tools/', $
              '/gr/bitmaps/', $
              '/gr/scripts/', $
              '/sedr/create/', $
              '/util/abbrev/', $
              'dh/wrappers/']

 doc_ominas_extract, dir, doc_dir, $
                html_dir=html_dir, sum=sum, names=names, $
                exclude_dir=exclude_dir, gen_dir=gen_dir

 exd_write_summary, 'summary.html', gen_dir, '../../../' + html_dir, sum, names

 

end
;============================================================================
