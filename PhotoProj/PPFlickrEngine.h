//
//  PPMKNetworkEngineClient.h
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "MKNetworkEngine.h"

@class PPFlickrPhotoInfo;

typedef void (^callSuccessBlock)(id responseData);
typedef void (^callErrorBlock)(NSError *error);

@interface PPFlickrEngine : MKNetworkEngine

+ (id)shareInstance;

- (void)sendRequestPath:(NSString *)path withParams:(NSDictionary *)params callSuccessBlock:(callSuccessBlock)successBlock callErrorBlock:(callErrorBlock)errorBlock;

- (void)loadImageForPhoto:(PPFlickrPhotoInfo *)photo withURLStr:(NSString *)imageURL callSuccessBlock:(callSuccessBlock)successBlock callErrorBlock:(callErrorBlock)errorBlock;

@end
