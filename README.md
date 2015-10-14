# QLVJ
Quicklook plugin for generating thumbnails via Quicktime and QCRenderer API

Starting from OSX 10.9 Mavericks the Quicklook service cannot generate thumbnails and previews for some movie codecs like HAP or DXV, and not even Quartz Composer files.

This Quicklook plugin initiates Quicktime to generate **thumbnails**, so thumbnails will appear for HAP and DXV movies in Finder, and starting from OSX 10.11, this plugin can generate thumbnails for Quartz Composer files too. 

However, generating **previews** for that kind of movies **not possible** due Quicklook limitations, so that function will show you thumnbail image instead.

So, this plugin won't give you back the possibility to Quicklook all kind of loops in Finder, but it is more than nothing for now ;-)

### HAP video thumbnails on OSX 10.10.
![HAP video thumbnails on OSX 10.10.](http://www.imimot.hu/images/github/hap_ql.jpg)

### QC  thumbnails on OSX 10.11.
![QC  thumbnails on OSX 10.11.](http://www.imimot.hu/images/github/qc_ql.jpg)

## Install

* Download the latest release from https://github.com/lov/QLVJ/releases
* Drop the unzipped plugin to `~/Library/QuickLook` (create the folder if does not exist) or to `/Library/QuickLook`

## System requirements

OSX 10.9 Mavericks or later
OSX 10.11 El Capitan required for generating QC thumnbails

## Dev-Notes

* There is a bug in the Quicklook API on OSX 10.9 and 10.10 which makes impossible to create an OpenGL context in a plugin. Apple fixes this issue on OSX 10.11
* You can use HTML data representation for some kind of media types like audio, maybe WebGL will work too, however, WebKit plugins won't.

