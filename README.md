# Files Contained
A `.vimrc` file for both sudo and non-sudo users, I believe what's different is the availability of `fzf`. Since non-sudo users have no access to `apt`, then its harder for them to install programs that may be required for some of the plugins I use.

- .bashrc
- .bash_profile
- .tmux.conf
- .tcshrc

It also contains a `nvim` folder which you can directly copy into `mkdir ~/.config && cp -R nvim "$_"` which will give you access to coc config file and `init.vim` which sources the `.vimrc` file contained in the `.vim` folder.
