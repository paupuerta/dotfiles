#!/bin/zsh

# curl https://gist.githubusercontent.com/prabirshrestha/279d8b179d9353fe8694/raw/babun-post-install | zsh
successfully() {
  $* || (echo "\nfailed" 1>&2 && exit 1)
}

fancy_echo() {
    echo "\n$1"
}

if type apt-get >/dev/null; then
  aptGet='apt-get'
elif type pact >/dev/null; then
  aptGet='pact'
else
  echo >&2 "I require intaller but it's not installed.  Aborting."; exit 1;
fi

#fancy_echo "Set Proxy"
#  export http_proxy=http://localhost:3128
#  export https_proxy=$http_proxy

#
if type babun >/dev/null; then
  fancy_echo "Install Fonts"
  successfully $BABUN_HOME\\fonts\\RegisterFont.exe add `cygpath -d $BABUN_HOME/fonts/Menlo/*.ttf`
  #$BABUN_HOME\\fonts\\RegisterFont.exe rem `cygpath -d $BABUN_HOME/fonts/Menlo/*.ttf`
fi

fancy_echo "Updating "
  successfully $aptGet update

fancy_echo "Installing tmux"
  if type tmux >/dev/null; then
    echo "tmux ya instalado"
  else
    successfully $aptGet install tmux
  fi

fancy_echo "Installing XServer"
  if type xinit >/dev/null; then
    echo "XServer ya instalado"
  else
    $aptGet install xorg-server xinit xorg-docs
  fi

fancy_echo "Installing ruby"
  if type ruby >/dev/null; then
    echo "ruby ya instalado"
  else
    successfully $aptGet install ruby
  fi

fancy_echo "Installing python3"
  if type python3 >/dev/null; then
    echo "python3 ya instalado"
  else
    successfully $aptGet install python3
  fi

fancy_echo "Installing the_silver_searcher (ag)"
  if type ag >/dev/null; then
    echo "ag ya instalado"
  else
    successfully $aptGet install automake pkg-config libpcre-devel liblzma-devel
    successfully git clone https://github.com/ggreer/the_silver_searcher ~/ag
    successfully pushd ~/ag
    successfully bash -x -o igncr ./build.sh && make install
    successfully cd ..
    successfully rm -rf ~/ag
    successfully popd
  fi

fancy_echo "minttyrc Config"
  minttyrc=~/.minttyrc
  if [ -e $minttyrc ]; then
    echo "minttyrc exists"
    rm $minttyrc
  fi
  ln -s ~/dotfiles/.minttyrc $minttyrc

fancy_echo "Babun Config"
  babunrc=~/.babunrc
  if [ -e $babunrc ]; then
    echo "babunrc exists"
    rm $babunrc
  fi
  ln -s ~/dotfiles/.babunrc $babunrc

fancy_echo "Vim Config"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vimrc=~/.vimrc
  if [ -e $vimrc ]; then
    echo "vimrc exists"
    rm $vimrc
  fi
  ln -s ~/dotfiles/.vimrc $vimrc

  vimrc_bundles=~/.vimrc.bundles
  if [ -e $vimrc_bundles ]; then
    echo "vimrc_bundles exists"
    rm $vimrc_bundles
  fi
  ln -s ~/dotfiles/.vimrc.bundles $vimrc_bundles

fancy_echo "Tmux Config"
  if [ -e ~/.tmux/plugins/tpm ]; then
    git -C ~/.tmux/plugins/tpm pull
  else
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  tmuxconf=~/.tmux.conf
  if [ -e $tmuxconf ]; then
    echo "tmuxconf exists"
    rm $tmuxconf
  fi
  ln -s ~/dotfiles/.tmux.conf $tmuxconf

  tmuxconflocal=~/.tmux.conf.local
  if [ -e $tmuxconflocal ]; then
    echo "tmuxconflocal exists"
    rm $tmuxconflocal
  fi
  ln -s ~/dotfiles/.tmux.conf.local $tmuxconflocal

tmux source-file ~/.tmux.conf
tmux
echo "prefix + I to install tmux plugins"

