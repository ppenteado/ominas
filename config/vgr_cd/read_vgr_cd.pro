;=============================================================================
; rvgrcd_pdslab
;
;=============================================================================
function rvgrcd_pdslab, filename

 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 record = assoc(unit, bytarr(4096,/nozero), 2)
 b = record[0]
 w = where(b EQ 0)
 nw = n_elements(w)
 pdslab = ''

 w = [-1,w]
 i = 0
 done = 0
 while(NOT done) do $
  begin
   line = strtrim(string(b[w[i]+1:w[i+1]-1]), 2)
   pdslab = append_array(pdslab, line)
   if(line EQ 'END') then done = 1
   i= i + 1
  end
 p = strpos(pdslab, '=')
 w = where(p NE -1)
 pdslab = pdslab[w]

 close, unit
 free_lun, unit

 return, pdslab
end
;=============================================================================



;=============================================================================
; rvgrcd_getval
;
;=============================================================================
function rvgrcd_getval, pdslab, keyword

 p = strpos(pdslab, keyword)
 w = min(where(p EQ 0))
 if(w[0] EQ -1) then return, ''

 line = pdslab[w]
 p = strpos(line, '=')
 value = strtrim(strmid(line, p[0]+1, strlen(line)-1), 2)

 return, value
end
;=============================================================================



;=============================================================================
; read_vgr_cd.pro
;
;=============================================================================
function read_vgr_cd, filename, label, sample=sample, nodata=nodata

 ;---------------------------------------
 ; read image data
 ;---------------------------------------
 path = vgr_cd_bin_path()
 image = bytarr(800,800, /nozero)

 if(NOT keyword_set(nodata)) then $
   status = call_external(path + 'vgr_cd_input.so', 'read_image', $
                        value=[1,0], $
                        filename, image)


 ;---------------------------------------
 ; fabricate a label
 ;---------------------------------------
 label = "LBLSIZE=800             FORMAT='BYTE'  TYPE='IMAGE'"
 label = label + "  BUFSIZ=800  DIM=2  EOL=0  RECSIZE=800  ORG='BSQ'"
 label = label + "  NL=800  NS=800  NB=1  N1=0  N2=0  N3=0  N4=0  NBB=0  NLB=0"

 ;------------------------------------------
 ; read pds label and extract relevant info
 ;------------------------------------------
 pdslab = rvgrcd_pdslab(filename)

 sc = rvgrcd_getval(pdslab, 'SPACECRAFT_NAME')
 p = strpos(sc, 'VOYAGER_1')
 if(p[0] NE -1) then sc = 'VGR-1'
 p = strpos(sc, 'VOYAGER_2')
 if(p[0] NE -1) then sc = 'VGR-2'

 fds = rvgrcd_getval(pdslab, 'IMAGE_NUMBER')
 p = strpos(fds, ' ')
 if(p[0] NE -1) then fds = strmid(fds, 0, p[0])

 inst = rvgrcd_getval(pdslab, 'INSTRUMENT_NAME')
 p = strpos(inst, 'NARROW')
 if(p[0] NE -1) then inst= 'NA CAMERA'
 p = strpos(inst, 'WIDE')
 if(p[0] NE -1) then inst = 'WA CAMERA' 

 exp = rvgrcd_getval(pdslab, 'EXPOSURE_DURATION')
 p = strpos(exp, ' ')
 if(p[0] NE -1) then exp = strmid(exp, 0, p[0])
 exp = strtrim(string(double(exp)*1000d), 2)

 picno = rvgrcd_getval(pdslab, 'IMAGE_ID')
 picno = strmid(picno, 1, strlen(picno)-2)

 target = rvgrcd_getval(pdslab, 'TARGET_NAME')

 filter = rvgrcd_getval(pdslab, 'FILTER_NAME')
 filter = strmid(filter, 0, strlen(filter)-1)

 image_time = rvgrcd_getval(pdslab, 'IMAGE_TIME')
 p = strpos(image_time, 'UNKNOWN')
 if(p[0] EQ -1) then scet = vgr_image_time_to_scet(image_time) $
 else scet = 'UNKNOWN'


 ;------------------------------------------
 ; add info to vicar label
 ;------------------------------------------
 vicsetpar, label, 'IMAGE_TIME', image_time
 vicsetpar, label, 'LAB01', $
  '                     800     800 800 800 L 1                          SC'
 vicsetpar, label, 'LAB02', $
    sc + '   FDS ' + fds + '   PICNO ' + picno + '   SCET ' + scet
 vicsetpar, label, 'LAB03', $
    inst + '  EXP ' + exp + ' MSEC'
 label = str_pad(label, 800)


 if(keyword_set(nodata)) then return, 0

 return, image
end
;=============================================================================
