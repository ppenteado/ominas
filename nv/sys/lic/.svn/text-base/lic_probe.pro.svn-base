;==============================================================================
; lic_probe
;
;  Not disguised and no password because this routine is called in the clear
;  from a script that can be read by the user.
;
;==============================================================================
pro lic_probe, bin=bin
s_tree, gg=438309913l, nmax=nmax

     ;lic_filename
 ff = get_tokens(gg=438309913l, proto=filename)

 ;-------------------------------------------------
 ; if file already exists, don't create a new one
 ;-------------------------------------------------
 ff = findfile(filename)
 if(keyword__set(ff)) then $
                nv_message, 'Prototype file ' + ff[0] + ' already exists.'

 ;----------------------------
 ; get host info
 ;----------------------------
 hostid = optimize_2d(gg=438309913l)
 id = byte(hostid)
 nid = byte(n_elements(id))

 ;----------------------------
 ; construct buffer
 ;----------------------------
 off = 134
 buf = byte(randomu(x, nmax)*255b)
 dd = buf[0]
 buf[off] = byte(nid + dd) & off = off + 1
 buf[off:off+nid-1] = byte(id + dd)

 ;--------------------------
 ; write buffer
 ;--------------------------
 if(keyword__set(bin)) then $
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
