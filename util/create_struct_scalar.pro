;================================================================================
; create_struct_scalar
;
;
;================================================================================
function create_struct_scalar, tags, values

 ntags = n_elements(tags)

 dim = size(values, /dim)

 ss = 'values['
 if(n_elements(dim) GT 1) then ss = 'values[*,'

 command = 'struct = create_struct('
 for i=0, ntags-1 do $
  begin
   command = command + "'" + tags[i] + "', " + ss + strtrim(i,2) + ']'
   if(i LT ntags-1) then command = command + ', '
  end
 command = command + ')'

 stat = execute(command)

 return, struct
end
;================================================================================
