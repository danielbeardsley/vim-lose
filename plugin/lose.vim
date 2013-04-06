if exists('g:loaded_lose')
  finish
endif
let g:loaded_lose = 1

function! lose#lose(name)
   let rawPath = &path
   let pathDir = substitute(rawPath, "**", "", "g")
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

      if selection > len(matchedFiles) || selection < 1
         echo selection." is out of range!"
         return
      endif

      let fileToOpen = matchedFiles[selection-1]
   endif

   execute "e ".fileToOpen
endfunc

command! -nargs=1 Lose call lose#lose(<q-args>)
