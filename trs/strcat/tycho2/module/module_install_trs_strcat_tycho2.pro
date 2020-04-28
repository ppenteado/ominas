;=============================================================================
; module_install_trs_strcat_tycho2
;
;=============================================================================
function module_install_trs_strcat_tycho2, arg

 ;---------------------------------------------------------------------
 ; download files
 ;---------------------------------------------------------------------
 print, 'Downloading TYCHO2 data'
 baseurl = 'ftp://cdsarc.u-strasbg.fr/pub/cats/I/259/'

 wcp, baseurl + '/index.dat.gz', arg.dir, /verbose, update=arg.update
 wcp, baseurl + '/suppl_*.dat.gz', arg.dir, /verbose, update=arg.update
 wcp, baseurl + '/tyc2*.gz', arg.dir, /verbose, update=arg.update

 ;---------------------------------------------------------------------
 ; unpack catalog
 ;---------------------------------------------------------------------
 print, 'Unpacking TYCHO2 files'

 gzfiles = file_search(arg.dir + '/*.gz')
 file_gunzip, gzfiles, /delete

 print, 'TYCHO2 Installation complete'
 return, 0
end
;=============================================================================
