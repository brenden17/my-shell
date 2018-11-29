#!/bin/bash

function usage()
{
    echo "script to compile java and minify javascript and css"
    echo "-h --help"
    echo "-c -- compile java filename"
    echo "-m -- minify js, css filename, do not replace templates"
    echo "-r -- replace js, css filename"
    echo "-a -- compile all java, js, css filename, do not replace templates"
    echo "-t -- show changed templates"
    echo "-p -- git pull origin master"
    echo "-s -- git status"
    echo "-l -- git log"
    echo "-f -- flush"
    
    echo ""
}

function compile()
{
    if [[ $1 == *.js ]] || [[ $1 == *.css ]]; then
        ./scripts/static/minify-replace $1
    elif [[ $1 == *.java ]]; then
        ./jc $1
    else
      echo "Unsupport file format"  
    fi
}

function compileall()
{
    pulled_files=$(git diff --name-only HEAD@{0} HEAD@{1})
    # echo $pulled_files
    for pulled_file in $pulled_files; do
        app_file=${pulled_file:4}
        if [[ $app_file == *.min.js ]] || [[ $app_file == *.min.css ]]; then
            echo "-- $app_file is passed..."
        elif [[ $app_file == *.js ]] || [[ $app_file == *.css ]]; then
            # echo "-- $app_file is minified..."
            ./pc -m $app_file
        elif [[ $app_file == *.java ]]; then
            echo "** $app_file is compiled..."
            ./jc $app_file
        else
             echo "$app_file"
        fi
    done;
}

while getopts "cmrthpaslfd" opt; do
    case $opt in
        h)
            usage
            exit 1
            ;;
        c)
            shift
            ./jc $1
            ;;
        m)
            shift
            ./scripts/static/minify-replace -m $1
            ;;
        r)
            shift
            ./scripts/static/minify-replace -r $1
            ;;
        t)
            shift
            ./scripts/static/minify-replace -t $1
            ;;
        p)
            echo "====== GIT PULL"
            # gitpull
            git pull origin master
            ;;
        a)
            echo "====== PRECOMPILE ALL"
            compileall
            ;;
        s)
            # gitstatus # git status
            git status
            ;;
        l)
            # gitstatus # git status
            git log
            ;;
        f)
            echo "====== FLUSH"
            # flush
            curl http://127.0.0.1:7474/page/flush
            echo ""
            ;;
        d)
            echo "====== DEPLOY"
            # deploy
            ./deploy
            ;;
        
    esac
done

if [ $OPTIND -eq 1 ]; then
    for i in "$@"; do
        compile $i
    done
    echo "DONE....."
fi
