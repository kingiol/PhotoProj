//
//  PPTableViewDetailViewController.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-18.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPViewDetailViewController.h"

@interface PPViewDetailViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareBtn;

@end

@implementation PPViewDetailViewController

@synthesize photo = _photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonClick:(UIBarButtonItem *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [tweetSheet addImage:self.photo.thumbnail];
        [self presentViewController:tweetSheet animated:YES completion:nil];

    }
}

@end
