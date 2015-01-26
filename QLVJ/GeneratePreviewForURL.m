#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>
#import <QTKit/QTKit.h>
#import <AVFoundation/AVFoundation.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    
    //
    // This plugin always executed on the main thread
    //

    NSString *filePath = [(__bridge NSURL *)url path];
    
    
    // Quicktime movies
    if ([(NSString *)contentTypeUTI isEqualToString:@"com.apple.quicktime-movie"]) {
    
    
        // first of all try with AVFoundation
        // if this works, we will see the OSX standard preview panel
        AVAsset *asset = [AVAsset assetWithURL:(__bridge NSURL *)url];
        if (asset)
        {
            AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
            if (track && track.playable)
            {
                QLPreviewRequestSetURLRepresentation(preview, url, contentTypeUTI, NULL);
                return noErr;
            }
        }
        

        // at this point, if we try to generate a fallback image via QTKit
        if ([QTMovie canInitWithFile:filePath]) {
                       
            NSDictionary *attributes =
            [NSDictionary dictionaryWithObjectsAndKeys:
             filePath, QTMovieFileNameAttribute,
             [NSNumber numberWithBool:NO], QTMovieOpenAsyncOKAttribute,
             [NSNumber numberWithBool:NO], QTMovieOpenForPlaybackAttribute,
             nil];
            
            QTMovie *movie = [[QTMovie alloc] initWithAttributes:attributes error:NULL];
            NSImage *qtthumb = [movie posterImage]; // this is an auto-released image
            
            NSSize canvasSize = [qtthumb size];
            
            CGContextRef cgContext = QLPreviewRequestCreateContext(preview, *(CGSize *)&canvasSize, true, NULL);
            
            if (cgContext && qtthumb) {
                
                NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithGraphicsPort:
                           (void *)cgContext flipped:NO];
                
                if (context) {
                    
                    [NSGraphicsContext saveGraphicsState];
                    [NSGraphicsContext setCurrentContext:context];
                    
                    [qtthumb drawInRect:NSMakeRect(0.0f, 0.0f, canvasSize.width, canvasSize.height)
                               fromRect:NSZeroRect
                              operation:NSCompositeCopy
                               fraction:1.0f];
                    
                    [NSGraphicsContext restoreGraphicsState];
                    
                }
                
                
                QLPreviewRequestFlushContext(preview, cgContext);
                CFRelease(cgContext);
            }
            
            [movie release];
            movie = nil;

        }
        
    }
    // To complete your generator please implement the function GeneratePreviewForURL in GeneratePreviewForURL.c
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
