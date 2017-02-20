;=============================================================================
;+
; NAME:
;       eph_spice_spk_build_db
;
;
; PURPOSE:
;       Read/Build the SPICE kernel SPK database
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       eph_spice_spk_build_db, kpath, data 
;
;
; ARGUMENTS:
;  INPUT:
;       kpath:          Path of the SPK files
;
;       data:           Structure that contains:
;                       filename:	SPK filename
;                       first:		Range start (ET seconds)
;                       last:		Range end (ET seconds)
;                       mtime:		File system date (seconds, OS dependent)
;                       lbltime:	LBL file creation date (seconds ET)
;                       installtime:	OMINAS install timestamp (Julian date)
;			stillThere:	File in database still exists in kpath
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	debug:		Outputs debug information
;
;  OUTPUT: NONE
;
;
; PROCEDURE:		File unit is allocated for internal use, then released when finished
;                       Checks for existance of database, reads if so
;                       Location of database is in ~/.ominas
;                       Filename is spice_spk_database.<kpath with / replaced by _ >
;                       (for a kpath with a wildcard, *, it is replaced by x)
;                       Compares/generates list of filename in kpath
;                       If file system time matches current database, uses that information
;                       Uses spice to calculate if it is an SPK, and the range if so
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
;
;-
;=============================================================================
pro eph_spice_spk_build_db, kpath, data, debug=debug

 ;------------------------
 ; Local parameters
 ;------------------------
 debug_set = keyword_set(debug)
 SPICEFALSE = 0B
 MAXIV      = 1000
 WINSIZ     = 2 * MAXIV
 TIMELEN    = 51
 MAXOBJ     = 1000
 exists = 0
 change = 0
 ts_tried = 0
 ts_exist = 0

 ;--------------------------------
 ; See if database exists, read it
 ;--------------------------------
 get_lun, unit

 ; Generate db filename
 ; replace / with _
 fix_path = strjoin(strsplit(kpath,'/',/extract),'_')
 ; replace * with x
 fix_path = strjoin(strsplit(fix_path,'*',/extract,/preserve_null), 'x')
 dbfile = '~/.ominas/spice_spk_database.' + fix_path

 on_ioerror, bad_db
 openr, unit, dbfile
 if debug_set then print, 'Database detected'

 ; count length of file
 count = 0L
 temporary = make_array(132,value=32b)
 stemp = string(temporary)

 while ~EOF(unit) do begin
   readf, unit, format='(a)', stemp
   count = count + 1
 endwhile
 if debug_set then print, count, ' elements in db'
 if count EQ 0 then goto, bad_db
 db = {filename:STRARR(count), first:DBLARR(count), last:DBLARR(count), mtime:DBLARR(count), $
       lbltime:DBLARR(count), installtime:DBLARR(count), stillThere:INTARR(count)}
 point_lun, unit, 0
 count = 0L
 _first = 0D
 _last = 0D
 _mtime = 0D
 _lbltime = 0D
 _installtime = 0D
 while ~EOF(unit) do begin
   readf, unit, format='(a)', stemp
   sline = strsplit(stemp,',',/extract)
   db.filename[count] = sline[0]
   reads, sline[1], _first
   reads, sline[2], _last
   reads, sline[3], _mtime 
   reads, sline[4], _lbltime
   reads, sline[5], _installtime
   db.first[count] = _first
   db.last[count] = _last
   db.mtime[count] = _mtime
   db.lbltime[count] = _lbltime
   db.installtime[count] = _installtime
   if debug_set then begin
     print, format='(A,A,F15.3,A,F15.3,A,I11,A,F15.3,A,F18.10)', db.filename[count],',',db.first[count],',', $
            db.last[count],',',db.mtime[count],',',db.lbltime[count],',',db.installtime[count]
   endif
   count = count + 1
 endwhile
 exists = 1
 goto, closeDB

 bad_db:
 exists = 0
 if debug_set then print, 'Database not found, will create'

 closeDB: 
 close, unit

 ;------------------------
 ; get all file names
 ;------------------------
 get_lun, unit
 all_files = file_search(kpath + '/*')

 ;------------------------------------------
 ; loop over all files to check if spk
 ;------------------------------------------
 newcnt = n_elements(all_files)
 dbnew = {filename:STRARR(newcnt), first:DBLARR(newcnt), last:DBLARR(newcnt), mtime:DBLARR(newcnt), $
          lbltime:DBLARR(newcnt), installtime:DBLARR(newcnt)}
 for i=0, newcnt-1 do begin

   infodat = file_info(all_files[i])
   min_first = -1
   max_last = -1
   lbltime = -1
   installtime = -1

   ;------------------------------
   ; catch block for file error
   ;------------------------------
   catch, error

   if error ne 0 then begin
     catch, /cancel
     if debug_set then print, !error_state.msg
     if debug_set then print, 'Not an spk file: ' + all_files[i] + ' (Error: ' + !error_state.name + ')'
     goto, addToOutput
   endif

   ;------------------------------------------
   ; Find if file exists in old db with times
   ; if mtime matches, use them
   ; if not, then calculate them from the file
   ;-------------------------------------------
   if exists EQ 1 then begin
     if debug_set then print, 'Comparing if file ', all_files[i], ' exists'
     inDB = where(db.filename EQ all_files[i])
     if inDB[0] NE -1 then begin
       if debug_set then print, 'File found in database'
       if debug_set then print, format='(A,I,A,I)', 'DB database time: ', db.mtime[inDB[0]], ' actual file ', infodat.mtime
       if db.mtime[inDB[0]] EQ infodat.mtime then begin
         ; Use data in database
         min_first = db.first[inDB[0]]
         max_last = db.last[inDB[0]]
         lbltime = db.lbltime[inDb[0]]
         installtime = db.installtime[inDb[0]]
         db.stillThere[inDB[0]] = 1
         if debug_set then print, 'File times match, using data from DB'
         goto, addToOutput
       endif
     endif
   endif

   ;------------------------------
   ; Find OMINAS timestamp file(s)
   ;------------------------------
   if ts_tried EQ 0 then begin
     eph_spice_read_timestamps, kpath, unit, ts_filenames, timestamps, debug=debug
     ts_tried = 1
     if ts_filenames[0] NE '' then ts_exist = 1
   endif

   ;-----------------
   ; Get spk objects
   ;-----------------
   change = 1
   cover = cspice_celld(WINSIZ)
   ids = cspice_celli(MAXOBJ)
   cspice_spkobj, all_files[i], ids
   nobjs = cspice_card(ids)
   if nobjs EQ 0 then goto, addToOutput
   infodat = file_info(all_files[i])
   if debug_set then print, 'SPK file: ' + all_files[i] + ' contains: '
   for j=0, nobjs-1 do begin
     objnum = ids.base[ids.data+j]
     cspice_bodc2n, objnum, obj, found
     if found && debug_set then print, obj
     if ~found && debug_set then print, objnum

     ;--------------------------------------
     ; For each object, collect time windows
     ;--------------------------------------
     cspice_scard, 0L, cover
     cspice_spkcov, all_files[i], objnum, cover
     nseg = cspice_wncard(cover)
     if debug_set then print, 'Number of segments: ', nseg
     for k=0, nseg-1 do begin
       cspice_wnfetd, cover, k, b, e
       if k EQ 0 then begin
           first = b
           last = e
       endif else begin
           first = [first,b]
           last = [last,e]
       endelse
       if debug_set then print, 'Segment ', k, ', begin: ', b, ', end: ', e
     endfor
   endfor
   min_first = min(first)
   max_last = max(last)

   ;----------------------
   ; Find Ominas timestamp
   ;----------------------
   if ts_exist then begin
     index = where(ts_filenames EQ all_files[i], tscount)
     if debug_set then print, 'Timestamp index = ', index
     if tscount EQ 1 then installtime = timestamps[index]
   endif

   ;--------------------
   ; Find PDS Label time
   ;--------------------
   eph_spice_read_label, all_files[i], unit, creation, debug=debug
   if creation NE '' then begin
     cspice_tparse, creation, lbl_time, lbl_error
     if lbl_time NE 0 then lbltime = lbl_time
     if debug_set then print, 'lbltime = ', lbltime, ' error= ', lbl_error
   endif

   addToOutput:
   line = string( format='(A,A,F15.3,A,F15.3,A,I11,A,F15.3,A,F15.3)', all_files[i],',',min_first,',',max_last,',', $
                  infodat.mtime,',',lbltime,',',installtime )
   dbnew.filename[i] = all_files[i]
   dbnew.first[i] = min_first
   dbnew.last[i] = max_last
   dbnew.mtime[i] = infodat.mtime
   dbnew.lbltime[i] = lbltime
   dbnew.installtime[i] = installtime
   if debug_set then print, line
   if i EQ 0 then output = line $
   else output = [output, line]

 endfor

 catch, /cancel
 ; Test to see if any original spk files in database will be removed
 if exists EQ 1 then begin
    for i=0,count-1 do begin
      if db.first[i] NE -1 && db.stillThere[i] EQ 0 then change = 1
    endfor
 endif
 if debug_set then begin
    if change EQ 0 then print, 'No changes needed, keeping existing database' $
    else print, 'Will write out new database'
 endif
 if n_elements(output) GT 1 && change EQ 1 then begin
    if n_params() then data = dbnew
    print, 'Writing SPK database'
    openw, unit, dbfile
    for i=0, n_elements(output)-1 do printf, unit, output[i]
    close, unit
 endif
 if n_params() EQ 2 then data = dbnew
 free_lun, unit

end
