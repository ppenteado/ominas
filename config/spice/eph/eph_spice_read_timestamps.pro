;=============================================================================
;+
; NAME:
;       eph_spice_read_timestamps
;
;
; PURPOSE:
;       Reads an OMINAS install file for kernels for a particular path
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       eph_spice_read_timestamps, path, unit, filenames, timestamps
;
;
; ARGUMENTS:
;  INPUT:
;       path:		Path of the kernel files
;
;       unit:		IDL file unit to use
;
;  OUTPUT:
;	filenames:	String array of filenames in path
;	timestamps:	Timestamps for files in path (JD)
;
;
; KEYWORDS:
;  INPUT:
;	debug:		Outputs debug information
;
;  OUTPUT: NONE
;
;
; PROCEDURE:		Converts path into OMINAS timestamp filename
;			If path contains wildcard, checks for all timestamp files which apply
;                       Reads json files to get filename and timestamp
;                       Returns as two string arrays
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
pro eph_spice_read_timestamps, path, unit, filenames, timestamps, debug=debug

 ;------------------------
 ; Local parameters
 ;------------------------
 debug_set = keyword_set(debug)
 count = 0L
 first = 1

 ; Generate template filename(s)
 ; replace / with _
 fix_path = strjoin(strsplit(path,'/',/extract),'_')
 tsfile = '~/.ominas/timestamps/' + fix_path

 ts_files = file_search(tsfile + '.json')
 tscnt = n_elements(ts_files)
 if debug_set then print, 'Found ', tscnt, ' timestamp file(s)'
 filenames = ''
 if n_elements(ts_files) EQ 0 then return

 ;-----------------------
 ; loop over all ts files
 ;-----------------------
 for i=0, tscnt-1 do begin
 
   on_ioerror, close_ts
   openr, unit, ts_files[i]
   if debug_set then print, 'Timestamp file ', ts_files[i], ' detected'

   ; count length of file
   count = 0L
   temporary = make_array(200,value=32b)
   stemp = string(temporary)

   while ~EOF(unit) do begin
     readf, unit, format='(a)', stemp
     count = count + 1
   endwhile
   ; Skip end brackets
   newcnt = count - 2
   if debug_set then print, newcnt, ' elements in timestamps file'
   if count EQ 0 then goto, close_ts

   new_filename = STRARR(newcnt)
   new_installtime = DBLARR(newcnt)
   point_lun, unit, 0
   count = 0L
   _installtime = 0D

   ; Skip "{"
   readf, unit, format='(a)', stemp

   while ~EOF(unit) do begin
     readf, unit, format='(a)', stemp
     if stemp EQ '}' then goto, close_ts
     line = strsplit(stemp,':',/extract)
     file = strsplit(stemp,'"',/extract)
     new_filename[count] = file[1]
     reads, line[1], _installtime
     new_installtime[count] = _installtime
     count = count + 1
   endwhile 

   close_ts:
   close, unit

   if count GT 0 then begin
     if first EQ 1 then begin 
       filenames = new_filename
       timestamps = new_installtime
       first = 0
     endif else begin
       filenames = [filenames, new_filename]
       timestamps = [timestamps, new_installtime]
     endelse
   endif

 endfor

end
