;------------------------------------------------------------------------------
; NAME: IMAGEPDS
;
; PURPOSE: To read an image array into an array variable
;
; CALLING SEQUENCE: Result = IMAGEPDS (filename, label, [/SILENT])
;
; INPUTS:
;    Filename: Scalar string containing the name of the PDS file to read
;    Label: String array containing the image header information
; OUTPUTS:
;    Result: image array constructed from designated record
;
; OPTIONAL INPUT:
;    SILENT: suppresses any messages from the procedure
;
; EXAMPLES: 
;    To read an image file IMAGE.LBL into an array, img:
;       IDL> label = HEADPDS ("IMAGE.LBL",/SILENT)
;       IDL> img = IMAGEPDS ("IMAGE.LBL", label, /SILENT)
;    To read an image file IMAGEWIN.LBL with a window object into img:
;       IDL> label = HEADPDS ("IMAGEWIN.LBL",/SILENT)
;       IDL> img = IMAGEPDS ("IMAGEWIN.LBL",/SILENT)  
; 
; PROCEDURES USED:
;    Functions: OBJPDS, PDSPAR, POINTPDS, REMOVE, CLEAN 
;
; MODIFICATION HISTORY:
;    Adapted by John D. Koch from READFITS by Wayne Landsman, December,1994
;
;    Re-written by: Puneet Khetarpal [July 23, 2004]
;    For a complete list of modifications, see changelog.txt file.
;
;------------------------------------------------------------------------------

;- level 2 --------------------------------------------------------------------

;------------------------------------------------------------------------------
; precondition: the keywds structure has been initialized with flag set to 1, 
;     and start_ind, end_ind, req_keywds have not been changed.
; postcondition: returns the current image's x, y, bits, and sample_type
;     values as fields in the keywds structure.

function OBTAIN_IMAGE_CUR_REQ, keywds, start_ind, end_ind, req_keywds
    ; obtain element index for the current image:
    xpos = where (req_keywds.x.index GT start_ind AND req_keywds.x.index LT $
                  end_ind)
    ypos = where (req_keywds.y.index GT start_ind AND req_keywds.y.index LT $
                  end_ind)
    bpos = where (req_keywds.bits.index GT start_ind AND $
                  req_keywds.bits.index LT end_ind)
    spos = where (req_keywds.sampletype.index GT start_ind AND $
                  req_keywds.sampletype.index LT end_ind)

    ; specify X and Y dimensions, bits and sample_type:
    if (xpos[0] GT -1) AND (ypos[0] GT -1) AND $
       (bpos[0] GT -1) AND (spos[0] GT -1) then begin
        X = long(req_keywds.x.val[xpos[0]])
        Y = long(req_keywds.y.val[ypos[0]])
        if (X LT 0) then begin
            print, "Error: Invalid LINE_SAMPLES specification (" + $
                   CLEAN(string(X), /SPACE) + ")."
            GOTO, ENDFUN
        endif
        if (Y LT 0) then begin
            print, "Error: Invalid LINES specification (" + $
                    CLEAN(string(Y), /SPACE) + ")."
            GOTO, ENDFUN
        endif

        ; process SAMPLE_BITS and SAMPLE_TYPE:
        bits = long(req_keywds.bits.val[bpos[0]])
        bits = bits[0]
        sample_type = req_keywds.sampletype.val[spos[0]]
        sample_type = sample_type[0]
        param = ['"' , "'" , "(" , ")" , ","]
        sample_type = REMOVE(sample_type, param) ; external routine
    endif else begin
        X = -1
        Y = -1
        bits = -1
        sample_type = -1
    endelse

    ; add to structure:
    keywds = create_struct(keywds,"x",X,"y",Y,"bits",bits,"sample_type", $
                               sample_type)
    return, keywds
   
    ENDFUN:
        keywds.flag = -1
        return, keywds
end

;------------------------------------------------------------------------------
; precondition: keywds structure has flag field set to 1, and start_ind, 
;     end_ind, opt_keywds have not been changed.
; postcondition: returns the current image's optional keyword values, i.e.,
;     sample display direction, line display direction, offset, scaling factor,
;     line prefix bytes, and line suffix bytes.

function OBTAIN_IMAGE_CUR_OPT, keywds, start_ind, end_ind, opt_keywds
    ; get sdd element:
    if (opt_keywds.sddg.count EQ 0) then begin
        sdd = opt_keywds.sddg.val
    endif else begin
        sddpos = where (opt_keywds.sddg.index GT start_ind AND $
                        opt_keywds.sddg.index LT end_ind)
        sdd = opt_keywds.sddg.val[sddpos[0]]
    endelse

    ; get ldd element:
    if (opt_keywds.lddg.count EQ 0) then begin
        ldd = opt_keywds.lddg.val
    endif else begin
        lddpos = where (opt_keywds.lddg.index GT start_ind AND $
                        opt_keywds.lddg.index LT end_ind)
        ldd = opt_keywds.lddg.val[lddpos[0]]
    endelse

    ; process offset and offset flag if any:
    if (opt_keywds.offset.flag GT -1) then begin
        offpos = where (opt_keywds.offset.index GT start_ind AND $
                        opt_keywds.offset.index LT end_ind)
        if (offpos[0] GT -1) then begin
            off = long(opt_keywds.offset.val[offpos[0]])
        endif else begin
            off = long(0)
        endelse
    endif else off = long(0)

    ; process scaling factor and scaling factor flag if any:
    if (opt_keywds.sclfact.flag GT -1) then begin
        sclpos = where (opt_keywds.sclfact.index GT start_ind AND $
                        opt_keywds.sclfact.index LT end_ind)
        if (sclpos[0] GT -1) then begin
            scl = float(opt_keywds.sclfact.val[sclpos[0]])
        endif else begin
            scl = float(1)
        endelse
    endif else scl = float(1)

    ; process prefix bytes:
    if (opt_keywds.prefix.flag GT -1) then begin
        lppos = where(opt_keywds.prefix.index GT start_ind AND $
                      opt_keywds.prefix.index LT end_ind)
        if (lppos[0] GT -1) then begin
            prefix_byte = long(opt_keywds.prefix.val[lppos[0]])
            if (prefix_byte LT 0) then begin
                print, "Error: Invalid LINE_PREFIX_BYTES specification (" + $
                       CLEAN(string(prefix_byte), /SPACE) + ")."
                GOTO, ENDFUN
            endif
        endif else begin
            prefix_byte = long(0)
        endelse
    endif else prefix_byte = long(0)

    ; process suffix bytes:
    if (opt_keywds.suffix.flag GT -1) then begin
        lspos = where(opt_keywds.suffix.index GT start_ind AND $
                      opt_keywds.suffix.index LT end_ind)
        if (lspos[0] GT -1) then begin
            suffix_byte = long(opt_keywds.suffix.val[lspos[0]])
            if (suffix_byte LT 0) then begin
                print, "Error: Invalid LINE_SUFFIX_BYTES specification (" + $
                       CLEAN(string(suffix_byte), /SPACE) + ")."
                GOTO, ENDFUN 
            endif
        endif else begin
            suffix_byte = long(0)
        endelse
    endif else suffix_byte = long(0)

    ; add values to structure:
    keywds = create_struct(keywds,"sdd",sdd,"ldd",ldd,"offset",off,"scl",scl, $
                           "prefix",prefix_byte,"suffix",suffix_byte)

    return, keywds

    ENDFUN:
        keywds.flag = -1
        return, keywds
end

;------------------------------------------------------------------------------
; precondition: the architecture conversion, scaling, and offset has been
;     performed on element, and current contains the current image object
;     attributes.
; postcondition: the element array is transformed according to the line and
;     sample display direction keyword values and returned to main block.

function PROCESS_DISPLAY_DIRECTION, element, current
    ; local variables:
    ldd = current.ldd
    sdd = current.sdd

    ; process display direction:
    param = ['"',',',')','('] 
    sdd = REMOVE(sdd, param) 
    ldd = REMOVE(ldd, param)
    CASE sdd OF
       "RIGHT": begin
                    if (ldd EQ "UP") then $
                        element = rotate(element, 0) $
                    else if (ldd EQ "DOWN") then $
                        element = rotate(element, 7) $
                    else GOTO, LDDEND
                end
        "LEFT": begin
                    if (ldd EQ "UP") then $
                        element = rotate(element, 5) $
                    else if (ldd EQ "DOWN") then $
                        element = rotate(element, 2) $
                    else GOTO, LDDEND
                end
          "UP": begin
                    if (ldd EQ "LEFT") then $
                        element = rotate(element, 3) $
                    else if (ldd EQ "RIGHT") then $
                        element = rotate(element, 4) $
                    else GOTO, LDDEND  
                end
        "DOWN": begin
                    if (ldd EQ "LEFT") then $
                        element = rotate(element, 6) $
                    else if (ldd EQ "RIGHT") then $
                        element = rotate(element, 1) $
                    else GOTO, LDDEND
                end
          else: begin
                    print, "Error: invalid SAMPLE_DISPLAY_DIRECTION"+$
                           " value specified - " + sdd
                    return, -1
                end
    ENDCASE        

    return, element

    LDDEND:
        print, "Error: invalid LINE_DISPLAY_DIRECTION value specified - "+ldd
        return, -1
end

;- level 1 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: label is a viable PDS label, and wflag is an int variable
;     of value either -1 or 1 indicating the non-existence of a window object
;     or the existence of one, respectively.
; postcondition: returns a structure containing all IMAGE object required
;     keyword values, count, and index in the label. It extracts LINES, 
;     LINE_SAMPLES, SAMPLE_BITS, and SAMPLE_TYPE. The structure consists of
;     key_flag that is set to -1 in case of any error in label, else is 1.

function OBTAIN_IMAGE_REQ_KEYWORDS, label, wflag
    ; initialize keyword structure:
    keywds = create_struct("flag", 1)

    ; obtain LINE_SMAPLES and LINES:
    Xvar = PDSPAR (label, "LINE_SAMPLES", COUNT=xcount, INDEX=xind)
    Yvar = PDSPAR (label, "LINES", COUNT=ycount, INDEX=yind)

    ; ensure that number of LINE_SAMPLES keyword values equal number of
    ; LINES keyword values:
    if (xcount NE ycount) then begin
        print, "ERROR: LINE_SAMPLES and LINES count discrepancy."
        GOTO, ENDFUN
    endif

    ; create individual structures and store into keywds structure:
    xglob = create_struct("val",Xvar,"count",xcount,"index",xind)
    yglob = create_struct("val",Yvar,"count",ycount,"index",yind)
    keywds = create_struct(keywds,"x",xglob,"y",yglob)

    ; obtain SAMPLE_BITS:
    samplebits = PDSPAR (label, "SAMPLE_BITS", COUNT=bitcount,INDEX=bitind)

    ; check if number of SAMPLE_BITS keywords equal number of LINE_SAMPLES:
    if (bitcount NE xcount) AND (wflag EQ -1) then begin
        print, "Error: LINES_SAMPLES and SAMPLE_BITS count discrepancy."
        GOTO, ENDFUN
    endif

    ; create sample bits structure and add to keywds structure:
    smpbits = create_struct("val",samplebits, "count",bitcount,"index",bitind)
    keywds = create_struct(keywds,"bits",smpbits)

    ; obtain SAMPLE_TYPE:
    sampletype = PDSPAR (label,"SAMPLE_TYPE",COUNT=sampcount,INDEX=sampind)

    ; check whether there exists SAMPLE_TYPE keyword:
    if (!ERR EQ -1) then begin
        print, "ERROR: missing required SAMPLE_TYPE keyword."
        GOTO, ENDFUN
    endif

    ; create sample type structure and add to keywds structure:
    smptype = create_struct("val",sampletype,"count",sampcount,"index",sampind)
    keywds = create_struct(keywds,"sampletype",smptype)

    return, keywds

    ENDFUN:
        keywds.flag = -1
        return, keywds
end

;------------------------------------------------------------------------------
; precondition: label is a viable PDS label.
; postcondition: returns a structure containing IMAGE object optional keywords
;     along with a flag for each keyword indicating its presence or absence by
;     value of 1 or -1, respectively.

function OBTAIN_IMAGE_OPT_KEYWORDS, label
    ; obtain SAMPLE_DISPLAY_DIRECTION:
    sddg = PDSPAR(label,"SAMPLE_DISPLAY_DIRECTION",COUNT=sddcount,INDEX=sddind)

    ; if sample display direction is not specified, then use default:
    if (!ERR EQ -1) then begin
        print, "NOTE: SAMPLE_DISPLAY_DIRECTION keyword not found..."
        print, "  ...assuming default value of RIGHT"
        sddg = "RIGHT"
    endif
    sddgst = create_struct("val",sddg,"count",sddcount,"index",sddind)
   
    ; obtain LINE_DISPLAY_DIRECTION:
    lddg = PDSPAR(label,"LINE_DISPLAY_DIRECTION",COUNT=lddcount,INDEX=lddind)

    ; if line display direction is not specified, then use default:
    if (!ERR EQ -1) then begin
        print, "NOTE: LINE_DISPLAY_DIRECTION keyword not found..."
        print, "  ...assuming default value of DOWN"
        lddg = "DOWN"
    endif
    lddgst = create_struct("val",lddg,"count",lddcount,"index",lddind)

    ; obtain OFFSET and SCALING_FACTOR optinal keywords:
    offset = PDSPAR (label,"OFFSET",COUNT=offcount,INDEX=offind)
    if (!ERR EQ -1) then begin
        offflag = -1
        !ERR = 0
    endif else offflag = 0
    offsetst = create_struct ("val",offset,"count",offcount,"index",offind, $
                              "flag",offflag)
    sclfact = PDSPAR (label,"SCALING_FACTOR",COUNT=sclcount,INDEX=sclind)
    if (!ERR EQ -1) then begin
        sclflag = -1
        !ERR = 0
    endif else sclflag = 0
    sclfactst = create_struct ("val",sclfact,"count",sclcount,"index",sclind, $
                               "flag",sclflag)

    ; obtain LINE_PREFIX/SUFFIX_BYTES:
    lnprefix = long(PDSPAR(label,"LINE_PREFIX_BYTES",COUNT=lpcount, $
                           INDEX=lpind))
    if (!ERR EQ -1) then pflag = -1 else pflag = 0
    lnsuffix = long(PDSPAR(label,"LINE_SUFFIX_BYTES",COUNT=lscount, $
                           INDEX=lsind))
    if (!ERR EQ -1) then sflag = -1 else sflag = 0
    prefix = create_struct("val",lnprefix,"count",lpcount,"index",lpind, $
                           "flag",pflag)
    suffix = create_struct("val",lnsuffix,"count",lscount,"index",lsind, $
                           "flag",sflag)

    ; add all created structures to the keywds structure:
    keywds = create_struct("sddg",sddgst,"lddg",lddgst,"offset",offsetst, $
                           "sclfact",sclfactst,"prefix",prefix,"suffix",suffix)
   
    return, keywds
end

;------------------------------------------------------------------------------
; precondition: start_ind and end_ind are viable object start and end index
;     in the label. The req_keywds, and opt_keywds have been populated properly
; postcondition: returns a structure containing the viable keyword values for
;     current image object defined by start_ind and end_ind pointer.

function OBTAIN_IMAGE_CUR_PARAMS, start_ind, end_ind, req_keywds, opt_keywds
    ; intialize structure:
    keywds = create_struct ("flag", 1)

    ; obtain current image x, y, bits, and sample_type:
    keywds = OBTAIN_IMAGE_CUR_REQ (keywds, start_ind, end_ind, req_keywds)
    if (keywds.flag EQ -1) then begin
        return, keywds
    endif

    ; obtain current image sdd, ldd, offset, scaling factor, and prefix/suffix:
    keywds = OBTAIN_IMAGE_CUR_OPT (keywds, start_ind, end_ind, opt_keywds)
    if (keywds.flag EQ -1) then begin
        return, keywds
    endif

    return, keywds
end

;------------------------------------------------------------------------------
; precondition: sample_type is extracted for the current image object
; postcondition: a structure containing the sample_type and the integer_type
;     of the object is returned.

function PROCESS_IMAGE_TYPES, sample_type
    ; save sample_type:
    save = sample_type

    ; check sample type for MSB, LSB, IEEE, or VAX:
    if (!VERSION.RELEASE GT 5.2) then begin
        samples = strsplit(sample_type, "_", /EXTRACT)
    endif else begin
        samples = str_sep(sample_type, "_")        ; obsolete in IDL ver. > 5.2
    endelse
    n_samples = n_elements(samples)
    j = long(0)
    flag = 1
    while (j LT n_samples AND flag NE -1) do begin
        if (samples[j] EQ "MSB") OR (samples[j] EQ "INTEGER") OR $
           (samples[j] EQ "UNSIGNED") then begin
            sample_type = "MSB"
            flag = -1
        endif else if (samples[j] EQ "LSB") then begin
            sample_type = "LSB"
            flag = -1
        endif else if (samples[j] EQ "VAX") then begin
            sample_type = "VAX"
            flag = -1
        endif else if (samples[j] EQ "IEEE") OR $
            (samples[j] EQ "REAL") then begin
            sample_type = "IEEE"
            flag = -1
        endif
        j = j + 1
    endwhile

    ; check for integer type either SIGNED or UNSIGNED:
    integer_type = save
    rightpos = strpos(strupcase (integer_type), "UNSIGNED")
    if (rightpos GT -1) then begin
        integer_type = "UNSIGNED"
    endif else begin
        integer_type = "SIGNED"
    endelse

    ; create the types structure containing the respective keywords:
    types = create_struct("sample_type", sample_type,"integer_type",$
                          integer_type)

    return, types
end

;------------------------------------------------------------------------------
; precondition: current is a viable structure containing the current image 
;     object attributes, and types is a viable structure containing the 
;     current image object sample type and integer type.
; postcondition: a data structure consisting of a x by y array of type as
;     specified by sample bits.

;function INITIALIZE_IMAGE_ARRAY, current, types
function INITIALIZE_IMAGE_ARRAY, current, types, x, y, nodata=nodata 	; Spitale 3/10/2009
    ; intitialize struct:
    data_set = create_struct ("flag", 1)

    ; local variables:
    X = current.X
    Y = current.Y

    if(keyword_set(nodata)) then return, data_set 			; Spitale 3/10/2009

    ; initialize image array for respective SAMPLE_BITS:
    CASE current.bits OF
        8: begin
               IDL_TYPE = 1
               element = bytarr (X,Y,/NOZERO)
               tempimg = bytarr (X,/NOZERO)
           end
       16: begin
               IDL_TYPE = 2
               element = intarr (X,Y,/NOZERO)
               tempimg = intarr (X, /NOZERO)
           end
       32: begin
               if (types.sample_type EQ 'MSB') OR $
                  (types.sample_type EQ 'LSB') then begin
                   IDL_TYPE = 3
                   element = fltarr (X,Y,/NOZERO)
                   tempimg = fltarr (X,/NOZERO)
               endif else begin
                   IDL_TYPE = 4
                   element = lonarr (X,Y,/NOZERO)
                   tempimg = lonarr (X,/NOZERO)
               endelse
           end
       64: begin
               IDL_TYPE = 5
               element = dblarr (X,Y,/NOZERO)
               tempimg = dblarr (X,/NOZERO)
           end     
     else: begin
               print, "ERROR: Illegal value of SAMPLE_BITS - " + $
                      CLEAN(string(current.bits), /SPACE)
               GOTO, ENDFUN
           end
    ENDCASE

    ; generate structure to be read from file:
    ; if there are prefix bytes, then create a bytarr in structure and add
    ; temporary image element, else just add temp image element:
    if (current.prefix GT 0) then begin
        data_structure = {image, front:bytarr(current.prefix)}
        data_structure = create_struct(data_structure, "imagedata",tempimg)
    endif else begin
        data_structure = create_struct("imagedata",tempimg)
    endelse

    ; if there are suffix bytes, then append a bytarr to structure:
    if (current.suffix GT 0) then begin
        data_structure = create_struct(data_structure,"back",$
                                       bytarr(current.suffix))
    endif

    ; replicate the data structure Y times so we have X by Y array struct:    
    data_read = replicate (data_structure, Y)
    data_set = create_struct(data_set,"element",element,"data_read",data_read)

    return, data_set

    ENDFUN:
        data_set.flag = -1
        return, data_set
end

;------------------------------------------------------------------------------
; precondition: data_set contains the data_read field that contains data
;     from file, and element field that contains a blank array of dim X, Y.
;     Types is a structure containing viable sample type and integer type
;     values for current image object. Also, current structure contains the
;     attributes of current image object.
; postcondition: returns the element array after performing necessary
;     conversions, i.e., architecture, scaling, and offset

function CONVERT_IMAGE, data_set, types, current
    ; local variables:
    data_read = data_set.data_read
    element = data_set.element
    bits = current.bits
    integer_type = types.integer_type

    ; extract image from the read data:
    for d = 0, current.Y - 1 do begin
       element[*,d] = data_read[d].imagedata[*]
    endfor

    ; conversion to UNIX readable type:
    CASE types.sample_type OF
        "MSB": ; no conversion needed
       "IEEE": ; no conversion needed
        "VAX": element = conv_vax_unix (element)
        "LSB": element = conv_vax_unix (element)
         else: begin
                   print, "WARNING: unrecognizable SAMPLE_TYPE - " + $
                      current.sample_type+" no conversion performed."
               end
    ENDCASE

    ; convert data if unsupported by IDL:
    if (bits EQ 8 AND integer_type EQ "SIGNED") then begin
        element = fix(element)
        fixitlist = where (element GT 127)
        if (fixitlist[0] GT -1) then begin
            element [fixitlist] = element[fixitlist] - 256
        endif
    endif else if (bits EQ 16 AND integer_type EQ "UNSIGNED") then begin
        element = long(element)
        fixitlist = where (element LT 0)
        if (fixitlist[0] GT -1) then begin
            element[fixitlist] = element[fixitlist] + 65536
        endif
    endif else if (bits EQ 32 AND integer_type EQ "UNSIGNED") then begin
        element = double(element)
        fixitlist = where (element LT 0.D0)
        if (fixitlist[0] GT -1) then begin
            element[fixitlist] = element[fixitlist] + 4.294967296D+9
        endif
    endif

    ; process scaling factor and offset:
    element = element * current.scl
    element = element + current.offset

    return, element
end

;------------------------------------------------------------------------------
; precondition: element contains the complete current image array info, 
;     wobjects contains all info about window objects, req_keywds contains
;     required keyword attributes for file, and end_ind is a valid end index
;     for current image object.
; postcondition: extracts any window objects from the image array and places
;     them in a structure.

function PROCESS_WINDOW_IMAGE, element, wobjects, req_keywds, silent, $
                               start_ind, end_ind, label, current
    ; local variables:
    xind = req_keywds.x.index
    yind = req_keywds.y.index
    wdata_set = create_struct("flag", 1)

    ; process window object if exists:
    if (wobjects.flag GT -1) then begin
        ; extract window object info:
        if (silent EQ 0) then print, "Processing window object"
        windex = wobjects.index
        warray = wobjects.array
        wcount = wobjects.count
     
        ; check where windex is between start index and end index for
        ; current image object:
        wpos = where (windex GT start_ind AND windex LT end_ind, wcount)
        if (wcount GT 0) then begin
            windex = windex[wpos]
            warray = warray[wpos]
        endif else begin
            GOTO, ENDFUN
        endelse

        ; create a struct of windows if more than 1:
        if (wcount GT 1) then wdata = create_struct("windows",wcount)

        ; extract window data from image array:
        for w = 0, wcount - 1 do begin
            ; set current and next window object pointer:
            cur_win = windex[w]
            if (w LT wcount - 1) then begin
                next_win = windex[w + 1]
            endif else begin
                next_win = end_ind
            endelse

            ; obtain FIRST_LINE/LINE_SAMPLE for current window object:
            xwpos = where(xind GT cur_win AND xind LT next_win)
            ywpos = where(yind GT cur_win AND yind LT next_win)
            ybegin = PDSPAR (label, "FIRST_LINE")
            xbegin = PDSPAR (label, "FIRST_LINE_SAMPLE")
            if (ybegin[w] LE 0 OR ybegin[w] GT current.Y) then begin
                print, "Error: Window FIRST_LINE byte exceeds image " + $
                       "array (" + CLEAN(string(ybegin[w]),/SPACE) + ")."
                GOTO, ENDFUN
            endif
            if (xbegin[w] LE 0 OR xbegin[w] GT current.X) then begin
                print, "Error: Window FIRST_LINE_SAMPLE byte exceeds image "+ $
                       "array (" + CLEAN(string(xbegin[w]),/SPACE) + ")."
                GOTO, ENDFUN
            endif

            ; obtain lines and line samples for current window: 
            win_X = long(req_keywds.x.val[xwpos[0]])
            win_Y = long(req_keywds.y.val[ywpos[0]])
   
            ; check to ensure win_X and win_Y are viable:
            if (win_X LE 0) then begin
                print, "Error: Invalid window LINE_SAMPLES specification (" + $
                       CLEAN(string(win_X), /SPACE) + ")."
                GOTO, ENDFUN
            endif
            if (win_Y LE 0) then begin
                print, "Error: Invalid window LINES specification (" + $
                       CLEAN(string(win_X), /SPACE) + ")."
                GOTO, ENDFUN
            endif

            ; declare window object type:
            CASE current.bits OF
               8: temp = bytarr (win_X, win_Y, /NOZERO)
              16: temp = intarr (win_X, win_Y, /NOZERO)
              32: temp = fltarr (win_X, win_Y, /NOZERO)
              64: temp = dblarr (win_X, win_Y, /NOZERO)
            ENDCASE

            ; extract window:
            for wx = 0, win_X - 1 do begin
                for wy = 0, win_Y - 1 do begin
                    temp [wx, wy] = element[wx+xbegin[w]-1, wy+ybegin[w]-1]
                endfor
            endfor

            if (win_X EQ 1 AND win_Y EQ 1) then begin
                temp[0,0] = element[xbegin[w] - 1, ybegin[w] - 1]
            endif else if (win_X EQ 1 AND win_Y GT 1) then begin
                for wy = 0, win_Y - 1 do begin
                    temp[0,wy] = element[xbegin[w] - 1, wy + ybegin[w] - 1]
                endfor
            endif else if (win_X GT 1 AND win_Y EQ 1) then begin
                for wx = 0, win_X - 1 do begin
                    temp[wx,0] = element[wx+xbegin[w]-1,ybegin[w]-1]
                endfor
            endif
               
            elementw = PROCESS_DISPLAY_DIRECTION(temp, current)

            ; extract window array to window struct:            
            if (wcount GT 1) then begin
                wname = warray[w] + strtrim(string(w + 1),2)
                wdata = CREATE_STRUCT(wdata, wname, elementw)
            endif else wdata = CREATE_STRUCT("window", elementw)
        endfor

        ; process LINE/SAMPLE_DISPLAY_DIRECTION:
        element = PROCESS_DISPLAY_DIRECTION(element, current)

        wdata = create_struct(wdata, "image", element)
        wdata_set = create_struct(wdata_set, "wdata", wdata)
    endif else GOTO, ENDFUN

    return, wdata_set

    ENDFUN:
        wdata_set.flag = -1
        return, wdata_set
end

;- level 0 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: fname is a valid name of label file, and label is a valid
;     PDS label for fname.
; postcondition: returns a structure containing all image data corresponding
;     to the image objects.
 
;function IMAGEPDS, fname, label, SILENT=silent
function IMAGEPDS, fname, label, SILENT=silent, xsize, ysize, nodata=nodata
									; Spitale 3/10/2009
    ; error protection:
    ;ON_ERROR, 2
    On_ioerror, SIGNAL

    ; check for number of parameters in function call:
    if (n_params() LT 2) then begin
        print, "Syntax: result = IMAGEPDS (filename [,/SILENT])"
        return, -1
    endif
    if keyword_set(SILENT) then silent = 1 else silent = 0

    ; obtain image and window objects from label:
    objects = OBJPDS (label, "IMAGE")      ; external routine
    if (objects.flag EQ -1) then begin
        print, "ERROR: no IMAGE object found in label"
        return, -1
    endif
    wobjects = OBJPDS (label, "WINDOW")    ; external routine

    ; obtain required keyword parameters from label:
    req_keywds = OBTAIN_IMAGE_REQ_KEYWORDS (label, wobjects.flag)
    if (req_keywds.flag EQ -1) then begin
        return, -1
    endif

    ; obtain optional keyword parameters from label:
    opt_keywds = OBTAIN_IMAGE_OPT_KEYWORDS (label)

    ; initialize the image structure if more than one image:
    if (objects.count GT 1) then data = create_struct("images",objects.count)

    ; process each image object:
    ; start for loop:

    for i = 0, objects.count - 1 do begin
        ; specify pointers to current and next image object:
        start_ind = objects.index[i]
        end_ind = GET_INDEX(label, start_ind) ; external routine
        if (end_ind EQ -1) then begin
            return, -1
        endif

        ; obtain keyword values for current image object:
        current = OBTAIN_IMAGE_CUR_PARAMS (start_ind, end_ind, req_keywds, $
                                           opt_keywds)
        if (current.flag EQ -1) then begin
            return, -1
        endif

        ; check whether to proceed:
        if (current.X LE 0) OR (current.Y LE 0) then begin
            print, "Error: " + fname + " has X or Y = 0, no data array read."
            return, -1
        endif

        ; if ready to proceed then print dimensions of array if not silent:
        if (silent EQ 0) then begin
            text = CLEAN(string(current.X),/SPACE)+ " by " + $
                      CLEAN(string(current.Y),/SPACE)   ; external routine
            print, "Now reading " + text + " array"
        endif

        ; process sample_type and integer type:
        types = PROCESS_IMAGE_TYPES(current.sample_type)

        ; obtain pointer information:
        pointer = POINTPDS (label, fname, objects.array[i]) ; external routine
        if (pointer.flag EQ -1) then begin
            return, -1
        endif

        ; initialize image array:
;        data_set = INITIALIZE_IMAGE_ARRAY(current, types)
        data_set = INITIALIZE_IMAGE_ARRAY(current, types, xsize, ysize, nodata=nodata)
									; Spitale 3/10/2009
        if (data_set.flag EQ -1) then begin
            return, -1
        endif

        if(NOT keyword_set(nodata)) then $			; Spitale 3/10/2009
         begin

          ; start reading the image data:
          data_read = data_set.data_read
          openr, unit, pointer.datafile, /GET_LUN
          point_lun, unit, pointer.skip
          readu, unit, data_read
          close, unit
          free_lun, unit
          data_set.data_read = data_read

          ; extract image and modify as required:
          element = CONVERT_IMAGE (data_set, types, current)

          ; process window object if exists:
          wdata_set = PROCESS_WINDOW_IMAGE (element, wobjects, req_keywds, $
                         silent, start_ind, end_ind, label, current)

          if (wdata_set.flag EQ -1) then begin
            ; process LINE/SAMPLE_DISPLAY_DIRECTION:
            element = PROCESS_DISPLAY_DIRECTION(element, current)
          endif

          ; save image:
          if (objects.count GT 1) then begin
              if (wdata_set.flag GT -1) then begin
                  data = create_struct(data, objects.array[i], wdata_set.wdata)
              endif else $
                  data = create_struct(data, objects.array[i], element)
          endif else if (wdata_set.flag GT -1) then begin
              data = wdata_set.wdata
          endif else data = element
         end							; Spitale 3/10/2009
    endfor 
    ; end of for loop

    if (i NE objects.count) then begin
        print, "ERROR: Number of images expected does not equal number found."
        return, -1
    endif

    if(keyword_set(nodata)) then return, 0		; Spitale 3/10/2009
    return, data

    SIGNAL:
       On_ioerror, NULL
       print, "Error reading file"
       return, -1
end
