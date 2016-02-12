;==============================================================================
; lic_read; disguised as maxz.pro
;
;==============================================================================
function maxz, filename, settings=settings, gg=gg, bin=bin
s_tree, gg=gg, nmax=nmax, ii=ii, nodes=nodes


 on_error, 2

;lic_validate_pwd...
 tvhash, 2b, gg=gg
 gg = 0

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
 if(buf[0] LT 128b) then return, -3

 sum = byte(total(buf[0:nmax-2]))
 if(sum NE buf[nmax-1]) then return, -2

 offset = buf[ii]

 nn = offset
 nid = buf[nn] & nn = nn + 1
 id = byte(buf[nn:nn+nid-1] - 39) & nn = nn + nid
 nset = buf[nn] & nn = nn + 1
 _settings = byte(buf[nn:nn+nset-1] - 27)
 settings = byte(enigma(nodes-100b, _settings))

 _hostid = string(id)

 return, _hostid
end
;==============================================================================

