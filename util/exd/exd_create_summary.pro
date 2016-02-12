;=============================================================================
; exd_create_summary
;
;=============================================================================
function exd_create_summary, html_dir, names, sum_ps

; ss = sort(names)
; names = names[ss]
; sum_ps = sum_ps[ss]

 n = n_elements(sum_ps)
 sum_text = ''

 for i=0, n-1 do $
  begin
   sum_text=[sum_text, '<p>']
;   sum_text=[sum_text, '<h2>']
;   sum_text=[sum_text, '<a href="' + html_dir + '/' + strlowcase(names[i]) + '.html">' + names[i] + '</a>']
   sum_text=[sum_text, '<a href="' + html_dir + '/' + strlowcase(names[i]) + '.txt">' + names[i] + '</a>']
;   sum_text=[sum_text, '</h2>']
   sum_text=[sum_text, '</p>']

;   sum_text=[sum_text, '<ul>']

;   if(ptr_valid(sum_ps[i])) then $
;    begin
;     sum=*sum_ps[i]
;     sum_text=[sum_text, sum]
;    end

;   sum_text=[sum_text, '</ul>']
  end


 return, sum_text
end
;=============================================================================



