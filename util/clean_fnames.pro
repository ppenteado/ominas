;==============================================================================
; clean_fnames
;
;==============================================================================
function clean_fnames, _fnames
 fnames = _fnames

 n = n_elements(fnames)

 for i=0, n-1 do $
  begin
   fname = fnames[i]

   p = strpos(fname, '//')
   while(p[0] NE -1) do $
    begin
     fname = strcompress(strep(fname, '/ ', p[0]), /rem)
     p = strpos(fname, '//')
    end

   fnames[i] = fname
  end

 return, fnames
end
;==============================================================================
