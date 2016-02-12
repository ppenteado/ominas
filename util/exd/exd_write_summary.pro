;============================================================================
; exd_write_summary
;
;============================================================================
pro exd_write_summary, filename, dir, html_dir, sum_ps, names, prelude=prelude


 sum_text = exd_create_summary(html_dir, names, sum_ps)
 head = exd_create_header(tail)

 if(keyword_set(prelude)) then sum_text = [prelude, sum_text]

 sum_fname = dir + filename
 print, 'Writing ' + sum_fname
 write_txt_file, sum_fname, [head, sum_text, tail]

 

end
;============================================================================



