;===========================================================================
; spice_read_klist
;
;
;===========================================================================
function spice_read_klist, dd, klist, ck_out=ck_out, silent=silent, $
                                                time=_time, prefix=prefix
common spice_klist_block, klist_last, _inlines

 fn_spice_time = prefix + '_spice_time'
 ndd = n_elements(dd)

; if(NOT keyword_set(_time)) then $
;   et = spice_str2et(call_function(fn_spice_time, label)) $
; else et = _time
; et = et[0]

 ;--------------------------------------------
 ; read input file
 ;--------------------------------------------
 read = 0
 if(NOT keyword_set(_inlines)) then read = 1
 if(keyword_set(klist_last)) then if(klist NE klist_last) then read = 1
 if(read) then $
  begin
   inlines = strip_comment(read_txt_file(klist))
   klist_last = klist
   _inlines = inlines
   if(NOT keyword_set(silent)) then $
           nv_message, /con, verb=0.2, 'Read kernel list file ' + klist + '.'
  end $
 else inlines = _inlines

 ;---------------------------------------------------------------------------
 ; truncate file at first occurrence of 'end' at beginning of line, if any
 ;---------------------------------------------------------------------------
 ww = where(strupcase(strmid(inlines, 0, 3)) EQ 'END')
 if(ww[0] ne -1) then inlines = inlines[0:ww[0]-1]


 ;--------------------------------------------
 ; scan input file, expanding expressions
 ;--------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; look for SET keyword at beginning of lines
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 wset = where(strpos(inlines, 'SET') EQ 0)
 if(wset[0] NE -1) then $
  begin
   setlines = inlines[wset]
   nset = n_elements(setlines)
   set = strcompress(strmid(setlines, 3, 1000), /remove_all)
   for i=0, nset-1 do setenv, set[i]
;   for i=0, nset-1 do spawn, 'set ' + set[i]
   inlines = rm_list_item(inlines, wset, only='')
  end


 nlines = n_elements(inlines)
 if(nlines EQ 0) then return, ''

 default_lines = (time_lines = '')
 standard_lines = inlines


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; look for DEFAULT keyword at beginning of lines
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 wdefault = where(strpos(inlines, 'DEFAULT') EQ 0)
 if(wdefault[0] NE -1) then $
  begin
   if(nlines GT wdefault[0]+1) then default_lines = inlines[wdefault[0]+1:*]
   standard_lines = standard_lines[0:wdefault[0]-1]
  end

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; look for TIME_START, TIME_STOP keywords at beginnings of lines
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 wstart = where(strpos(inlines, 'START_TIME') EQ 0)


 if(wstart[0] NE -1) then $
  begin
   if(NOT defined(_time)) then $
    for i=0, ndd-1 do $
      et = append_array(et, $
                 call_function(fn_spice_time, dat_header(dd[i]))) $
   else et = _time
  _time = et

   standard_lines = standard_lines[0:wstart[0]-1]

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; look for stop times and include appropriate lines 
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - -
   wstop = where(strpos(inlines, 'STOP_TIME') EQ 0)
   if((wstop[0] EQ -1) OR $
       (n_elements(wstop) NE n_elements(wstart))) then $
         nv_message, klist + ': One STOP_TIME required for each START_TIME.'

   junk = str_nnsplit(inlines(wstart), '=', rem=start_times)
   junk = str_nnsplit(inlines(wstop), '=', rem=stop_times)

   et_start = spice_str2et(start_times)
   et_stop = spice_str2et(stop_times)

   w = where((et_start LT min(et)) AND (et_stop GT max(et)))
   if(w[0] NE -1) then time_lines = inlines[wstart[w[0]]+1:wstop[w[0]]-1]
  end

 inlines = [standard_lines, time_lines]
 if(NOT keyword_set(time_lines)) then inlines = [inlines, default_lines]
 nlines = n_elements(inlines)

 outfiles = strarr(nlines)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; scan the selected lines
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 j = 0
 for i=0, nlines-1 do $
  begin
   line = inlines[i]
   if(keyword__set(line)) then $
    begin
     files = file_search(line)
     if(keyword__set(files)) then $
      begin
       n = n_elements(files)
       if(n EQ 1) then outfiles[j] = files $
       else $
        begin
         outfiles = [outfiles, strarr(n)]
         outfiles[j:j+n-1] = files
        end
       j = j + n
      end $
     else nv_message, /con, 'Not found: ' + line
    end
  end
 if(j EQ 0) then return, ''


 outfiles = outfiles[0:j-1]


 ;--------------------------------------------
 ; remove degenerate slashes
 ;--------------------------------------------
 nfiles = n_elements(outfiles)
 for i=0, nfiles-1 do if(keyword__set(outfiles[i])) then $
  begin
   slash = 0
   if(strmid(outfiles[i], 0, 1) EQ '/') then slash = 1

   ss = strtrim(str_nsplit(outfiles[i], '/'), 2)
   w = where(ss NE '')
   if(w[0] EQ -1) then outfiles[i] = '' $
;   else outfiles[i] = '/' + str_cat(ss[w], ins='/')
   else outfiles[i] = str_cat(ss[w], ins='/')
   if(slash) then outfiles[i] = '/' + outfiles[i]
  end


 return, outfiles
end
;===========================================================================
