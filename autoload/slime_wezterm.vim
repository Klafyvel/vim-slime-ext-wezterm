" Convenience functions

function! s:ParseWeztermOutputLine(k,line)
  " Wezterm output is a table looking like this
  " WINID TABID PANEID WORKSPACE SIZE   TITLE    CWD
  " this function creates a dictionnary from a line
  let l:splitted = split(a:line)
  return {"winid": l:splitted[0], 
        \ "tabid": l:splitted[1], 
        \ "paneid": l:splitted[2], 
        \ "workspace": l:splitted[3], 
        \ "size": l:splitted[4], 
        \ "title": l:splitted[5], 
        \ "cwd": l:splitted[6]}
endfunction
  
function! s:ParseWeztermOutput(out)
  let l:wezterm_cli_output = split(a:out, '\n')
  if len(l:wezterm_cli_output) <= 1
    throw "No wezterm pane found."
  endif
  return map(l:wezterm_cli_output[1:], function("s:ParseWeztermOutputLine"))
endfunction

" Public API for vim-slime to use.

function! slime_wezterm#config(config)
  if !exists("a:config['wezterm']")
    let a:config["wezterm"] = {"pane_id": "0"}
  end
  let l:wezterm_cli_output = s:ParseWeztermOutput(system("wezterm cli list"))
  let l:prompt = "Please select an available wezterm pane\n
        \(I won't prevent you from choosing a pane that does not exist.)\n
        \------------------------"
  let l:choices = map(l:wezterm_cli_output, 'v:val["tabid"] . ". Pane \"" . v:val["title"] . "\" working in " . v:val["cwd"]')
  let l:idx = input(join(flatten([l:prompt, l:choices, "Your choice > "]), "\n"))

  if len(l:idx) < 1
    echo "\nNo pane id chosen."
  else
    let a:config["wezterm"]["pane_id"] = l:idx
  endif
  return a:config
endfunction

function! slime_wezterm#send(config, text)
  let l:paneid = a:config["wezterm"]["pane_id"]

  if exists("b:slime_bracketed_paste")
    let bracketed_paste = b:slime_bracketed_paste
  elseif exists("g:slime_bracketed_paste")
    let bracketed_paste = g:slime_bracketed_paste
  else
    let bracketed_paste = 0
  endif

  if bracketed_paste
    return system("wezterm cli send-text --pane-id " . l:paneid, a:text)
  else
    return system("wezterm cli send-text --no-paste --pane-id " . l:paneid, a:text)
  endif
endfunction
