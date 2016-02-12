;=============================================================================
; exd_create_topic_summary
;
;=============================================================================
function exd_create_topic_summary, topics, cur_dir, desc_file


 n = n_elements(topics)
 text = ''

 if(keyword_set(desc_file)) then text = '<a href="' + desc_file + '">Overview</a>'


 for i=0, n-1 do $
  begin
   dir = cur_dir + '/' + topics[i] + '/'
   ff = exd_get_description(dir)
   if(keyword_set(ff)) then $
    begin
     lines = read_txt_file(dir+ff, /raw)
     string = lines[0]


   text=[text, '<p>']
   text=[text, '<a href="./' + topics[i] +'/topic.html">' + string + '</a>']
   text=[text, '</p>']
    end
  end




 return, text
end
;=============================================================================



