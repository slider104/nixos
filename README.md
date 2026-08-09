# Fresh installation
this is my personal nixos setup. super lightweight and ready for gaming.
the ly display manager is set to autologin.
i use the niri window manager with a very simple waybar for now.

## 1. ISO installation
- load the graphical installation ISO from https://nixos.org/download/
- write to a USB-stick (fedora-media-writer)
- boot from USB into KDE with the latest Kernal
- do the standard install and select KDE as the desktop 
- select the username that you want
#### !!! set hostname to "nixos" !!! this guide does not rewrite your hostname
- reboot into your fresh system

## 2. Initial configuration for flakes and git
- open /etc/nixos/configuration.nix with the kate editor
- search the file for a section that looks like this
```nix
environment.systemPackages = with pkgs; [
  # wget
];
```
- select the block and overwrite it with this
```nix
  environment.systemPackages = [
    pkgs.fresh-editor
    pkgs.git
    pkgs.nil
    pkgs.wget
    pkgs.zed-editor
  ];
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
```
- save and exit the file
- activate the changes
```bash
sudo nixos-rebuild switch
```

## 3. With flakes enabled, everything can go to /home
- now you can clone the nixos repo
- in the terminal you need to be in your home directory
  (default when opening a terminal like "Konsole" in KDE)
- this will create the ~/nixos folder with all other files/folders
```bash
git clone https://github.com/slider104/nixos.git
```
##### - DELETE ~/nixos/harware-configuration.nix you need your own
- go to /etc/nixos/ and copy the generated hardware-configuration.nix
- put that copy in ~/nixos/ instead of the one you got from my repo
- go to ~/nixos/dotfiles select all folders and copy them
- got to ~/.config and paste the copies in there
- don't do a rebuild, you need to overwrite the username first!

## 4. Change the username in the complete repo
- open the zed editor
- open the project/folder ~/nixos
- on the right you see the project
- rightclick the top main folder nixos and select "Find in Folder..."
- search "slider" and click the replace button to the right of the search
- in the new replace bar you put in your EXACT username from the installer
- replace all :) its your system now

## 5. Final steps and use
- open terminal
- say goodbye to KDE, here comes the final rebuild for the setup
```bash
cd nixos
```
```bash
sudo nixos-rebuild switch --flake .
```
- if an authentication popup shows up, just hit enter without password

### you can exlore
if you are lost at the start, here are the most critical keyboard-shortcuts
#### MOD+D = open app launcher, the file exlorer is nemo/files
#### MOD+T = open terminal "alacritty"
#### MOD+F = expand active app to screen width (toggle)
#### MOD+M = active app fullscreen (toggle)
#### MOD+ARROW = navigate open apps
#### MOD+CTRL+ARROW = move active app
#### use PGUP and PGDOWN instead of ARROW to navigate/move between workspaces
the system itself is very clean and minimal
learn about the system and its structure in your ~/nixos directory
look in configuration.nix and follow the path of all the imports to learn its modular structure
in ~/nixos/home.nix are my bash aliases living for now. usefull if you change alot
```nix
cat = "bat";
ll = "ls -la";
nrs = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
nck = "cd ~/nixos && nix flake check && cd -";
ncg = "cd ~/nixos && sudo nix-collect-garbage --delete-older-than +5 && cd -";
```
when you want to sync changes you make to your own git repo
you need to modify the ~/nixos/modules/git/git.nix module for your git account.

## 6. Setting up git
- read through ~/nixos/modules/git/git.nix and make changes for your user
- open the terminal and get your ssh-keygen
- if getting questions about passphrase or something, just hit enter, dont write anything
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C your.email@blabla.com
```
```bash
fresh ~/.ssh/id_ed25519.pub
```
- select and copy all of what is in the file
- add that ssh copy to your github https://github.com/settings/keys
- click on "new ssh key" put it in and give it a name above
- in your terminal you can now test your ssh setup
- it could ask you if you want continue without fingerprint
- type "yes" and you should be fine
```bash
cd nixos
```
```bash
ssh -T git@github.com
```
- for the first setup make sure your repo is created and follow these
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
git pull origin main --allow-unrelated-histories
```
```bash
git commit -m "Merge remote changes"
```
```bash
git push -u origin main
```
- this was overkill, but a little bit safer i think

______________________________________________________

have fun with nixos

slider
