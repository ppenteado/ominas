;=============================================================================
; module_install_trs_juno
;
;=============================================================================
function module_install_trs_juno, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'JUNO', kernels_dir, /verbose, update=arg.update

 return, 0
end
;=============================================================================
