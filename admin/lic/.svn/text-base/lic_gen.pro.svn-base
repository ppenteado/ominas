;==============================================================================
; lic_gen
;
;  Input:  minas_prototype.dat in current dir. Received from user
;  Output: minas_license.dat in current dir. Send back to user.
;
;==============================================================================
pro lic_gen

 ;----------------------------------------------------------
 ; get filenames, but read and write only in current dir.
 ;----------------------------------------------------------
 _out_fname = get_tokens(gg=438309913l, proto=_in_fname)
 split_filename, _out_fname, dir, out_fname
 split_filename, _in_fname, dir, in_fname
 out_fname = './' + out_fname
 in_fname = './' + in_fname

 ;----------------------------------------------------------
 ; read prototype file
 ;----------------------------------------------------------
 hostid = lic_read_proto(in_fname)

 ;----------------------------------------------------------
 ; write license file
 ;----------------------------------------------------------
 lic_write, out_fname, hostid


end
;==============================================================================
