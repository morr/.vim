## Requirements

### Packages `ctags`, `cowsay`, `fortune`
```
brew install ctags cowsay fortune
```

### Fonts
Monaco for Powerline:
download and install this font: [monaco_for_powerline.otf](https://gist.github.com/baopham/1838072/raw/5fa73caa4af86285f11539a6b4b6c26cfca2c04b/Monaco%20for%20Powerline.otf)

[About Monaco for Powerline](https://gist.github.com/baopham/1838072)

### Ruby 2.0

Install rvm by following [this instruction](http://rvm.io/rvm/install).

Install ruby 2.0 via rvm:
```
rvm install ruby-2.0
```


## Vim configs installation

Clone this repo into your home directory either as .vim (linux) or vimfiles (windows).

Then cd into the repo and run this to get all plugins installed: 
`./update_bundles`


Put this code into your ~/.vimrc along with your personal hacks:

### OSX and Linux
```
source ~/.vim/vimrc
source ~/.vim/gvimrc
```

### Windows
```
source ~/vimfiles/vimrc
source ~/vimfiles/gvimrc
```

## Enjoy! :)
