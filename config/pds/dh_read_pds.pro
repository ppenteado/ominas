;=============================================================================
; dh_read_pds.pro
;
;=============================================================================
function dh_read_pds, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0

 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)

 ;--------------------------------------------------------
 ; read label
 ;--------------------------------------------------------
 label = headpds(filename, silent=silent)

 ;- - - - - - - - - - - - - - - - - - - - -
 ; get rid of CR/LFs included by headpds
 ;- - - - - - - - - - - - - - - - - - - - -
 label = strtrim(str_nnsplit(label, string(13b)), 2)

 ;- - - - - - - - - - - - - - - - - - - - -
 ; determine image dimensions
 ;- - - - - - - - - - - - - - - - - - - - -
 names = pdspar(label, 'OBJECT')

 w = where(names EQ 'IMAGE')
 w = w[0]

 s = pdspar(label, 'LINE_SAMPLES')
 xsize = long(s[w])

 s = pdspar(label, 'LINES')
 ysize = long(s[w])

 dim = [xsize, ysize]

;;; type = pdspar(label, 'SAMPLE_TYPE')
;;; need to convert this to IDL type code
;;; see imagepds.pro
min=0
max=0

 if(keyword_set(nodata)) then return, 0


 ;--------------------------------------------------------
 ; read image
 ;--------------------------------------------------------
 dat = readpds(filename, silent=silent)

 image = dat.image
 type = size(image, /type)
 if(type EQ 8) then image = image.image
 type = size(image, /type)

 return, image











 dat = readpds(filename, label, silent=silent, dim=dim, nodata=nodata)
 n = dat.objects


 if(n EQ 1) then $
  begin
   return, dat.image
  end

stop

 data = ptrarr(n)
 dim_p = ptrarr(n)

 for i=0, n-1 do $
  begin
;   data[i] = nv_ptr_new(...)
;   dim_p[i] = nv_ptr_new(...)
  end

 return, data
end
;=============================================================================
