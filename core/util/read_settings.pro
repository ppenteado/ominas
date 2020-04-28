;=============================================================================
; read_settings
;
;=============================================================================
function read_settings, filename

 lines = read_txt_file(filename)
 if(NOT keyword_set(lines)) then return, !null
 nlines = n_elements(lines)

 for i=0, nlines-1 do $
  begin
   s = strsplit(lines[i], '=', /extract)
   if(n_elements(s) EQ 1) then s = [s, '1']
   var = strtrim(s[0],2)
   command = 'val = ' + s[1]
   status = execute(command)
   ss = create_struct(var, val)
   settings = append_struct(settings, ss)
  end

 return, settings
end
;=============================================================================
