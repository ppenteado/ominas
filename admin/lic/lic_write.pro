;==============================================================================
; lic_write
;
;  lic_override, gg=438309913l
;  settings = [0,10,20,30,40,50]
;                             lic_gethost...
;  _hostid = enigma(settings, optimize_2d())
;  lic_write, 'minas_license.dat', _hostid, settings
;
;==============================================================================
pro lic_write, filename, hostid, bin=bin
s_tree, gg=438309913l, nodes=nodes, nmax=nmax, ii=ii

 nset = 33

 ;-----------------------------------------------------
 ; generate random rotor settings and encrypt host id
 ;-----------------------------------------------------
 _settings = byte(randomu(x, nset)*255b)
 settings = byte(enigma(nodes-100b, _settings))
 _hostid = enigma(settings, hostid)
 id = byte(_hostid)
 nid = byte(n_elements(id))

 ;--------------------------
 ; create buffer
 ;--------------------------
 buf = byte(randomu(x, nmax)*255b)
 buf[0] = buf[0] > 128b						; tamper flag

 offset = fix(randomu(x) * nmax/2) + 1

 buf[ii] = offset 
 
 nn = offset
 buf[nn] = nid & nn = nn + 1
 buf[nn:nn+nid-1] = byte(id + 39) & nn = nn + nid
 buf[nn] = nset & nn = nn + 1
 buf[nn:nn+nset-1] = byte(_settings + 27)

 buf[nmax-1] = byte(total(buf[0:nmax-2]))			; checksum

 ;--------------------------
 ; write buffer
 ;--------------------------
 if(keyword_set(bin)) then $
  begin
   openw, unit, filename, /get_lun
   writeu, unit, buf
   close, unit
   free_lun, unit
  end $
 else $
  begin
   sbuf = ''
   for i=0, nmax-1 do $
              sbuf = sbuf + strtrim(string(buf[i], format='(i)'),2) + ' '
   write_txt_file, filename, sbuf
  end


end
;==============================================================================
