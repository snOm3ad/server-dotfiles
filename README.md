# Files Contained
A `.vimrc` file for both sudo and non-sudo users, I believe what's different is the availability of `fzf`. Since non-sudo users have no access to `apt`, then its harder for them to install programs that may be required for some of the plugins I use.

- .bashrc
- .bash_profile
- .bash_aliases
- .tmux.conf
- setup.sh

It also contains a `nvim` folder which you can directly copy into `mkdir ~/.config && cp -R nvim "$_"` which will give you access to coc config file and `init.vim` which sources the `.vimrc` file contained in the `.vim` folder.


## New Guide for Fresh Installations in VMs
The first thing you need to do is set some required environment variables `GHTOKEN` is used to fetch the lua neovim config files from the private repository.

Once this is done run `chmod +x setup.sh && ./setup.sh` and wait for everything to get setup.


## Guide for New Installations in VMs (Deprecated)
First install `nvim`

```bash
sudo apt update && sudo apt install neovim
```

Then install `npm`

```bash
sudo apt install npm
```

Then install `node`, this is required to run `coc` in neovim

```bash
npm install node -g
```

Once everything is finished copy the `.vimrc` file into the `$HOME/.vim/` folder, then move the `nvim` folder into `$HOME/.config/` folder. Then run `nvim` and run `:CocInstall` which will install all of the plugins in the `.vimrc` file.

If everything succeeds, then you are ready to install `rust-analyzer` which you'll have to google because this process is changing as you're reading this.
