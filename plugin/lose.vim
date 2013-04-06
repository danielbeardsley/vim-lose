if exists('g:loaded_lose')
  finish
endif
let g:loaded_lose = 1

function! lose#lose(name)
   let rawPath = &path
   let pathDir = substitute(rawPath, "**", "", "g")
   " find command takes space-separated paths, vim uses commas
   let pathDir = substitute(pathDir, ",", " ", "g")
   let findOutput = system('find '.pathDir.' | grep "/'.a:name.'$"')
   let matchedFiles = split(findOutput, "\n")

   if len(matchedFiles) == 0
      echo 'Cannot find file "'.a:name.'" in path.'
      return
   elseif len(matchedFiles) == 1
      let fileToOpen = matchedFiles[0]
   else
      let i = 1
      for file in matchedFiles
         echo i."\t".file
         let i+= 1
      endfor

      let selection = str2nr(input("Which file number? "))

      if selection < 1
         " Any non-numeric input to str2nr becomes 0 which we now convert to 1.
         let selection = 1
      elseif selection > len(matchedFiles)
         echo selection." is out of range!"
         return
      endif

      let fileToOpen = matchedFiles[selection-1]
   endif

   execute "e ".fileToOpen
endfunc

command! -nargs=1 Lose call lose#lose(<q-args>)
