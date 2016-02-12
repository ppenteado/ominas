;==============================================================================
; lic_read_proto
;
;==============================================================================
function lic_read_proto, filename, bin=bin
s_tree, nmax=nmax

 ;--------------------------
 ; read file
 ;--------------------------
 check = findfile(filename)
 if(check(0) EQ '') then return, -1

 if(keyword__set(bin)) then $
  begin
   openr, unit, filename, /get_lun
   buf = bytarr(nmax)
   readu, unit, buf
   close, unit
   free_lun, unit
  end $
 else $
  begin
   sbuf = read_txt_file(filename)
;   buf = (byte(fix(str_sep(sbuf, ' '))))[0:nmax-1]
ss = str_sep(sbuf, ' ')
ss = ss[0:nmax-1] 
buf = byte(fix(ss))
  end

 ;----------------------------------------
 ; extract host id and encryption info
 ;----------------------------------------
 off = 134
 dd = buf[0]
 nid = byte(buf[off] - dd) & off = off + 1
 hostid = string(byte(buf[off:off+nid-1] - dd))

 return, hostid
end
;==============================================================================
