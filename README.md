# Fresh installation
## Getting started
- load the minimal installation ISO from https://nixos.org/download/
- write to a USB-stick (fedora-media-writer)
- boot overwrite to USB (F12 on a thinkpad)
- select the new kernel in the boot loader
- now in the tty change user to root
```bash
sudo -i
```
- optional: set key layout, "us" is the default
```bash
loadkeys de
```
- optional: set fontsize x2
```bash
setfont -d
```
- optional: connect to Wi-Fi
```bash
nmtui
```
- activate connection
- select network and type in the key
- exit nmtui and check if you're online
```bash
ping google.com
```
- "CTRL+C" to stop

## Format the disk
- check the name of your drive
```bash
lsblk
```
- you need the main name, no partition.
- in this guide i use "sda" change this to your lsblk output
- we use a TUI again for the partitioning
```bash
cfdisk /dev/sda
```
- delete all partitions cfdisk shows, so you end up with one big free space
- new: 1G, type: EFI System
- new: 8G, type: Linux swap
- new: just press enter for the rest of the space
#### - write: It will all be gone now!
- type "yes" and it will write
- exit cfdisk, "CTRL+L" for a clear screen
- now a check and make filesystems
```bash
lsblk
```
```bash
mkfs.ext4 -L nixos /dev/sda3
```
```bash
mkswap -L swap /dev/sda2
```
```bash
mkfs.fat -F 32 -n boot /dev/sda1
```
- mount for the installation
```bash
mount /dev/disk/by-label/nixos /mnt
```
```bash
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```
```bash
swapon /dev/sda2
```

## The first config and installation
- auto-generate the config files
```bash
nixos-generate-config --root /mnt
```
- a quick and dirty prepare with the nano-editor
```bash
nano /mnt/etc/nixos/configuration.nix
```
- read a little bit and edit the important stuff
- set the timezone
- next stop is locale
- default key layout is "us", change when needed
- activate the user block and change "alice" to "slider"
- search the file for a section that looks like this
```nix
environment.systemPackages = with pkgs; [
  # wget
];
```
- add some apps we need for the next steps
- don't forget the 2 lines at the end. we activate flakes and unfree Software
```nix
environment.systemPackages = with pkgs; [
  fresh-editor
  git
  nil
  wget
];
nixpkgs.config.allowUnfree = true;
nix.settings.experimental-features = [ "flakes" "nix-command" ];
```
- "CTRL+X" to exit nano
- "y" to save, press enter to overwrite
- we are ready to install
```bash
nixos-install
```
- it will ask you to set a root password when it's done.
- we also need a user password
```bash
nixos-enter --root /mnt -c 'passwd slider'
```
- take a strong password for the user and reboot
```bash
reboot
```

## Final Steps. Clone and edit the real config
- first after reboot you will be offline with us key layout
- just do the "Getting started" optional points again and come back
- download my config
```bash
git clone https://github.com/slider104/nixos.git
```
```bash
cd nixos
```
- replace hardware-configuration.nix with your own generated
```bash
rm system/hardware-configuration.nix
```
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos/system/
```
now we comment out some stuff to keep the initial build smaller
```bash
fresh hub.nix
```
- after the inputs you see the module activation
- deactivate the gaming module by setting it to "false;"
- save and quit. then the next module
```bash
fresh system/boot.nix
```
- just comment out the filesystems block with "#"
- or delete it, but i think its a nice template for auto disk mounting
- save and quit. then the last one for this guide
```bash
fresh my-pkgs.nix
```
- comment out "rustdesk", it will build, this is super slow
- you can also get rid of "libreoffice" if you want
- save and quit. we should be good now to build the flake
```bash
sudo nixos-rebuild switch --flake .
```
- this will take a hot minute, just let it run
- reboot, welcome to my very simple config
```bash
sudo reboot
```

### --- you can explore ---
an authentication popup can shows up, just hit enter without password
if you are lost at the start, here are the most critical keyboard-shortcuts.
####   MOD+D = open app launcher, the file explorer is nemo/files
####   MOD+T = open terminal "alacritty"
####   MOD+F = expand active app to screen width (toggle)
####   MOD+Shift+F = active app fullscreen (toggle)
####   MOD+ARROW = navigate open apps
####   MOD+CTRL+ARROW = move active app
####   use PGUP and PGDOWN instead of ARROW to navigate/move between workspaces
the system itself is very clean and minimal.
learn about the system and its structure in your ~/nixos directory.
look in configuration.nix and follow the path of all the imports to learn its modular structure.
in /modules are all the *.nix modules. when you want to create a new custom dotfile for a program, 
you can use my blueprint system. take a look at /modules/fuzzel/fuzzel.nix it makes sure you can edit your dotfiles in /dotfiles/yourdotfile/config.cfg and write it to the correct directory.
at least the directory of the source file should exist.
in ~/nixos/modules/bash/bash.nix are my bash aliases. useful if you change alot.
```
# Aliases
alias cat='bat'
alias ll='ls -la'
alias nrs='sudo nixos-rebuild switch --flake ~/nixos#nixos'
alias nrb='sudo nixos-rebuild boot --flake ~/nixos#nixos'
alias nck='cd ~/nixos && nix flake check && cd -'
alias ncg='cd ~/nixos && sudo nix-collect-garbage --delete-older-than 30d && cd -'
alias nup='cd ~/nixos && nix flake update && sudo nixos-rebuild boot --flake ~/nixos#nixos && cd -'
```
when you want to sync changes you make to your own git repo, 
you need to modify the ~/nixos/modules/git/git.nix module for your git account.

## Setting up git
- read through ~/nixos/modules/git/git.nix and make changes for your user
- open the terminal and get your ssh-keygen
- if getting questions about passphrase or something, just hit enter, dont write anything
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C YOUR.EMAIL@HOST.com
```
```bash
fresh ~/.ssh/id_ed25519.pub
```
- select and copy all of what is in the file
- add that ssh copy to your github https://github.com/settings/keys
- click on "new ssh key" put it in and give it a name above
- in your terminal you can now test your ssh setup
- it will ask you about a phrase and fingerprint
- hit "enter" (empty phrase) and type "yes" for connecting anyway and you should be fine
```bash
cd nixos
```
```bash
ssh -T git@github.com
```
- for the first setup make sure your repo is created, than follow these
```bash
git init
```
```bash
git add .
```
```bash
git commit -m "initial commit"
```
```bash
git remote set-url origin git@github.com:username/repo.git
```
```bash
git push -u origin main
```
- whenever you make a change to your config nixos will know when you use git.
- for a rebuild without "dirty tree" warning your workflow looks like this
- remember to do all of it in ~/nixos/
- optional: when git is set up, the zed editor has git builtin
```bash
cd nixos
```
```bash
git add .
```
- commit with a short description if it's looking good after rebuild
```bash
git commit -m "short description of the change"
```
- rebuild nixos to apply changes
- use "nrs"-alias from anywhere in the filesystem to get the same result
```bash
sudo nixos-rebuild switch --flake .
```
- push to main
```bash
git push
```
#  
have fun with nixos

slider
