;=============================================================================
; module_install_trs_cas
;
;=============================================================================
function module_install_trs_cas, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'CASSINI', kernels_dir, /verbose, update=arg.update


 return, 0
end
;=============================================================================
