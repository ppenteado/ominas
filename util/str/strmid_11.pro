;=============================================================================
; strmid_11
;
;  Same as strmid, but all arguments are associated 1-1.
;
;=============================================================================
function strmid_11, ss, _p, _len

 p = _p
 len = _len

 ;------------------------------------
 ; convert to byte array
 ;------------------------------------
 bb = byte(ss)

 ;------------------------------------
 ; mark characters to keep
 ;------------------------------------
 dim = size(bb, /dim)
 ii = make_array(dim=dim, /byte) 

; if(n_elements(p) EQ 1) then p = make_array(dim[1], val=p[0])
; if(n_elements(len) EQ 1) then len = make_array(dim[1], val=len[0])


 for i=0, dim[0]-1 do $
  begin
   w = where((p LE i) AND (p+len GT i))
   if(w[0] NE -1) then ii[i,w] = 1
  end

 ;------------------------------------
 ; extract characters
 ;------------------------------------
 sub = where(ii EQ 0)
 if(sub[0] NE -1) then bb[sub] = byte(' ')
 
 return, strtrim(string(bb), 2)

end
;=============================================================================
