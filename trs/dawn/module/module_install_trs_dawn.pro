;=============================================================================
; module_install_trs_dawn
;
;=============================================================================
function module_install_trs_dawn, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'DAWN', kernels_dir, /verbose, update=arg.update

 return, 0
end
;=============================================================================
