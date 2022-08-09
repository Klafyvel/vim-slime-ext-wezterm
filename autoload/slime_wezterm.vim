function! slime_wezterm#config()
  if !exists("b:slime_config['wezterm']")
    let b:slime_config = {"wezterm" : {"pane_id": "0"}}
  end
  let b:slime_config["wezterm"]["pane_id"] = input("Wezterm pane ID: ", b:slime_config["wezterm"]["pane_id"])
endfunction

function! slime_wezterm#send(config, text)
  " You can get the pane ID using `wezterm cli list`
  " or running `echo $WETZTERM_PANE` in the target 
  " pane.
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
