# QLVJ
Quicklook plugin for generating thumbnails via Quicktime

Starting from OSX 10.9 Mavericks the Quicklook service cannot generate thumbnails and previews for some movie codecs like HAP or DXV.
This Quicklook plugin initiates Quicktime to generate **thumbnails**, so thumbnails will appear for HAP and DXV movies in Finder. 
However generating **previews** for that kind of movies **not possible** due Quicklook limitations, so that function will show you thumnbail image instead.

So, this plugin won't give you back the possibility to Quicklook all kind of loops in Finder, but it is more than nothing for now ;-)

![HAP video thumbnails on OSX 10.10.](http://www.cogevj.hu/images/github/hap_ql.jpg)
## Install

* Download the latest release from https://github.com/lov/QLVJ/releases
* Drop the unzipped plugin to `~/Library/QuickLook` (create the folder if does not exist) or to `/Library/QuickLook`

## System requirements

OSX 10.9 Mavericks or later

## Dev-Notes

* Quicklook is Sandbox-ed, so cannot create an OpenGL context in a Quicklook plugin (so no thumbnails/previews for QC compositions too)
* You can use HTML data representation for some kind of media types like audio, maybe WebGL will work too, however, WebKit plugins won't.

