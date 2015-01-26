#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <QTKit/QTKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Quartz/Quartz.h>

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    
    //
    // This plugin always executed on the main thread
    //
    NSString *filePath = [(__bridge NSURL *)url path];


    // Quicktime movies and QC comps
    if ([(NSString *)contentTypeUTI isEqualToString:@"com.apple.quicktime-movie"]) {
    
       
        //
        // so let's try to create a Thumbnail with QTKit
        //
    
        if ([QTMovie canInitWithFile:filePath]) {
            
            
            NSDictionary *attributes =
            [NSDictionary dictionaryWithObjectsAndKeys:
             filePath, QTMovieFileNameAttribute,
             [NSNumber numberWithBool:NO], QTMovieOpenAsyncOKAttribute,
             [NSNumber numberWithBool:NO], QTMovieOpenForPlaybackAttribute,
             nil];
            
            QTMovie *movie = [[QTMovie alloc] initWithAttributes:attributes error:NULL];
            NSImage *qtthumb = [movie posterImage]; // this is an auto-released image
            [movie release];
            movie = nil;
            
            if (qtthumb) {
            
                CGImageSourceRef source;
                
                source = CGImageSourceCreateWithData((CFDataRef)[qtthumb TIFFRepresentation], NULL);
                CGImageRef imgRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
                QLThumbnailRequestSetImage(thumbnail, imgRef, NULL);
                
                CGImageRelease(imgRef);
                CFRelease(source);

            }
            
            
        }

    }
    // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
