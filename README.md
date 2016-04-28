# QLVJ
Quicklook plugin for generating thumbnails via Quicktime and QCRenderer API

Starting from OSX 10.9 Mavericks the Quicklook service cannot generate thumbnails and previews for some movie codecs like HAP or DXV, and not even Quartz Composer files.

This Quicklook plugin initiates Quicktime to generate **thumbnails**, so thumbnails will appear for HAP and DXV movies in Finder, and starting from OSX 10.11, this plugin can generate thumbnails for Quartz Composer files too. 

However, generating **previews** for that kind of movies **not possible** due Quicklook limitations, so that function will show you thumnbail image instead.

So, this plugin won't give you back the possibility to Quicklook all kind of loops in Finder, but it is more than nothing for now ;-)

### HAP video thumbnails on OSX 10.10
![HAP video thumbnails on OSX 10.10.](http://imimot.com/images/github/hap_ql.jpg)

### QC  thumbnails on OSX 10.11
![QC  thumbnails on OSX 10.11.](http://imimot.com/images/github/qc_ql.jpg)
Sample QC files made by http://vargasz.tumblr.com and http://destroythingsbeautiful.com

## Install

* Download the latest release from https://github.com/lov/QLVJ/releases
* Drop the unzipped plugin to `~/Library/QuickLook` (create the folder if does not exist) or to `/Library/QuickLook`

## System requirements

* OSX 10.9 Mavericks or later
* OSX 10.11 El Capitan required for generating QC thumnbails (see notes below!)

## Dev-Notes

There is a bug in the Quicklook API on OSX 10.9 and 10.10 which makes impossible to create an OpenGL context in a plugin. Apple fixed this issue on OSX 10.11 on some configurations, but others still won't work:

* MacBook Pro (Retina, 15-inch, Late 2013) running OSX 10.11.4

