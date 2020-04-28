;=============================================================================
; spice_download_kernels_by_type
;
;=============================================================================
function spice_download_kernels_by_type, url, dir, $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude

 type = file_basename(dir)

 if(keyword_set(update)) then print, 'Updating files from ' + url $
 else print, 'Downloading files from ' + url

 wcp, url, dir, $
      update=update, verbose=verbose, status=status, recursive=recursive, exclude=exclude
 if(status EQ 0) then print, strupcase(type) + ' finished.'

 return, status
end
;=============================================================================



;=============================================================================
; spice_download_kernels
;
;=============================================================================
pro spice_download_kernels, mission, kernel_dir, $
   update=update, verbose=verbose, basedir=basedir, recursive=recursive, exclude=exclude

 naifurl = 'http://naif.jpl.nasa.gov/pub/naif/' + mission
 baseurl = naifurl
 if(NOT keyword_set(basedir)) then baseurl = baseurl + '/kernels'

 if(spice_download_kernels_by_type(baseurl + '/fk/*.tf', kernel_dir + '/fk', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/ik/*.ti', kernel_dir + '/ik', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/lsk/*.tls', kernel_dir + '/lsk', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/pck/*.tpc', kernel_dir + '/pck', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/sclk/*.tsc', kernel_dir + '/sclk', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/ck/*.bc', kernel_dir + '/ck', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return
 if(spice_download_kernels_by_type(baseurl + '/ck/*.lbl', kernel_dir + '/ck', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(spice_download_kernels_by_type(baseurl + '/spk/*.bsp', kernel_dir + '/spk', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return
 if(spice_download_kernels_by_type(baseurl + '/spk/*.lbl', kernel_dir + '/spk', $
           recursive=recursive, update=update, verbose=verbose, exclude=exclude)) then return

 if(keyword_set(update)) then print, 'Update complete.' $
 else print, 'Installation complete.'
end
;=============================================================================


