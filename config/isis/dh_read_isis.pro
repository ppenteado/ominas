;=============================================================================
; dh_read_isis.pro
;
;=============================================================================
function dh_read_isis, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

 ;-----------------------------------------------------------------------
 ; min , max set to zero because no way to determine without reading
 ; entire data array
 ;-----------------------------------------------------------------------
 min=0
 max=0

 ;-----------------------------------------------------------------------
 ; read data array, subject to /nodata
 ;-----------------------------------------------------------------------
 cube=pp_readcube(filename)
 data=keyword_set(nodata) ? 0 : cube.core
 label=strjoin(cube.label,string(10B))+string(10B)+strjoin(cube.history,string(10B))
 ns=cube.samples
 nl=cube.lines
 nb=cube.bands
 type=size(cube.core,/type)
 dim = degen_array([ns, nl, nb])

 ;-----------------------------------------------------------------------
 ; construct generic file format descriptor
 ;-----------------------------------------------------------------------
 recsize=long(cube.getfromheader('RECORD_BYTES'))

 file_offset = long64(cube.getfromheader('\^QUBE'))*recsize

 data_offset = lonarr(n_elements(dim))
 
 gff = gff_create(filename[0], dim, type, $
                 file_offset=file_offset, data_offset=data_offset)


 return, data
end
;=============================================================================
