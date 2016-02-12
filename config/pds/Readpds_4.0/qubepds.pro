;-----------------------------------------------------------------------------
; NAME: QUBEPDS
; 
; PURPOSE: To read a 3-D image QUBE object into a 3-D IDL array.
;
; CALLING SEQUENCE:
;     Result = QUBEPDS (fname, label [, /SILENT])
;
; INPUTS:
;     fname: the name of the file to be read in.
;     label: the PDS label string array containing qube object definitions
; OPTIONAL INPUT:
;     SILENT: to indicate whether to inform the user of program status.
; OUTPUT:
;     Result: an IDL structure containing the qube array(s).
;
; MODIFICATION HISTORY:
;     Written by: Puneet Khetarpal [August 2002]
;     For a complete list of modifications, see changelog.txt file.
;
;-----------------------------------------------------------------------------

;- level 3 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: value is a scalar string of format (str1, str2, str3)
; postcondition: the value is returned as an array of values extracted from
;     the scalar string.

function OBTAIN_QUBE_ITEMS, val
    ; initialize value structure:
    struct = create_struct("flag", 1)

    ; first clean the string:
    val = CLEAN(val, /SPACE)                           ; external routine

    ; check whether the first and last chars of string are '(' and ')':
    rightp = strpos(val, '(')
    leftp = strpos(val, ')')
    if (rightp[0] EQ -1 OR leftp[0] EQ -1) then begin
        print, "Error: "+val+" missing right and left parentheses in label."
        GOTO, ENDFUN
    endif else if (rightp[0] NE 0 OR leftp[0] NE strlen(val)-1) then begin
        print, "Error: "+val+" poorly formatted keyword value."
        GOTO, ENDFUN 
    endif

    ; remove the parantheses:
    param = ['(',')']
    val = REMOVE (val, param)                         ; external routine

    ; separate the string using "," as delimiter:
    if (!VERSION.RELEASE GT 5.2) then begin
        items = strsplit(val, ",", /EXTRACT)
    endif else begin
        items = str_sep(val, ",")                 ; obsolete in IDL v. > 5.2
    endelse
    if (n_elements(items) EQ 1) then begin
        print, "Error: "+ val +" poorly formatted keyword value."
        GOTO, ENDFUN
    endif else begin
        struct = create_struct(struct, "items", items)
    endelse

    return, struct

    ENDFUN:
        struct.flag = -1
        return, struct
end


;- level 2 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: label is a viable PDS label string array, and name is valid
;     required keyword name.
; postcondition: extracts the "name" keyword from the label, its values, 
;     the number of times it occurs in the label, and the indices in the label
;     string array.

function OBTAIN_QUBE_KEYWORD, label, name
    ; initialize keyword structure:
    keywd = create_struct("flag", 1)

    ; obtain keyword:
    val = PDSPAR (label, name, COUNT = count, INDEX = index)
    if (!ERR EQ -1) then begin
        print, "Error: missing required " + name + " keyword from label."
        GOTO, ENDFUN
    endif
    keywd = create_struct(keywd, "val", val, "count", count, "index", index)

    return, keywd

    ENDFUN:
        keywd.flag = -1
        return, keywd
end

;-----------------------------------------------------------------------------
; precondition: x, y, z are integers greater than 0, bits is computed as
;     core_item_bytes * 8, and current contains the current qube's structure,
;     and types contains the architecture, and integer type of core data.
; postcondition: generates the 3-D array of type specified by bits, and
;     returned to the main block in a structure.

function CREATE_QUBE_ARRAY, x, y, z, bits, current, types
    ; initialize structure:
    struct = create_struct("flag", 1)

    ; create a temporary arrays to be read:
    CASE bits OF
        8: begin
               element = bytarr (x, y, z, /NOZERO)
               tempimg = bytarr (x, /NOZERO)
           end
       16: begin
               element = intarr (x, y, z, /NOZERO)
               tempimg = intarr (x, /NOZERO)
           end
       32: begin
               if (types.arch EQ "MSB") then begin
                   element = fltarr (x, y, z, /NOZERO)
                   tempimg = fltarr (x, /NOZERO)
               endif else begin
                   element = lonarr (x, y, z, /NOZERO)
                   tempimg = lonarr (x, /NOZERO)
               endelse 
           end
       64: begin
               element = dblarr (x, y, z, /NOZERO)
               tempimg = dblarr (x, /NOZERO)
           end
     else: begin
               print, "Error: Illegal value of CORE_ITEM_BYTES - " + $
                      CLEAN(string(current.core_item_bytes), /SPACE)
               GOTO, ENDFUN
           end
    ENDCASE

    struct = create_struct(struct, "element", element, "tempimg", tempimg)

    return, struct

    ENDFUN:
        struct.flag = -1
        return, struct
end

;------------------------------------------------------------------------------
; precondition: current contains current object's attributes, and data_temp
;     is a structure that contains the field "imagedata" with tempimg array.
; postcondition: the suffix bytes for LINES are processed and compiled into
;     data_temp and returned to the main block.

function CREATE_QUBE_YSUF, current, data_temp
    ; initialize structure:
    struct = create_struct("flag", 1)

    ; create temporary suffix arrays:
    if (current.suffix_items[1] GT 0) then begin
        CASE (current.suffix_bytes * 8) OF
            8: ysuf = bytarr(current.suffix_items[0], /NOZERO)
           16: ysuf = intarr(current.suffix_items[0], /NOZERO)
           32: ysuf = fltarr(current.suffix_items[0], /NOZERO)
           64: ysuf = dblarr(current.suffix_items[0], /NOZERO)
         else: begin
                   print, "Error: Illegal value of SUFFIX_BYTES - " + $
                          CLEAN(string(current.suffix_bytes), /SPACE)
                   GOTO, ENDFUN
               end
        ENDCASE
        data_temp = create_struct(data_temp, "sideplane", ysuf)
    endif

    struct = create_struct(struct, "data_temp", data_temp)

    return, struct

    ENDFUN:
        struct.flag = -1
        return, struct
end

;-----------------------------------------------------------------------------
; precondition: current contains current object's attributes, and data_y
;     is a structure containing fields of tempimg and y suffix items replicated
;     y times.
; postcondition: the suffix bytes for the SAMPLES is processed and compiled
;     into data_y and returned to main block.

function CREATE_QUBE_XSUF, current, data_y
    ; initialize structure:
    struct = create_struct("flag", 1)

    ; look for x suffix items:
    if (current.suffix_items[0] GT 0) then begin
        CASE (current.suffix_bytes * 8) OF
            8: xsuf = bytarr(current.suffix_items[0], /NOZERO)
           16: xsuf = intarr(current.suffix_items[0], /NOZERO)
           32: xsuf = fltarr(current.suffix_items[0], /NOZERO)
           64: xsuf = dblarr(current.suffix_items[0], /NOZERO)
         else: begin
                   print, "Error: Illegal value of SUFFIX_BYTES - " + $
                          CLEAN(string(current.suffix_bytes), /SPACE)
                   GOTO, ENDFUN
               end
        ENDCASE
        data_y = create_struct("data_y", data_y, "bottomplane", xsuf)
    endif else begin
        data_y = create_struct("data_y", data_y)
    endelse

    struct = create_struct(struct, "data_y", data_y)

    return, struct

    ENDFUN:
        struct.flag = -1
        return, struct
end

;-----------------------------------------------------------------------------
; precondition: element is a n-dimensional array containing the core data,
;     bits is the integer specifying the sample bits for core data, and 
;     types is an idl structure containing architecture and integer type for
;     core data.
; postcondition: the elements of element are converted to appropriate values
;     if the data is unsupported by IDL.

function FIXIT_QUBE, element, bits, types
    ; first check for 8 bits and signed values:
    if ((bits EQ 8) AND (types.integer_type EQ "SIGNED")) then begin
        element = fix(element)
        fixitlist = where (element GT 127)
        if (fixitlist[0] GT -1) then begin
            element[fixitlist] = element[fixitlist] - 256
        endif
    endif else if ((bits EQ 16) AND (types.integer_type EQ "UNSIGNED")) $
        then begin
        element = long(element)
        fixitlist = where (element LT 0)
        if (fixitlist[0] GT -1) then begin
            element[fixitlist] = element[fixitlist] + 65536
        endif
    endif else if ((bits EQ 32) AND (types.integer_type EQ "UNSIGNED")) $
        then begin
        element = double(element)
        fixitlist = where (element LT 0.D0)
        if (fixitlist[0] GT -1) then begin
            element[fixitlist] = element[fixitlist] + 4.294967296D+9
        endif
    endif

    return, element
end

;- level 1 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: label is a viable PDS label string array.
; postcondition: extracts the required QUBE keywords from the label and 
;     returns to the main block.

function OBTAIN_QUBE_REQ, label
    ; initialize keywords structure:
    keywds = create_struct("flag", 1)

    keywords = ["AXES", "AXIS_NAME", "CORE_ITEMS", "CORE_ITEM_BYTES", $
                "CORE_ITEM_TYPE", "SUFFIX_BYTES", "SUFFIX_ITEMS", "CORE_BASE",$
                "CORE_MULTIPLIER"]

    for i = 0, n_elements(keywords) - 1 do begin
        keyword_struct = OBTAIN_QUBE_KEYWORD (label, keywords[i])
        if (keyword_struct.flag EQ -1) then begin
            GOTO, ENDFUN
        endif
        keywds = create_struct (keywds, keywords[i], keyword_struct)
    endfor

    return, keywds

    ENDFUN:
        keywds.flag = -1
        return, keywds
end

;-----------------------------------------------------------------------------
; precondition: req_keywds contains all the information for the required
;     keywords for current qube object, start and end index specify the
;     start and end indices for the current qube object.
; postcondition: determines the current object's required keyword values and
;     returns to main block.

function OBTAIN_QUBE_CUR, keywds, start_ind, end_ind
    ; initialize structure:
    current = create_struct("flag", 1)
    names = tag_names (keywds)

    ; extract current params:
    for i = 1, n_tags(keywds) - 1 do begin
        ; find the index where current keyword is between start and end index:
        pos = where (keywds.(i).index GT start_ind AND $ 
                     keywds.(i).index LT end_ind)
        if (pos[0] EQ -1) then begin
            print, "Error: missing required "+ names[i] +" keyword from label."
            GOTO, ENDFUN
        endif

        ; extract the value at current position:
        val = keywds.(i).val[pos[0]]

        ; process the necessary keywords:
        CASE names[i] OF
            "AXES": val = long(val)
       "AXIS_NAME": begin
                        temp = OBTAIN_QUBE_ITEMS(val)
                        if (temp.flag EQ -1) then begin
                            GOTO, ENDFUN
                        endif else val = temp.items
                    end                        
      "CORE_ITEMS": begin
                        temp = OBTAIN_QUBE_ITEMS(val)
                        if (temp.flag EQ -1) then begin
                            GOTO, ENDFUN
                        endif else val = long(temp.items)
                    end
 "CORE_ITEM_BYTES": val = long(val)
  "CORE_ITEM_TYPE": ; val = OBTAIN_QUBE_ITEMS(val)
    "SUFFIX_BYTES": val = long(val)
    "SUFFIX_ITEMS": begin
                        temp = OBTAIN_QUBE_ITEMS(val)
                        if (temp.flag EQ -1) then begin
                            GOTO, ENDFUN
                        endif else val = long(temp.items)
                    end
       "CORE_BASE": val = float(val)
 "CORE_MULTIPLIER": val = float(val)
        ENDCASE

        current = create_struct(current, names[i], val)
    endfor

    return, current

    ENDFUN:
        current.flag = -1
        return, current
end

;-----------------------------------------------------------------------------
; precondition: current is an IDL structure containing current qube object's
;     required keyword information. Particularly, the axis_name, suffix_items
;     and core_items keyword values have been stored into fields of array
; postcondition: the axis_names are searched through and matched for x, y, or 
;     z value for the qube data, and suffix and core items are assigned 
;     appropriately.

function PROCESS_QUBE_XYZ, current
    ; initialize structure:
    core_items = create_struct("x", 0, "y", 0, "z", 0)
    suffix_items = create_struct("x", 0, "y", 0, "z", 0)

    ; go through each axis name value and assign respective values to
    ; core_items and suffix_items structure:
    for i = 0, n_elements(current.axis_name) - 1 do begin
        CASE current.axis_name[i] OF
            "SAMPLE": begin
                          core_items.x = current.core_items[i]
                          suffix_items.x = current.suffix_items[i]
                      end
              "LINE": begin
                          core_items.y = current.core_items[i]
                          suffix_items.y = current.suffix_items[i]
                      end
              "BAND": begin
                          core_items.z = current.core_items[i]
                          suffix_items.z = current.suffix_items[i]
                      end
                else: begin
                          print, "Error: invalid AXIS_NAME parameter -" + $
                                 current.axis_name[i]
                          GOTO, ENDFUN
                      end
        ENDCASE
    endfor

    current.core_items = [core_items.x, core_items.y, core_items.z]
    current.suffix_items = [suffix_items.x, suffix_items.y, suffix_items.z]

    return, current

    ENDFUN:
        current.flag = -1
        return, current
end

;-----------------------------------------------------------------------------
; precondition: current contains the current object's attributes
; postcondition: processes the data_type value and determines, the architecture
;     and integer type of the core data.

function PROCESS_QUBE_DATA_TYPE, current
    ; initialize structure:
    struct = create_struct("arch", "MSB", "integer_type", "SIGNED")

    ; first determine architecture:
    item_type = current.core_item_type
    
    ; separate the string into parts with delimiter '_':
    if (!VERSION.RELEASE GT 5.2) then begin
        temp = strsplit(item_type, '_', /EXTRACT)
    endif else begin
        temp = str_sep(item_type, '_')              ; obsolete in IDL v. > 5.2
    endelse

    ; check for other architecture and integer type:
    for i = 0, n_elements(temp) - 1 do begin
        ; check for other architecture:
        if (temp[i] EQ "LSB") then begin
            struct.arch = "LSB"
        endif else if (temp[i] EQ "VAX") then begin
            struct.arch = "VAX"
        endif

        ; check for other integer type:
        if (temp[i] EQ "UNSIGNED") then begin
            struct.integer_type = "UNSIGNED"
        endif
    endfor

    return, struct
end

;-----------------------------------------------------------------------------
; precondition: current has the properly assigned core_items and suffix_items,
;     and silent keyword has been specified, and types contains the architect
;     and integer type of the core data.
; postcondition: constructs the data structure to be read for the current 
;     qube object.

function CREATE_QUBE_STRUCT, current, silent, types
    ; initialize structure:
    data_set = create_struct("flag", 1)
    x = current.core_items[0]
    y = current.core_items[1]
    z = current.core_items[2]
    bits = current.core_item_bytes * 8

    ; check whether the core items are greater than zero:
    if (x * y * z LE 0) then begin
        print, "Error: either X, Y, or Z core items value <= 0."
        GOTO, ENDFUN
    endif else if (NOT(silent)) then begin
        text = CLEAN(string(x), /SPACE) +" by "+ CLEAN(string(y), /SPACE) + $
               " by " + CLEAN(string(z), /SPACE) 
        print, "Now reading " + text + " qube array"
    endif

    ; generate the qube array to be read:
    tempelem = CREATE_QUBE_ARRAY(x, y, z, bits, current, types)   ; subroutine
    if (tempelem.flag EQ -1) then begin
        GOTO, ENDFUN
    endif
    element = tempelem.element
    tempimg = tempelem.tempimg

    ; create the structure which is to be replicated:
    data_temp = create_struct("imagedata", tempimg)

    ; process y suffix items (sideplane):
    tempelem = CREATE_QUBE_YSUF(current, data_temp)
    if (tempelem.flag EQ -1) then begin
        GOTO, ENDFUN
    endif
    data_temp = tempelem.data_temp

    ; replicate data structure y times:
    data_y = replicate(data_temp, y)

    ; process x suffix items (bottomplane):
    tempelem = CREATE_QUBE_XSUF(current, data_y)
    if (tempelem.flag EQ -1) then begin
        GOTO, ENDFUN
    endif
    data_y = tempelem.data_y

    ; process the z axis of the qube core:
    if (z GT 1) then begin
        data_z = replicate(data_y, z)
    endif else begin
        data_z = data_y
    endelse

    ; store data in a structure:
    data_set = create_struct(data_set, "data", data_z, "element", element)

    return, data_set

    ENDFUN:
        data_set.flag = -1
        return, data_set
end

;-----------------------------------------------------------------------------
; precondition: data_set is a structure containing the QUBE data already read
;     from file, and current is an idl structure containing the type of 
;     conversion needed to be done on the data, and silent is user specified 
;     keyword, types contains the architecture and integer type of core data.
; postcondition: the data is extracted from the structure and then returned
;     after proper conversion is complete. 

function CONVERT_QUBE_CORE, data_set, current, silent, types
    ; local variables:
    data = data_set.data
    element = data_set.element

    ; if not silent then inform user of status:
    if (NOT(silent)) then begin
        print, "Now performing conversion of qube array"
    end

    ; extract frames from the structure:
    for i = 0, current.core_items[2] - 1 do begin
        for j = 0, current.core_items[1] - 1 do begin
            element[*, j, i] = data[i].data_y[j].imagedata[*]
        endfor
    endfor

    ; if architecture requires conversion, then convert:
    if ((types.arch EQ "VAX") OR (types.arch EQ "LSB")) then begin
        element = conv_vax_unix(element)
    endif

    ; convert data if unsupported by IDL:
    bits = (current.core_item_bytes) * 8
    element = FIXIT_QUBE (element, bits, types)    ; subroutine

    return, element
end

;- level 0 -------------------------------------------------------------------

function QUBEPDS, fname, label, SILENT=silent
    ; error protection:
    on_error, 2

    ; check for number of parameters in function call:
    if (n_params() LT 2) then begin
        print, "Error: Syntax - result = QUBEPDS (filename, label [,/SILENT])"
        return, -1
    endif

    ; set silent keyword if specified:
    if (keyword_set(SILENT)) then begin
        silent = 1
    endif else begin
        silent = 0
    endelse

    ; obtain qube objects from label:
    objects = OBJPDS (label, "QUBE")                  ; external routine
    if (objects.flag EQ -1) then begin
        print, "Error: No viable QUBE objects found in label."
        return, -1
    endif

    ; obtain the required qube keywords from label:
    req_keywds = OBTAIN_QUBE_REQ (label)              ; subroutine
    if (req_keywds.flag EQ -1) then begin
        return, -1
    endif

    ; process each qube object:
    ; start for loop:

    for i = 0, objects.count - 1 do begin
        ; specify pointers to start and end qube object:
        start_ind = objects.index[i]
        end_ind = GET_INDEX (label, start_ind)          ; external routine
        if (end_ind EQ -1) then begin
            return, -1
        endif

        ; obtain current qube object params:
        current = OBTAIN_QUBE_CUR (req_keywds, start_ind, end_ind) ; subroutine
        if (current.flag EQ -1) then begin
            return, -1
        endif

        ; process X, Y, Z properties of the data:
        current = PROCESS_QUBE_XYZ (current)           ; subroutine        
        if (current.flag EQ -1) then begin
            return, -1
        endif

        ; process data type of core with architecture:
        types = PROCESS_QUBE_DATA_TYPE (current)       ; subroutine

        ; create qube structure to be read:
        data_set = CREATE_QUBE_STRUCT(current, silent, types) ; subroutine
        if (data_set.flag EQ -1) then begin
            return, -1
        endif

        ; set pointer:
        pointer = POINTPDS(label, fname, objects.array[i]) ; external routine
        if (pointer.flag EQ -1) then begin
            return, -1
        endif

        ; read the data:
        data_read = data_set.data
        openr, unit, pointer.datafile, /GET_LUN
        point_lun, unit, pointer.skip
        readu, unit, data_read
        close, unit
        free_lun, unit
        data_set.data = data_read

        ; extract qube core and modify as required using subroutine:
        element = CONVERT_QUBE_CORE (data_set, current, silent, types)

        ; add to qube structure:
        if (i EQ 0) then begin
            qube = element
        endif else begin
            qube = create_struct(qube, objects.array[i], element)
        endelse
    endfor

    ; end for loop

    return, qube
end
