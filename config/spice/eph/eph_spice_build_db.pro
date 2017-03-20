;=============================================================================
;+
; NAME:
;       eph_spice_build_db
;
;
; PURPOSE:
;       Read/Build the SPICE kernel database
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       eph_spice_build_db, kpath, data 
;
;
; ARGUMENTS:
;  INPUT:
;       kpath:          Path of the kernel files
;
;	type:		Type of kernel: 'c' or 'sp'.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
;  RETURN:              Structure that contains:
;                       filename:	Kernel filename
;                       first:		Range start (ET seconds)
;                       last:		Range end (ET seconds)
;                       mtime:		File system date (seconds, OS dependent)
;                       lbltime:	LBL file creation date (seconds ET)
;                       installtime:	OMINAS install timestamp (Julian date)
;			stillThere:	File in database still exists in kpath
;
;
; PROCEDURE:		File unit is allocated for internal use, then released when finished
;                       Checks for existence of database, reads if so
;                       Location of database is in ~/.ominas
;                       Filename is spice_<type>k_database.<kpath with / replaced by _ >
;                       (for a kpath with a wildcard, *, it is replaced by x)
;                       Compares/generates list of filename in kpath
;                       If file system time matches current database, uses that information
;                       Uses spice to calculate the range if so
;                       Calls eph_spice_read_label to read from LBL file for PRODUCT_CREATION_TIME
;                       Calls eph_spice_read_timestamp to read OMINAS timestamp file in ~/.ominas/timestamps
;                       Generates structure of information to return in data (optional if supplied)
;                       Writes database if it did not exist.
;
;
; RESTRICTIONS:
;
;
; STATUS:
;       Complete.
;
;
; MODIFICATION HISTORY:
;       Written by:     V. Haemmerle,  Feb. 2017
;	Addapted by:	J.Spitale      Feb. 2017
;
;-
;=============================================================================



;=============================================================================
; esbd_kcov
;
;=============================================================================
pro esbd_kcov, type, file, objnum, SPICEFALSE, cover, status=status

 status = 0

 catch, error
 if(error ne 0) then $
  begin
   catch, /cancel
   status = -1
   return
 end

 if(type EQ 'sp') then cspice_spkcov, file, objnum, cover $
 else cspice_ckcov, file, objnum, SPICEFALSE, 'SEGMENT', 0.D, 'SCLK', cover
end
;=============================================================================



;=============================================================================
; esbd_kobj
;
;=============================================================================
pro esbd_kobj, type, file, ids, status=status

 status = 0

 catch, error
 if(error ne 0) then $
  begin
   catch, /cancel
   status = -1
   return
 end

 call_procedure, 'cspice_' + type + 'kobj', file, ids
end
;=============================================================================



;=============================================================================
; eph_spice_build_db
;
;=============================================================================
function eph_spice_build_db, kpath, type

 ;------------------------
 ; Local parameters
 ;------------------------
 SPICEFALSE = 0B
 MAXIV      = 1000
 WINSIZ     = 2 * MAXIV
 TIMELEN    = 51
 MAXOBJ     = 1000

 ;-------------------------------------
 ; Generate db filename
 ; replace / with _
 ;-------------------------------------
 fix_path = strjoin(strsplit(kpath,'/',/extract),'_')

 ;-------------------------------------
 ; replace * with x
 ;-------------------------------------
 fix_path = strjoin(strsplit(fix_path,'*',/extract,/preserve_null), 'x')
 dbfile = '~/.ominas/spice_' + type + 'k_database.' + fix_path

 ;-------------------------------------
 ; attempt to read db file
 ;-------------------------------------
 db_files = ''
 db = eph_spice_read_db(dbfile)
 n_db = n_elements(db)
 if(keyword_set(db)) then db_files = db.filename

 ;-------------------------------------
 ; get all filenames
 ;-------------------------------------
 all_files = file_search(kpath + '/*')
 n_all = n_elements(all_files)

 ;-------------------------------------
 ; check against current db 
 ;-------------------------------------
 ww = nwhere(all_files, db_files)
 if(ww[0] NE -1) then w = complement(all_files, ww) $
 else w = indgen(n_all)

 ;------------------------------------------------------
 ; remove any files that have disappeared
 ;------------------------------------------------------
 www = set_difference(w, lindgen(n_db))
 if(www[0] NE -1) then db = rm_list_item(db, www) 


 ;-------------------------------------------
 ; if no changes, return current database
 ;-------------------------------------------
 if((w[0] EQ -1) AND (www[0] EQ -1)) then return, db
 

 ;---------------------------------------------------
 ; if new files remain, build new database records
 ;---------------------------------------------------
 n_new = n_elements(w)
 if(n_new GT 0) then $
  begin
   new_files = all_files[w]
   nv_message, /con, 'Updating ' + strupcase(type) + ' kernel database...'

   ;---------------------------------------------------
   ; read timestamps files
   ;---------------------------------------------------
   timestamps = eph_spice_read_timestamps(kpath, ts_filenames)

   ;---------------------------------------------------
   ; build new records
   ;---------------------------------------------------
   dbnew = replicate({eph_db_struct}, n_new)
   for i=0, n_new-1 do $
    begin
     dbnew[i].filename = new_files[i]

     infodat = file_info(new_files[i])
     min_first = -1
     max_last = -1
     lbltime = -1
     installtime = -1

     cover = cspice_celld(WINSIZ)
     ids = cspice_celli(MAXOBJ)

     ;----------------------------------
     ; get ids of all bodies in kernel
     ;----------------------------------
     esbd_kobj, type, new_files[i], ids, status=status
     if(status EQ 0) then $
      begin
       nobjs = cspice_card(ids)

       found = 0
       if(nobjs GT 0) then $
        begin
         first = (last = '')

         for j=0, nobjs-1 do $
          begin
           objnum = ids.base[ids.data+j]
           cspice_bodc2n, objnum, obj, found
           cspice_scard, 0L, cover

           ;----------------------------------------
           ; For each object, collect time windows
           ;----------------------------------------
           esbd_kcov, type, new_files[i], objnum, SPICEFALSE, cover, status=status
           if(status EQ 0) then $
            begin
             found = 1
             nseg = cspice_wncard(cover)
             nv_message, /verbose, 'Number of segments: ' + strtrim(nseg,2)
             for k=0, nseg-1 do $
              begin
               cspice_wnfetd, cover, k, b, e
               first = append_array(first,b)
               last = append_array(last,e)    
 
               nv_message, /verbose, $
                'Segment ' + strtrim(k,2) + ', begin: '+ strtrim(b,2) + ', end: ' + strtrim(e,2)
              end
            end
          end

         if(found) then $
          begin
           min_first = min(first)
           max_last = max(last)

           ;------------------------
           ; Find Ominas timestamp
           ;------------------------
           index = where(ts_filenames EQ new_files[i], tscount)
           nv_message, /verbose, 'Timestamp index = ' + strtrim(index,2)
           if(tscount EQ 1) then installtime = timestamps[index]

           ;----------------------
           ; Find PDS Label time
           ;----------------------
           creation = eph_spice_read_label(new_files[i])
           if(keyword_set(creation)) then $
            begin
             cspice_tparse, creation, lbl_time, lbl_error
             if lbl_time NE 0 then lbltime = lbl_time
            end
          end

         ;----------------------
         ; add record
         ;----------------------
         dbnew[i].filename = new_files[i]
         dbnew[i].first = min_first
         dbnew[i].last = max_last
         dbnew[i].mtime = infodat.mtime
         dbnew[i].lbltime = lbltime
         dbnew[i].installtime = installtime
        end
      end
    end
  end


 ;----------------------
 ; write database
 ;----------------------
 eph_spice_write_db, dbfile, dbnew


 return, dbnew
end
;=============================================================================
