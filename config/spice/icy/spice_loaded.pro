;===========================================================================
; spice_loaded
;
;===========================================================================
function spice_loaded, full=full, verbatim=verbatim

 ;----------------------------------------------------------
 ; get list of files loaded using furnsh_c
 ;----------------------------------------------------------
 kind = 'SPK CK PCK EK TEXT'

 cspice_ktotal, kind, nk
 if(nk EQ 0) then return, ''

 kernels = strarr(nk)

 for i=0, nk-1 do $
  begin
   cspice_kdata, i, kind, file, filtyp, source, handle, found
   kernels[i] = file
  end


 if(keyword_set(verbatim)) then names = kernels $
 else if(keyword_set(full)) then names = clean_fnames(kernels) $
 else split_filename, kernels, dirs, names


 return, names
end
;===========================================================================
