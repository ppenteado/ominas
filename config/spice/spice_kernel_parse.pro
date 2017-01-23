;=============================================================================
; spice_kernel_parse
;
;=============================================================================
function spice_kernel_parse, dd, prefix, type, time=_time, $
                       explicit=explicit, strict=strict, all=all

 if(keyword_set(_time)) then time = _time

 ;----------------------------------------------------------
 ; Construct kernel input keyword and
 ; name of auto-detect function
 ; if auto-detect function does not exist, use th default 
 ; eph detector
 ;----------------------------------------------------------
 kw = strlowcase(type) + '_in'
 env = strupcase(prefix) + '_SPICE_' + strupcase(type)
 def = 'spice_' + strlowcase(type) + '_detect'
 fn = prefix + '_' + def
 if(NOT routine_exists(fn)) then fn = 'eph_' + def
 
 ;---------------------------------------
 ; Get raw kernel keyword value
 ;---------------------------------------
 _k_in = tr_keyword_value(dd, kw)
 if(NOT keyword_set(_k_in)) then return, ''

 ;---------------------------------------
 ; Get default kernel path(s)
 ;---------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; get path specific to this translator
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 kpath = getenv(env)
 w = where(kpath NE '')
 if(w[0] EQ -1) then $
  begin
   nv_message, /verb, $
     env + ' environment variable is undefined.', /con, $
       exp=[env + ' specifies the directory in which the NAIF/SPICE translator', $
            'searches for ' + strupcase(type) + ' kernel files.']
   return, ''
  end

 nkpath = n_elements(kpath)

 ;---------------------------------------
 ; parse value list
 ;---------------------------------------
 _k_in = strtrim(str_nsplit(_k_in, ';'), 2)
 k_in = ''

 for i=0, n_elements(_k_in)-1 do $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; AUTO -- try to automatically detect the correct kernel in one
   ;         of the kernel directories, or the given path.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   split_filename, _k_in[i], dir, name
   if(strupcase(name) EQ 'AUTO') then $
    begin
     for j=0, nkpath-1 do $
      begin
       path = kpath[j]
       if(keyword_set(dir)) then path = dir 
       _ff = call_function(fn, dd, path, all=all, strict=strict, time=time)
      if(keyword_set(_ff)) then ff = _ff
      end
    end $
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Otherwise, try to find the named kernel in one of the kernel
   ; directories.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else $
    begin
     for j=0, nkpath-1 do $
      begin
       if(strpos(_k_in[i], '/') EQ -1) then _k_in[i] = kpath[j] + _k_in[i]
       ff = file_search(_k_in[i])
       if(keyword_set(ff)) then explicit = append_array(explicit, ff) ;$
      end
    end

   if(keyword_set(ff)) then  k_in = append_array(k_in, ff)
  end



 return, k_in
end
;=============================================================================
