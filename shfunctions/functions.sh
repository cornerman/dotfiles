# open program
o() {
    nohup xdg-open $@ > /dev/null 2>&1 &
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
