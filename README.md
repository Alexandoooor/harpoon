# harpoon.zsh

## Harpoon usage

### Commands:

    hook <name>         add a hook <name> for the current directory
    jump <name>         cd to the directory referenced by <name>
    unhook <name>       remove hook <name>
    hooks               list current hooks
    harpoon             print this message

### Example usage:

    cd ~/projects/myapp
    hook app

    cd ~
    jump app  # instantly back to ~/projects/myapp

    hooks     # list all hooks

    unhook app # remove the hook
