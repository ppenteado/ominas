;=============================================================================
;+
; NAME:
;       eph_spice_ck_detect
;
;
; PURPOSE:
;       Return filenames of CKs approprate to given time, in correct order
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       files = eph_spice_ck_detect( ckpath, sc=xxx, time=xxx ) 
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;       ckpath:         Path of the CK files
;
;	sc:		NAIF spacecraft ID 
;
;       time:           Time for CK coverage (optional if using /all)
;
;	djd:		Window around time to include coverage for (days, default=1)
;
;  OUTPUT: 
;	files:		Array of CK filenames for use with cspice_furnsh
;
;
; KEYWORDS:
;  INPUT:
;	all:		Return all CKs (time not needed in this case)
;	
;	strict:		No function.  Included for consistent interface.
;	
;	debug:		Outputs debug information
;
;  OUTPUT: NONE
;
;
; PROCEDURE:		Read CK database
;                       Deterimine CKs which have coverage for given time (or all)
;			Determine which time base to use for ordering: file system, PDS LBL time, or OMINAS timestamp
;                       Return ordered file list
;
; RESTRICTIONS:
;			SCLK file and Leapseconds kernel need to be loaded
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
function eph_spice_ck_detect, dd, ckpath, $
               djd=djd, sc=sc, time=_time, all=all, strict=strict, debug=debug

 if(NOT keyword_set(sc)) then nv_message, name='eph_spice_ck_detect', $
                                              'Spacecraft must be specified.'

 if(keyword_set(_time)) then time = _time
 if(NOT keyword_set(djd)) then djd = 1d                 ; days, +/-
 djd = djd * 86400d                                     ; seconds

 if(~keyword_set(all) && ~keyword_set(time)) then begin
    nv_message, name='eph_spice_ck_detect', 'Must specify /all or time.'
 endif

 ;------------------------
 ; Local parameters
 ;------------------------
 debug_set = keyword_set(debug)

 ;--------------------------------
 ; Get kernel database 
 ;--------------------------------
 eph_spice_ck_build_db, ckpath, data, debug=debug

 ;------------------------
 ; Get appropriate kernels
 ;------------------------
 if keyword_set(all) then begin
   ; get all files with valid ranges
   valid = where(data.first NE -1, count)
   if debug_set then print, 'Number of valid kernels = ', count
   if debug_set then print, 'Valid indexes = ', valid
 endif else begin
   ; convert ET to sclk ticks
   cspice_sce2t, sc, time-djd, before_ticks
   cspice_sce2t, sc, time+djd, after_ticks
   if debug_set then print, 'sc ticks = (before) ', before_ticks, ' (after) ', after_ticks
   ; get all files with valid ranges that include inputted time
   valid = where(data.first LT after_ticks AND data.last GT before_ticks, count)
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
