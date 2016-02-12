;=============================================================================
; str_insert
;
;  Inserts ss into s at position pos.
;
;=============================================================================
function str_insert, s, ss, pos

 sd = str_decomp(s)
 dim = size(sd, /dim)
 if(n_elements(dim) EQ 1) then dim = [dim,1]

 ssd = str_decomp(make_array(dim[1], val=ss))
 nss = strlen(ss)
 xd = strarr(dim[0]+nss, dim[1])
 if(pos NE 0) then xd[0:pos-1,*] = sd[0:pos-1,*]
 xd[pos:pos+nss-1,*] = ssd  
 xd[pos+nss:*,*] = sd[pos:*,*]

 return, str_recomp(xd)
end
;=============================================================================
