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
#import "PPViewDetailViewController.h"
#import "PPCollectionViewCell.h"

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
//    [self.collectionView setAllowsMultipleSelection:YES];
    
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

- (IBAction)segmentControlClick:(UISegmentedControl *)sender {
    NSUInteger clickIndex = sender.selectedSegmentIndex;
    if (clickIndex == 0) {  //列表
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else if (clickIndex == 1) {    //图表
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *str = [searchBar text];

    [self.flickrInterface searchFlickForTerm:str completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        datasource = results;
        NSUInteger segmentIndex = self.segmentControl.selectedSegmentIndex;
        if (segmentIndex == 0) {
            [self.tableView reloadData];
        }else if (segmentIndex == 1) {
            [self.collectionView reloadData];
        }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"collection count");
    return [datasource count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPCollectionViewCell *cell = (PPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    PPFlickrPhotoInfo *photo = [datasource objectAtIndex:indexPath.row];
    cell.photoImageView.image = photo.thumbnail;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PPFlickrPhotoInfo *photo = [datasource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"collectionViewSegue" sender:photo];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index:%d deselect", indexPath.row);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140., 140.);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifier = segue.identifier;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    PPFlickrPhotoInfo *photo = nil;
    if ([segueIdentifier isEqualToString:@"tableViewCellSegue"]) {
        NSUInteger row = [self.tableView indexPathForSelectedRow].row;
        photo = [datasource objectAtIndex:row];
    }else if ([segueIdentifier isEqualToString:@"collectionViewSegue"]) {
        photo = sender;
    }
    
    [PPFlickInterface loadImageForPhoto:photo thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
        PPViewDetailViewController *detailController = segue.destinationViewController;
        if ([segueIdentifier isEqualToString:@"tableViewCellSegue"]) {
            PPFlickrTableViewCell *cell = (PPFlickrTableViewCell *)sender;
            detailController.title = cell.flickPhotoTitle.text;
        }else if ([segueIdentifier isEqualToString:@"collectionViewSegue"]) {
            detailController.title = ((PPFlickrPhotoInfo *)sender).tiltle;
        }
        UIImageView *imageView = (UIImageView *)[detailController.view viewWithTag:1];
        imageView.image = photoImage;
        detailController.photo = photo;
        [SVProgressHUD dismiss];
    }];
}

@end
