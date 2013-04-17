//
//  PPMKNetworkEngineClient.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-17.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPFlickrEngine.h"

#import "PPFlickrPhotoInfo.h"

#define kFlickrHost @"api.flickr.com"

@implementation PPFlickrEngine

+ (id)shareInstance {

    static PPFlickrEngine *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PPFlickrEngine alloc] initWithHostName:kFlickrHost];
        [instance useCache];
    });
    
    return instance;
}

- (void)sendRequestPath:(NSString *)path withParams:(NSDictionary *)params callSuccessBlock:(callSuccessBlock)successBlock callErrorBlock:(callErrorBlock)errorBlock {
    
    MKNetworkOperation *operation = [self operationWithPath:path params:params httpMethod:@"GET"];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id dict = [completedOperation responseJSON];
        if ([completedOperation isCachedResponse]) {
            NSLog(@"CompletedOperation cached");
        }else {
            NSLog(@"CompletedOperation fresh");
        }
        successBlock(dict);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"%@", [error localizedDescription]);
        errorBlock(error);
    }];
    
    [self enqueueOperation:operation];
}



- (void)loadImageForPhoto:(PPFlickrPhotoInfo *)photo withURLStr:(NSString *)imageURL callSuccessBlock:(callSuccessBlock)successBlock callErrorBlock:(callErrorBlock)errorBlock {
    
    MKNetworkOperation *operation = [self operationWithURLString:imageURL params:nil httpMethod:@"GET"];

    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = [completedOperation responseData];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", photo, @"key", nil];
        successBlock(dict);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"%@", [error localizedDescription]);
        errorBlock(error);
    }];
    
    [self enqueueOperation:operation];
}

@end
