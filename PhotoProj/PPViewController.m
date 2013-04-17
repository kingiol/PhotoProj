//
//  PPViewController.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-16.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPViewController.h"

#import "PPFlickInterface.h"

@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PPFlickInterface *client = [[PPFlickInterface alloc] init];
    
    [client searchFlickForTerm:@"dog" completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        NSLog(@"count:%d", [results count]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
