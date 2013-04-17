//
//  PPFlickerPhotoInfo.h
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPFlickerPhotoInfo : NSObject

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *largeImage;

@property (nonatomic, assign) long long photoID;
@property (nonatomic, assign) NSInteger farm;
@property (nonatomic, assign) NSInteger server;
@property (nonatomic, strong) NSString *secret;

@end
