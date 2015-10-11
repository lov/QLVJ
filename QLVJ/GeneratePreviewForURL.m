#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>
#import <QTKit/QTKit.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <OpenGL/CGLMacro.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    
    //
    // Register for Professional Video Workflow decoders
    //
    VTRegisterProfessionalVideoWorkflowVideoDecoders();
    
    //
    // This plugin always executed on the main thread
    //

    NSString *filePath = [(__bridge NSURL *)url path];
    
    
    // Quicktime movies
    if ([(NSString *)contentTypeUTI isEqualToString:@"com.apple.quicktime-movie"])
    {
    
    
        // first of all try with AVFoundation
        // if this works, we will see the OSX standard preview panel
        AVAsset *asset = [AVAsset assetWithURL:(__bridge NSURL *)url];
        if (asset)
        {
            AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
            //
            // so at this point the AVAssetTrack will report NO for the playable property
            // because the video using a 3rd party video codec, which cannot by handled out-of-the-box
            // but it can be manageble with https://developer.apple.com/library/mac/technotes/tn2404/_index.html
            // Are there any ways to force AVFoundation to use a custom decoder when calling
            // QLPreviewRequestSetURLRepresentation(preview, url, contentTypeUTI, NULL); ?
            //
            //
            
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
            
            // movieFormatRepresentation is better here than drawing the poster image
            QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)[movie movieFormatRepresentation], kUTTypeMovie, NULL);


            [movie release];
            movie = nil;

        }
        
    } else if ([(NSString *)contentTypeUTI isEqualToString:@"com.apple.quartz-composer-composition"]) {

        
        // do nothing here, it will fallback
        // to our thumbnail


    }
    // To complete your generator please implement the function GeneratePreviewForURL in GeneratePreviewForURL.c
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
