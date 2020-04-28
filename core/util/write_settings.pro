;=============================================================================
; write_settings
;
;=============================================================================
pro write_settings, filename, settings

 var = tag_names(settings)
 nvar = n_elements(var)
 lines = strarr(nvar)

 for i=0, nvar-1 do $
  begin
   val = settings.(i)
   type = size(val, /type)
   if(type EQ 7) then val = "'" + val + "'"

   arg = str_comma_list(val)
   if(n_elements(val) GT 1) then arg = '[' + arg + ']'

   lines[i] = var[i] + '=' + arg
  end

 write_txt_file, filename, lines
end
;=============================================================================
