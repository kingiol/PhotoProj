//
//  PPFlickInterface.h
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPFlickrPhotoInfo;

typedef void (^FlickrSearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^FlickrPhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface PPFlickInterface : NSObject

- (void)searchFlickForTerm:(NSString *)term completionBlock:(FlickrSearchCompletionBlock)completionBlock;

+ (void)loadImageForPhoto:(PPFlickrPhotoInfo *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock)completionBlock;

+ (NSString *)flickrPhotoURLForFlickrPhoto:(PPFlickrPhotoInfo *)flickrPhoto size:(NSString *)size;

@end
