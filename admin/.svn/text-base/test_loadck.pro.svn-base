pro test_loadck
  for i = 0, 100 do begin
    file = '/home/joe//tmp/w1383255454.1'
    dd = nv_read(file, im, label, /silent)

; Two alternate ways of loading the C-kernel

;    cd = pg_get_cameras(dd, $
;       'ck_in=/usr/local/casper/casper_4.03/kernels/ck/axp/*.bc')
; With the *.bc line, program fails on the 29th call, with a SPICE IOSTAT error

     cd = pg_get_cameras(dd, $
       'ck_in=/home/joe//tmp/011030_011105ra.bc')
; With the explicitly-specified kernel, program fails on the 66th call, with a MINAS error

    pd = pg_get_planets(dd, ods=cd)
    print, i
  end
end

