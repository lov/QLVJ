#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <QTKit/QTKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Quartz/Quartz.h>
#import <OpenGL/CGLMacro.h>

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
    
    else if ([(NSString *)contentTypeUTI isEqualToString:@"com.apple.quartz-composer-composition"]) {
        
        QCComposition *comp = [QCComposition compositionWithFile:filePath];
                
      
      //  NSLog(@"create renderer for thumbnail...");
        CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
        
        QCRenderer *renderer = [[QCRenderer alloc] initOffScreenWithSize:NSSizeFromCGSize(maxSize) colorSpace:colorSpace composition:comp];
        
        
        if (renderer)
        {
        
            [renderer renderAtTime:0.0f arguments:nil];
            
            NSImage *img = [renderer snapshotImage]; // this image is autoreleased
            
            if (img) {
                
                CGContextRef cgContext = QLThumbnailRequestCreateContext(thumbnail, *(CGSize *)&maxSize, true, NULL);
                
                if (cgContext) {
                    
                    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithGraphicsPort:
                                                  (void *)cgContext flipped:NO];
                    
                    if (context) {
                        
                        [NSGraphicsContext saveGraphicsState];
                        [NSGraphicsContext setCurrentContext:context];
                        
                        NSRect canvasrect = NSMakeRect(0.0f, 0.0f, maxSize.width, maxSize.height);
                        
                        [[NSColor blackColor] setFill];
                        NSRectFill(canvasrect);
                        
                        [img drawInRect:canvasrect
                               fromRect:NSZeroRect
                              operation:NSCompositeSourceOver
                               fraction:1.0f];
                        
                        [NSGraphicsContext restoreGraphicsState];
                        
                    }
                    
                    
                    QLThumbnailRequestFlushContext(thumbnail, cgContext);
                    CFRelease(cgContext);
                }
                
            
            }
            
            [renderer release];
         
            
        } else NSLog(@"renderer was nil!");
   
        

    }
     
       

    // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
