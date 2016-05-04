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

proj_ctags () {
    cd-git-root
    dir=$(realpath .)
    touch $dir/tags
    ctags --fields=+l --c-kinds=+p --c++-kinds=+p -f $dir/tags -R $dir
}

watch_proj_ctags () {
    cd-git-root
    dir=$(realpath .)
    touch $dir/tags
    watchdo "ctags --fields=+l --c-kinds=+p --c++-kinds=+p -f $dir/tags -R $dir" $dir/**.scala &
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

lastvim() {
    num=${1:-"1"}
    files=$(find . -maxdepth 1 | tail -n "$num" | tr "\n" " ")
    [ -n "$files" ] && eval "${EDITOR:-vim} $files"
}

nvim_command() {
    # usage: nvim_command <socket> <command>
    # requires: https://github.com/jakm/msgpack-cli

    # https://github.com/msgpack-rpc/msgpack-rpc/blob/master/spec.md
    # msgpack-rpc is an array of [type, msgid, method, params]
    # encode and send it to nvims unix socket via netcat
    msgpack-cli encode <(echo "[0,0,\"vim_command\",[\"$2\"]]") | netcat -U $1
}

nvim_all_command() {
    # usage: nvim_all_command <command>
    for nvim in /tmp/nvim*/0; do
        nvim_command $nvim "$1"
    done
}

