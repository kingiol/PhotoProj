//
//  PPFlickInterface.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPFlickInterface.h"

#import "PPFlickrPhotoInfo.h"
#import "PPFlickrEngine.h"

#define kFlickrAPIKey @"796a4834a09fdc66196d73234557cbce"
#define kFlickrSecret @"c1c3930506036563"

@implementation PPFlickInterface

- (NSString *)flickSearchURLPathForSearchTerm:(NSString *)searchTerm {
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1", kFlickrAPIKey, searchTerm];
}

- (void)searchFlickForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock {

    [[PPFlickrEngine shareInstance] sendRequestPath:[self flickSearchURLPathForSearchTerm:term] withParams:nil callSuccessBlock:^(id responseData) {
        NSDictionary *searchResultsDict = (NSDictionary *)responseData;
        NSString *status = searchResultsDict[@"stat"];
        if ([status isEqualToString:@"fail"]) {
            NSError *error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:searchResultsDict[@"message"]}];
            completionBlock(term, nil, error);
        }else {
            NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
            NSMutableArray *flickrPhotos = [@[] mutableCopy];
            for (NSMutableDictionary *objPhoto in objPhotos) {
                PPFlickrPhotoInfo *photo = [[PPFlickrPhotoInfo alloc] init];
                photo.farm = [objPhoto[@"farm"] intValue];
                photo.server = [objPhoto[@"server"] intValue];
                photo.secret = objPhoto[@"secret"];
                photo.photoID = [objPhoto[@"id"] longLongValue];
                
                [PPFlickInterface loadImageForPhoto:photo thumbnail:YES completionBlock:nil];
                
                [flickrPhotos addObject:photo];
            }
            completionBlock(term, flickrPhotos, nil);
        }

    } callErrorBlock:nil];
}

+ (void)loadImageForPhoto:(PPFlickrPhotoInfo *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock)completionBlock {
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *imageURL = [PPFlickInterface flickrPhotoURLForFlickrPhoto:flickrPhoto size:size];
    
    [[PPFlickrEngine shareInstance] loadImageForPhoto:flickrPhoto withURLStr:imageURL callSuccessBlock:^(id responseData) {
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSData *imageData = resultDict[@"data"];
        PPFlickrPhotoInfo *info = resultDict[@"key"];
        UIImage *image = [UIImage imageWithData:imageData];
        if ([size isEqualToString:@"m"]) {
            info.thumbnail = image;
        }else {
            info.largeImage = image;
        }
        completionBlock(image, nil);
    } callErrorBlock:nil];
    
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(PPFlickrPhotoInfo *)flickrPhoto size:(NSString *)size {
    if (!size) {
        size = @"m";
    }
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg", flickrPhoto.farm, flickrPhoto.server, flickrPhoto.photoID, flickrPhoto.secret, size];
}


@end
