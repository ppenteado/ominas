;=============================================================================
; skp_simple
;
;=============================================================================
function skp_simple, dd, path, ext=ext0

ext0='bc'

 split_filename, cor_name(dd), dir, name, ext
 if(NOT keyword_set(name)) then return, ''

 ff = file_search(path + '/' + name + '.' + ext0)
 if(keyword_set(ff)) then return, ff

 return, file_search(path + '/' + name + '.' + ext + '.' + ext0)
end
;=============================================================================



;=============================================================================
; skp_auto_detect
;
;=============================================================================
function skp_auto_detect, dd, fn, path, sc=sc, all=all, strict=strict, time=time

 if(NOT routine_exists(fn)) then return, ''

 nv_message, verb=0.9, 'Calling kernel auto-detect ' + fn
 ff = call_function(fn, dd, path, sc=sc, all=all, strict=strict, time=time)
 if(NOT keyword_set(ff)) then nv_message, verb=0.9, 'No kernels.'$
 else nv_message, verb=0.9, 'Found:', exp=transpose([ff])
 return, ff
end
;=============================================================================



;=============================================================================
; skp_auto
;
;=============================================================================
function skp_auto, dd, prefix, type, path, k_in, ext, $
                            dir=dir, sc=sc, all=all, strict=strict, time=time

 ;-----------------------------------------------
 ; get path
 ;-----------------------------------------------
 if(keyword_set(dir)) then path = dir 

 ;-----------------------------------------------
 ; try filename-based kernel names
 ;-----------------------------------------------
 ff = skp_simple(dd, path, ext=ext)
 if(keyword_set(ff)) then return, ff

 ;-------------------------------------------------
 ; try specific auto-detect function
 ;-------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - -
 ; determine function names
 ;- - - - - - - - - - - - - - - - - - - -
 base = 'spice_' + strlowcase(type) + '_detect'
 fns = prefix + '_' + base
 fng = 'gen_' + base
 fn = [fns, fng]
 nfn = n_elements(fn)

 ;- - - - - - - - - - - - - - - - - - - -
 ; call auto-detect functions
 ;- - - - - - - - - - - - - - - - - - - -
 for i=0, nfn-1 do $
   ff = append_array(ff, $
                 skp_auto_detect(dd, fn[i], path, $
                                    sc=sc, all=all, strict=strict, time=time))
 if(keyword_set(ff)) then return, ff

 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 ; if no results, give an error and return null
 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 nv_message, verb=0.9, 'No auto-detect kernels found.'
 return, ''
end
;=============================================================================



;=============================================================================
; skp_explicit
;
;=============================================================================
function skp_explicit, dd, path, k_in, ext, $
                          dir=dir, sc=sc, all=all, strict=strict, time=time

 if(strpos(k_in, '/') EQ -1) then k_in = path + k_in
 ff = file_search(k_in)
 if(keyword_set(ff)) then return, ff

 nv_message, verb=0.9, 'Not found: ' + k_in, $
   exp = ['This kernel was explicitly requested, but it cannot be found in the', $
	  'directory.'] 	    

 return, ''
end
;=============================================================================



;=============================================================================
; skp_get_paths
;
;=============================================================================
function skp_get_paths, prefix, type

; gprefix = 'GEN'
 gprefix = 'SPICE'
 senv = strupcase(prefix) + '_SPICE_' + strupcase(type)
 genv = strupcase(gprefix) + '_SPICE_' + strupcase(type)

 spath = getenvs(senv)
;return, spath
 gpath = getenvs(genv)
 path = str_cull(append_array(spath, gpath))

 return, path
end
;=============================================================================



;=============================================================================
; spice_kernel_parse
;
;=============================================================================
function spice_kernel_parse, dd, prefix, inst, type, ext=ext, time=_time, $
                       explicit=explicit, strict=strict, all=all

 if(keyword_set(_time)) then time = _time[0]

 ;-------------------------------------------------------------------
 ; Construct kernel input keyword
 ;-------------------------------------------------------------------
 kw = strlowcase(type) + '_in'

 ;---------------------------------------
 ; get NAIF sc number if possible
 ;---------------------------------------
 scfn = prefix + '_spice_sc'
 sc = 0
 if(routine_exists(scfn)) then sc = call_function(scfn, dd)

 ;---------------------------------------
 ; Get raw kernel keyword value
 ;---------------------------------------
 _k_in = dat_keyword_value(dd, kw)
 if(NOT keyword_set(_k_in)) then return, ''

 ;-----------------------------------------------------------------
 ; Get kernel path(s) if not possible, then try current directory
 ;-----------------------------------------------------------------
 path = skp_get_paths(prefix, type)
 if(NOT keyword_set(path)) then $
  begin
   nv_message, verb=0.5, $
     'Cannot determine kernel directory; trying current working directory.'
   path = './'
  end

 ;---------------------------------------
 ; search for kernels
 ;---------------------------------------
 _k_in = strtrim(str_nsplit(_k_in, ';'), 2)
 k_in = ''

 npath = n_elements(path)
 for i=0, n_elements(_k_in)-1 do $
  begin
   split_filename, _k_in[i], dir, name

   for j=0, npath-1 do $
    begin
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; AUTO -- try to automatically detect the correct kernel.
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if(strupcase(name) EQ 'AUTO') then $
          ff = skp_auto(dd, prefix, type, path[j], _k_in[i], ext, $
			  dir=dir, sc=sc, all=all, strict=strict, time=time) $
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; Otherwise, try to find the named kernel.
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     else ff = skp_explicit(dd, path[j], _k_in[i], ext, $
			  dir=dir, sc=sc, all=all, strict=strict, time=time)

     k_in = append_array(k_in, ff)
    end
  end

 ;----------------------------------------------------------------
 ; weed out duplicate kernels
 ;----------------------------------------------------------------
 names = file_basename(k_in)
 names = unique(names, sub=sub)
 k_in = k_in[sub]

 nv_message, verb=0.8, $
   'The following ' + type + ' kernels were detected:', exp = transpose([k_in])
 return, k_in
end
;=============================================================================
