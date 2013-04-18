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
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation PPViewController

@synthesize flickrInterface = _flickrInterface;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.segmentControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
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

- (void)dealloc {
    datasource = nil;
}

#pragma mark - Target

- (void)segmentControlClick:(UISegmentedControl *)sender {
    NSUInteger clickIndex = sender.selectedSegmentIndex;
    if (clickIndex == 0) {  //列表
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
    }else if (clickIndex == 1) {    //图表
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap accessor");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PPFlickrTableViewCell *cell = (PPFlickrTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"title:%@", cell.flickPhotoTitle.text);
}

#pragma mark - UICollectionView

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    if ([segueIdentifier isEqualToString:@"tableViewCellSegue"]) {
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        PPFlickrPhotoInfo *photo = [datasource objectAtIndex:row];
        [PPFlickInterface loadImageForPhoto:photo thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
            PPFlickrTableViewCell *cell = (PPFlickrTableViewCell *)sender;
            UIViewController *detailController = segue.destinationViewController;
            detailController.title = cell.flickPhotoTitle.text;
            UIImageView *imageView = (UIImageView *)[detailController.view viewWithTag:1];
            imageView.image = photoImage;
        }];
    }
}

@end
