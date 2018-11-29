#!/bin/bash

function usage()
{
    echo "script to convert over 1 mega image files !! change mtime !!"
    echo "0. generate image list with -g if you want"
    echo "1. backup original image with -b"
    echo "2. convert with -r"
    echo "3. replace iamges with -d"
    echo "4. rollack with -o"
    echo "-h --help"
    
    echo ""
}

function getfiles()
{
    find image -type f -size +1M -regex ".*\.\(jpg\|jpeg\)" -mtime -250 -printf '%p\t%k KB\n' > imagefiles.txt
}

function backup()
{
    [ -d images/backupBigimages/ ] || mkdir -p images/backupBigimages/

    rm images/backupBigimages/*

    img_files=$(find image -type f -size +1M -regex ".*\.\(jpg\|jpeg\)" -mtime -160)
    for img_file in $img_files; do
        echo $img_file
	cp $img_file images/backupBigimages/$(basename $img_file)
    done
}

function rollback()
{
    cp -rf images/backupBigimages/* image/.
}

function deploy()
{
    cp -rf images/reduceBigimages/* image/.
}

function reduceimages()
{
    [ -d images/reduceBigimages/ ] || mkdir -p images/reduceBigimages/

    rm images/reduceBigimages/*

    #1M 1*1024*1024=1048576
    #2M 2*1024*1024=2097152
    #3M 3*1024*1024=3145728

    img_files=$(find /var/austlit/app/static/new/images/backupBigimages -type f -size +3145728c -regex ".*\.\(jpg\|jpeg\)")
    for img_file in $img_files; do
        echo $img_file
	#convert -resize 30% $img_file images/reduceBigimages/$(basename $img_file)
	convert $img_file -quality 20% images/reduceBigimages/$(basename $img_file)
    done
    
    img_files=$(find /var/austlit/app/static/new/images/backupBigimages -type f -size +2097152c -size -3145728c -regex ".*\.\(jpg\|jpeg\)")
    for img_file in $img_files; do
        echo $img_file
	#convert -resize 40% $img_file images/reduceBigimages/$(basename $img_file)
	convert  $img_file -quality 40% images/reduceBigimages/$(basename $img_file)
    done
    
    img_files=$(find /var/austlit/app/static/new/images/backupBigimages -type f -size +1048576c -size -2097152c -regex ".*\.\(jpg\|jpeg\)")
    for img_file in $img_files; do
        echo $img_file
	#convert -resize 80% $img_file images/reduceBigimages/$(basename $img_file)
	convert $img_file -quality 70% images/reduceBigimages/$(basename $img_file)
    done
}

while getopts "hgbriod" opt; do
    case $opt in
        h)
            usage
            exit 1
            ;;
        g)
            echo "====== file list"
            getfiles
            ;;
        
        b)
            echo "====== backup files"
            backup
            ;;
        r)
            echo "====== reduce files"
            reduceimages
            ;;
        o)
            echo "====== roll back"
            rollback
            ;;
        d)
            echo "====== deploy"
            deploy
            ;;
       
    esac
done

