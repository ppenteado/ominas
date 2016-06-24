;=============================================================================
; spice_kernel_parse
;
;=============================================================================
function spice_kernel_parse, dd, prefix, type, time=_time, $
                  reject=reject, explicit=explicit, strict=strict, all=all
 
 if(keyword_set(_time)) then time = _time

 ;---------------------------------------
 ; Construct kernel input keyword and
 ; name of auto-detect function
 ;---------------------------------------
 kw = strlowcase(type) + '_in'
 env = 'NV_SPICE_' + strupcase(type)
 fn = prefix + '_spice_' + strlowcase(type) + '_detect'

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
 kpath = str_nsplit(getenv(env), ':')
 w = where(kpath NE '')
 if(w[0] EQ -1) then return, ''

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
       _ff = call_function(fn, dd, path, $
                      reject=reject_kernels, all=all, strict=strict, time=time)
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
       ff = findfile(_k_in[i])
       if(keyword_set(ff)) then explicit = append_array(explicit, ff) ;$
      end
    end

   if(keyword_set(ff)) then  k_in = append_array(k_in, ff)
  end


 ;-------------------------------------------------------------
 ; record names of kernels rejected by the auto-detect routine
 ;-------------------------------------------------------------
 if(keyword_set(reject) AND keyword_set(reject_kernels)) then $
  begin
   split_filename, reject_kernels, dirs, names
   tag = strupcase(type) + '_REJECTED_KERNELS'
   cor_set_udata, dd, tag, names
  end


 return, k_in
end
;=============================================================================
