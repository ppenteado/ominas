;===========================================================================
; pg_add_selections
;
;===========================================================================
pro pg_add_selections, trs, select

 keys = tag_names(select)
 n = n_elements(keys)

 vals = strarr(n)
 
 for i=0, n-1 do vals[i] = str_comma_list(strtrim(select.(i),2), delim=';')
 sel = str_comma_list(keys+'='+vals)

 if(NOT keyword_set(trs)) then trs = sel $
 else trs = trs + ',' + sel
end
;===========================================================================
