;=============================================================================
; eph_spice_write_db
;
;=============================================================================
pro eph_spice_write_db, dbfile, db

 nv_message, verb=0.9, 'Writing kernel data base file ' + dbfile

 format = '(F20.3)'
 tab = transpose( $
         [transpose([db.filename]), $
          transpose([string(db.first, format=format)]), $
          transpose([string(db.last, format=format)]), $
          transpose([string(db.mtime, format=format)]), $
          transpose([string(db.lbltime, format=format)]), $
          transpose([string(db.installtime, format=format)])])

 write_txt_table, dbfile, tab, delim=','
 eph_spice_cache_db, dbfile, db

end
;=============================================================================
