//
//  PPViewController.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-16.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPViewController.h"

#import "PPFlickInterface.h"
#import "PPFlickrTableViewCell.h"
#import "PPFlickrPhotoInfo.h"

@interface PPViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *datasource;
}

@property (nonatomic, strong) PPFlickInterface *flickrInterface;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation PPViewController

@synthesize flickrInterface = _flickrInterface;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
       
}

- (PPFlickInterface *)flickrInterface {
    if (_flickrInterface == nil) {
        _flickrInterface = [[PPFlickInterface alloc] init];
    }
    return _flickrInterface;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *str = [searchBar text];

    [self.flickrInterface searchFlickForTerm:str completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        datasource = results;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UITableView

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPFlickrTableViewCell *cell = (PPFlickrTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    
    PPFlickrPhotoInfo *photoInfo = [datasource objectAtIndex:indexPath.row];
    cell.flickPhotoImageView.image = photoInfo.thumbnail;
    cell.flickPhotoTitle.text = photoInfo.tiltle;

    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UICollectionView

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionViewDelegateFlowLayout

@end
