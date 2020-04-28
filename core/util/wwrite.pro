pro wwrite, fname, files, pts, comment=comment

 s = '# ' + comment

 ss = strtrim(files,2)
 ss = ss + '	' + strtrim(pts[0,*],2)
 ss = ss + '	' + strtrim(pts[1,*],2)

 s = [s, ss]

 write_txt_file, fname, s
 
 print, 'wrote ' + fname, + '.'
end
