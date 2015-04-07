# open program
o() {
    nohup xdg-open $@ > /dev/null 2>&1 &
}

# extract archives
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# check for running processes
any() {
    if [[ -z "$1" ]] ; then
        echo "usage: any <keyword>"
        return 1
    else
        ps aux | grep -i --color=auto $1
    fi
}

#will make an iso
mkiso() {
    echo " * Volume name "
    read volume
    echo " * ISO Name (ie. tmp.iso)"
    read iso
    echo " * Directory or File(s)"
    read files
    mkisofs -o $iso -A $volume -allow-multidot -J -R -iso-level 3 -V $volume -R ${(z)files}
}

isomount(){
    sudo mount -o loop "$@" /media/iso/
}

pro_ctags () {
    dir=${1:-"."}
    touch $dir/tags
    ctags-exuberant --fields=+l --c-kinds=+p --c++-kinds=+p -f $dir/tags -R $dir
}

proj_ctags () {
    pro_ctags $(realpath ${1:-"."})
}

cflags() {
    pkg-config --libs --cflags $1
}

myip() {
    curl -s ip.appspot.com
}

whichpkg() {
    dpkg -S $(which $1)
}

debchange() {
    zless /usr/share/doc/$1/changelog.Debian.gz
}
