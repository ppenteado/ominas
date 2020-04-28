;=============================================================================
; module_install_trs_spice
;
;=============================================================================
function module_install_trs_spice, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'generic_kernels', arg.dir + '/kernels', update=arg.update, $
        /basedir, /verbose, /recursive, exclude=['release', 'a_old_versions']

 return, 0
end
;=============================================================================
