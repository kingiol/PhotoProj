//
//  PPFlickInterface.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPFlickInterface.h"

#import "PPFlickrPhotoInfo.h"

#define kFlickrAPIKey @"796a4834a09fdc66196d73234557cbce"
#define kFlickrSecret @"c1c3930506036563"

@implementation PPFlickInterface

+ (NSString *)flickSearchURLForSearchTerm:(NSString *)searchTerm {
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1", kFlickrAPIKey, searchTerm];
}

- (void)searchFlickForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock {
    NSString *searchURL = [PPFlickInterface flickSearchURLForSearchTerm:term];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL] encoding:NSUTF8StringEncoding error:&error];
        
        if (error != nil) {
            completionBlock(term, nil, error);
        }else {
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            if (error != nil) {
                completionBlock(term, nil, error);
            }else {
                NSString *status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError *error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:searchResultsDict[@"message"]}];
                    completionBlock(term, nil, error);
                }else {
                    NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                    NSMutableArray *flickrPhotos = [@[] mutableCopy];
                    for (NSMutableDictionary *objPhoto in objPhotos) {
                        PPFlickerPhotoInfo *photo = [[PPFlickerPhotoInfo alloc] init];
                        photo.farm = [objPhoto[@"farm"] intValue];
                        photo.server = [objPhoto[@"server"] intValue];
                        photo.secret = objPhoto[@"secret"];
                        photo.photoID = [objPhoto[@"id"] longLongValue];
                        
                        NSString *searchURL = [PPFlickInterface flickrPhotoURLForFlickrPhoto:photo size:@"m"];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL] options:0 error:&error];
                        UIImage *image = [UIImage imageWithData:imageData];
                        photo.thumbnail = image;
                        
                        [flickrPhotos addObject:photo];
                    }
                    completionBlock(term, flickrPhotos, nil);
                }
            }
        }
    });
}

+ (void)loadImageForPhoto:(PPFlickerPhotoInfo *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock)completionBlock {
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *searchURL = [PPFlickInterface flickrPhotoURLForFlickrPhoto:flickrPhoto size:size];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL] options:0 error:&error];
        if (error != nil) {
            completionBlock(nil, error);
        }else {
            UIImage *image = [UIImage imageWithData:imageData];
            if ([size isEqualToString:@"m"]) {
                flickrPhoto.thumbnail = image;
            }else {
                flickrPhoto.largeImage = image;
            }
            completionBlock(image, nil);
        }
    });
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(PPFlickerPhotoInfo *)flickrPhoto size:(NSString *)size {
    if (!size) {
        size = @"m";
    }
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg", flickrPhoto.farm, flickrPhoto.server, flickrPhoto.photoID, flickrPhoto.secret, size];
}


@end
