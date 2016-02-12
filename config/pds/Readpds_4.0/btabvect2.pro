;-----------------------------------------------------------------------------
; NAME: BTABVECT2
;
; PURPOSE: To convert a given n by m dimensional column vector into type "type"
;
; CALLING SEQUENCE: 
;     Result = BTABVECT2 (element, type, rows, bytes)
;
; INPUTS:
;     Element: a n by m dimensional bytarr vector to be converted.
;     Type: the type to which the element is to be converted into.
;     Rows: the number of rows allocated to the current table object.
;     bytes: the number of bytes taken by each element in the element array.
;
; OUTPUT:
;     Result: the converted element vector into appropriate "type".
;
; MODIFICATION HISTORY:
;     Written by: Puneet Khetarpal [23 July, 2004]
;                 Some sections adapted from BTABVECT.PRO by John D. Koch.
;     For a complete list of modifications, see changelog.txt file.
;-----------------------------------------------------------------------------

function BTABVECT2, element, type, rows, bytes
    ; initialize structure:
    data = create_struct("flag", 1)
    temprows = rows
    elem = element

    ; first obtain element's dimensions:
    ; since it is a bytarr, therefore it is going to be one dimension more
    ; than what is the actual dimension of the element:
    stat = size(elem)
    if (abs(2 - stat[0]) EQ 0) then begin
        columns = 1
    endif else begin
        temprows = stat[2]
        columns = stat[3]
    endelse

    ; determine the data type:
    if (!VERSION.RELEASE GT 5.2) then begin
        temp = strsplit(type, '_', /EXTRACT)
    endif else begin
        temp = str_sep(type, '_')    ; obsolete in IDL v. > 5.2
    endelse
    if (n_elements(temp) EQ 3) then begin
        type = temp[1] + '_' + temp[2]
    endif else if (n_elements(temp) GT 1) then begin
        type = temp[1]
    endif

    ; then determine the architecture of the system:
    CASE temp[0] OF
                "": arch = "MSB"
             "MSB": arch = "MSB"
            "IEEE": arch = "MSB"
        "UNSIGNED": begin
                        arch = "MSB"
                        type = "UNSIGNED_INTEGER"
                    end
             "VAX": arch = "LSB"
            "VAXG": arch = "LSB"
             "LSB": arch = "LSB"
             "MAC": arch = "MSB"
             "SUN": arch = "MSB"
              "PC": if (strpos(type, "INTEGER") GT -1) then begin
                        arch = "LSB"
                    endif
           "ASCII": begin
                        arch = "MSB"
                        type = "CHARACTER"
                    end
       "CHARACTER": begin
                        arch = "MSB"
                        type = "CHARACTER"
                    end
              else: begin
                        print, temp[0] + " not a recognized architecture!" + $
                               " MSB assumed."
                        arch = "MSB"
                    end
    ENDCASE

    ; determine the type of vector conversion:
    if ((type EQ "INTEGER") OR (type EQ "UNSIGNED_INTEGER")) then begin
        if (bytes GT 2) then begin
            vectortype = "long"
        endif else if (bytes EQ 2) then begin
            vectortype = "integer"
        endif else begin
            vectortype = "byte"
        endelse
    endif else if ((type EQ "REAL") OR (type EQ "FLOAT")) then begin
        if (bytes LT 8) then begin
            vectortype = "float"
        endif else begin
            vectortype = "double"
        endelse
    endif else if ((type EQ "BYTE") OR (type EQ "BOOLEAN")) then begin
        vectortype = "string"
    endif else if (type EQ "DOUBLE") then begin
        vectortype = "double"
    endif else if ((type EQ "CHARACTER") OR (type EQ "TIME") OR $
                   (type EQ "DATE")) then begin
        vectortype = "string"
    endif else if (type EQ "N/A") then begin
        ; this column is a spare column, so no conversion:
        vectortype = "na"
    endif else if (type EQ "COMPLEX") then begin
        print, "Error: COMPLEX numers not yet handled by BTABVECT."
        GOTO, ENDFUN
    endif else begin
        print, "Error: " + type + " not a recognized data type!"
        GOTO, ENDFUN
    endelse

    ; perform the conversion:
    i = long(0)
    CASE vectortype OF
       "integer": begin
                      vector = intarr(temprows, columns)
                      vector = fix(elem, 0, temprows, columns)
                  end
          "long": begin
                      vector = lonarr(temprows, columns)
                      vector = long(elem, 0, temprows, columns) 
                  end
         "float": begin
                      vector = fltarr(temprows, columns)
                      vector = float(elem, 0, temprows, columns)
                  end
        "double": begin
                      vector = dblarr(temprows, columns)
                      vector = double(elem, 0, temprows, columns)
                  end
          "byte": begin
                      vector = bytarr(temprows, columns)
                      vector = byte(elem, 0, temprows, columns)
                  end
            "na": vector = elem    ; spare...no conversion to be performed
        "string": begin

    ; IDL has issues with converting from bytarr into string for n rows by 1 
    ; column bytarr for n > 1, as a string conversion reduces the dimension of
    ; the array by one. Therefore, when there are n rows GT 1, the number of
    ; dimensions is 1, and the size of that one dimension is 1, then perform
    ; a conversion into string, element by element. e.g., array is in format:
    ; array = [[1], [2], [3], [4], [5]]:

                      if ((stat[0] EQ 1 AND stat[1] GT 1) AND $
                           (rows GT 1)) then begin
                          vector = strarr(stat[1])
                          for i = 0, stat[1] - 1 do begin
                              vector[i] = string(elem[i])
                          endfor
                      endif else begin
                          vector = strarr(temprows, columns)
                          vector = string(elem)
                      endelse                      
                  end
    ENDCASE

    data = create_struct(data, "vector", vector)

    return, data

    ENDFUN:
        data.flag = -1
        return, data
end
