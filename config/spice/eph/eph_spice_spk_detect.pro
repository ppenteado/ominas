;=============================================================================
;+
; NAME:
;       eph_spice_spk_detect
;
;
; PURPOSE:
;       Return filenames of SPKs approprate to given time, in correct order
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       files = eph_spice_spk_detect( kpath, time ) 
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;       kpath:          Path of the SPK files
;
;	sc:		NAIF spacecraft ID 
;
;       time:           Time for SPK coverage (optional if using /all)
;
;  OUTPUT: 
;	files:		Array of SPK filenames for use with cspice_furnsh
;
;
; KEYWORDS:
;  INPUT:
;	all:		Return all SPKs
;
;	strict:		No function.  Included for consistent interface.
;	
;	debug:		Outputs debug information
;
;  OUTPUT: NONE
;
;
; PROCEDURE:		Read SPK database
;                       Deterimine SPKs which have coverage for given time (or all)
;			Determine which time base to use for ordering: file system, PDS LBL time, or OMINAS timestamp
;                       Return ordered file list
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
function eph_spice_spk_detect, dd, kpath, $
                        sc=sc, all=all, time=_time, strict=strict, debug=debug

 if(keyword_set(_time)) then time = _time

 if(~keyword_set(all) && ~keyword_set(time)) then begin
    nv_message, name='eph_spice_spk_detect', '/all or time must be specified.'
 endif

 ;------------------------
 ; Local parameters
 ;------------------------
 debug_set = keyword_set(debug)

 ;--------------------------------
 ; Get kernel database 
 ;--------------------------------
 eph_spice_spk_build_db, kpath, data, debug=debug

 ;------------------------
 ; Get appropriate kernels
 ;------------------------
 if keyword_set(all) then begin
   ; get all files with valid ranges
   valid = where(data.first NE -1, count)
   if debug_set then print, 'Number of valid kernels = ', count
   if debug_set then print, 'Valid indexes = ', valid
 endif else begin
   ; get all files with valid ranges that include inputted time
   valid = where(data.first LT time AND data.last GT time, count)
   if debug_set then print, 'Number of valid kernels including given time = ', count
   if debug_set then print, 'Valid indexes = ', valid
 endelse
 if count EQ 0 then return, ''

 ;-----------------------------
 ; Find method to sort files
 ; If lbltime exists, use that
 ; If not, try installtime
 ; If not, use file system time
 ;-----------------------------
 files = data.filename[valid] 
 bad = where(data.lbltime[valid] EQ -1., count)
 if count NE 0 then begin
   bad = where(data.installtime[valid] EQ -1., count)
   if count NE 0 then begin
     times = data.mtime[valid]
     if debug_set then print, 'Using file system times to sort'
   endif else begin
     times = data.installtime[valid]
     if debug_set then print, 'Using OMINAS timestamps to sort' 
   endelse
 endif else begin
    times = data.lbltime[valid]
    if debug_set then print, 'Using PDS Label times to sort'
 endelse

 ;-------------------
 ; Sort files by time
 ;-------------------
 ss = sort(times)
 files = files[ss]

 return, files

end
