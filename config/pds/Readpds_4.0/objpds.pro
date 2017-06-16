;-----------------------------------------------------------------------------
; NAME: OBJPDS
;
; PURPOSE: To obtain viable data objects from a PDS label.
;
; CALLING SEQUENCE: Result = OBJPDS (label, param)
;
; INPUTS:
;    Label: String array containing object header information.
;    Param: The object parameter to search for.
; OUTPUTS:
;    Result: A structure containing the viable object names, object count,
;            and the object indicies.
;
; OPTIONAL INPUT: none.
;
; EXAMPLES:
;    To obtain all image objects:
;       IDL> label = HEADPDS ("TEST.LBL")
;       IDL> objects = OBJPDS (label, "IMAGE")
;       IDL> help, /STRUCTURE, objects
;            ARRAY         STRING        ARRAY[1]
;            COUNT           INT                1
;            INDEX          LONG         ARRAY[1]
;    To obtain all viable objects:
;       IDL> label = HEADPDS ("TEST.LBL")
;            ARRAY         STRING        ARRAY[3]
;            COUNT           INT                3
;            INDEX          LONG         ARRAY[3]
; 
; PROCEDURES USED:
;    Functions: PDSPAR, CLEANARR
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [14 February, 2003]
;    For a complete list of modifications, see changelog.txt file.    
;
;-----------------------------------------------------------------------------

;- level 1 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: param is a scalar string, and object struct has been 
;      compiled properly with all the object
; postcondition: returns a structure containing all the viable objects matching
;      param, with values, count, and index. Also, a flag field is passed in
;      indicating 1 for at least one viable object, and -1 for none.

function OBTAIN, param, object
    ; error protection:
    ;on_error, 2

    ; initialize variables:
    length = strlen(param)
    struct = {flag: 1}

    ; process individual objects or all objects:
    if NOT (param EQ "ALL") then begin
        ; find position in object array strings where param is matched:
        pos = strpos (object.array, param)

        ; determine the length of each of the strings in object array:
        len = strlen (object.array)

        ; find position where param has been matched and the length of 
        ; param is equal to the length of the object array values.
        ; in particular, the latter condition is to ensure that only those
        ; object strings are matched with param that end with the value
        ; param, i.e., e.g., param "IMAGE" will match "PRIMARY_IMAGE"
        ; but not "IMAGE_HEADER", and param "TABLE" will match "TABLE" but
        ; not "TABLE_HEADER":
        newpos = where (pos GT -1 AND abs(len-pos) EQ length, srchcount) 

        ; if above search yields positive definite result, then 
        ; create a structure that contains the matched results, else
        ; create a structure that contains an empty result, with 
        ; struct.flag set to -1:
        if (srchcount GT 0) then begin
            struct = create_struct(struct, "count",srchcount, "array", $
                        object.array[newpos], "index", object.index[newpos])
        endif else begin
            struct.flag = -1
            struct = create_struct(struct,"count",0,"array","", "index",0) 
        endelse
    endif else begin
        ; construct list of viable objects:
        name_arr = ["ARRAY","COLLECTION","TABLE","SERIES","PALETTE", $
                    "SPECTRUM","IMAGE","QUBE","WINDOW"]

        ; create temp structure:
        temparray = ""
        tempcount = 0
        tempindex = ""

        ; obtain viable objects from the list using OBTAIN:
        for i = 0, 8 do begin
            temp = OBTAIN (name_arr[i], object)
            if (temp.flag NE -1) then begin
                temparray = [temparray, temp.array]
                tempcount = tempcount + temp.count
                tempindex = [tempindex, temp.index]
            endif
        endfor

        ; if viable objects exist in the list, then add to structure, else
        ; create a blank structure with flag set to -1:
        if (tempcount NE 0) then begin
            struct = create_struct(struct, "count",tempcount, "array", $
                        temparray[1:tempcount],"index",tempindex[1:tempcount]) 
        endif else begin
            struct.flag = -1
            struct = create_struct(struct, "count",0,"array","","index",0)
        endelse
    endelse

    ; final structure:
    final = struct

    return, final
end

;-----------------------------------------------------------------------------
; precondition: the object structure contains at least one viable object
;     element.
; postcondition: the object structure is returned with the value and index
;     arrays sorted in ascending order by the index values.

function SORT_STRUCTURE, object
    ; error protection:
    ;on_error, 2

    ; loop through object index and perform sequential sort:
    for i = 0, object.count-2 do begin
        min = i

        for j = i + 1, object.count-1 do begin
            if (object.index[j] LT object.index[min]) then begin
                min = j
            endif
        endfor

        temp1 = object.index[i]
        temp2 = object.array[i]
        object.index[i] = object.index[min]
        object.array[i] = object.array[min]
        object.index[min] = temp1
        object.array[min] = temp2
    endfor

    return, object
end

;-----------------------------------------------------------------------------
; precondition: param is a scalar string in upper case, and object contains
;     only viable PDS objects.
; postcondition: the subroutine checks whether param is equal to "ALL", and 
;     if so, then checks whether there exists duplicate names of objects
;     that are not ARRAY, COLLECTION, or WINDOW. If duplicates found, then
;     returns -1, else 1

function CHECK_DUPLICATE, param, object
    ; error protection:
    ;on_error, 2

    if (param EQ "ALL") then begin
        for i = 0, object.count-2 do begin
            arrpos = strpos(object.array[i],"ARRAY")
            colpos = strpos(object.array[i],"COLLECTION")
            winpos = strpos(object.array[i],"WINDOW")
            if ((object.array[i] EQ object.array[i+1]) AND $
                (arrpos EQ -1 AND colpos EQ -1 AND winpos EQ -1)) then begin
                print, "ERROR: Duplicate object names found in label."+ $
                       " Object names must be unique."
                return, -1
            endif
        endfor
    endif

    return, 1
end

;- level 0 -------------------------------------------------------------------

;-----------------------------------------------------------------------------
; precondition: label is a viable PDS label, and param is a scalar string.
; postcondition: returns a structure containing all viable objects that match
;     param.

function OBJPDS, label, param
    ; error protection:
    ;on_error, 2
    
    ; initialize object structure:
    object = create_struct("flag",1)

    ; obtain all OBJECT keywords from label:
    objarray = PDSPAR (label, "OBJECT", COUNT=objcount, INDEX=objindex)
    if (!ERR EQ -1) then begin
        print, "ERROR: file missing required OBJECT keyword(s)."
        GOTO, ENDFUN
    endif    

    ; clean the object array and format param:
    objarray = CLEANARR (objarray, /SPACE)
    objarray = strupcase (objarray)
    param = strupcase (param)
    object = create_struct(object, "array",objarray, "count",objcount, $
                           "index",objindex)

    ; extract param objects:
    object = OBTAIN (param, object)

    ; sort objects in structure index in ascending order:
    object = SORT_STRUCTURE (object)

    ; check for duplicate names:
    if (CHECK_DUPLICATE (param, object) EQ -1) then begin
        GOTO, ENDFUN
    endif

    return, object

    ENDFUN:
        object.flag = -1
        return, object
end
