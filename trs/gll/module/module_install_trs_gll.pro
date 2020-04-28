;=============================================================================
; module_install_trs_gll
;
;=============================================================================
function module_install_trs_gll, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'GLL', kernels_dir, /verbose, update=arg.update

 return, 0
end
;=============================================================================
