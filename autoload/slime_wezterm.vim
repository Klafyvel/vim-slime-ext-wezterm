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

  return system("wezterm cli send-text --pane-id " . l:paneid, a:text)
endfunction
