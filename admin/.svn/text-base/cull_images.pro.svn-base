;=============================================================================
; cull_images
;
;  Run from home directory.  If list filename given, then nothing is deleted;
;  the unused filenames are written into that file.
;
;=============================================================================
pro cull_images, list=list

 ;-------------------------------------------------------
 ; find names of all images currently in use
 ;-------------------------------------------------------
 pattern = '*files*.txt'
 nlevels = 8

 path = './'
 for i=0, nlevels-1 do $
  begin
   new_files = findfile(path+pattern)
   if(keyword_set(new_files)) then files = append_array(files, new_files)
   path = path + '*/'
  end

 nfiles = n_elements(files)
 for i=0, nfiles-1 do $
  begin
   ff = strip_comment(read_txt_file(files[i], /raw))
   if(keyword_set(ff)) then $
    begin
     split_filename, ff, dirs, names
     w = where(strtrim(names,2) NE '')
     if(w[0] NE -1) then $
      begin
       names = names[w]
       keep_files = append_array(keep_files, names)

       ss = sort(keep_files)
       keep_files = keep_files[ss]
       
       uu = uniq(keep_files)
       keep_files = keep_files[uu]
      end
    end
  end


 ;-------------------------------------------------------
 ; find names of all images currently on disk
 ;-------------------------------------------------------
 disk_files_full = findfile('~/casIss/*/*.IMG')
 split_filename, disk_files_full, dirs, disk_files


 print, 'Total disk images: ' + strtrim(n_elements(disk_files), 2)
 print, 'Total used images: ' + strtrim(n_elements(keep_files), 2)


 ;-------------------------------------------------------
 ; find names of all unused files
 ;-------------------------------------------------------
 w = nwhere(disk_files, keep_files)
 ww = complement(disk_files, w)
 del_files = disk_files_full[ww]
 ndel = n_elements(del_files)


 ;-------------------------------------------------------
 ; delete or list del_files
 ;-------------------------------------------------------
 if(keyword_set(list)) then write_txt_file, list, del_files $
 else $
  begin
   print, 'deleting ' + strtrim(ndel,2) + ' images...'
   for i=0, ndel-1 do spawn, 'rm ' + del_files[i]
  end

end
;=============================================================================




