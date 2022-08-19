# vim-slime-ext-wezterm
An experiment for an external wezterm plugin for vim-slime

## Example of configuration using packer

```lua
  use {
    'Klafyvel/vim-slime-ext-wezterm',
    config=function ()
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_target_send = "sime_wezterm#send"
      vim.g.slime_target_config = "sime_wezterm#config"
    end
  }
```
