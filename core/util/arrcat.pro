;==============================================================================
; arrcat
;
;==============================================================================
function arrcat, arr

 n = n_elements(arr)
 result = '['
 for i=0, n-1 do $
  begin
   result = result + strtrim(arr[i],2)
   if(i LT n-1) then result = result + ','
  end
 result = result + ']'

 return, result
end
;==============================================================================
