//
//  PPCollectionViewCell.m
//  PhotoProj
//
//  Created by Kingiol on 13-4-18.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "PPCollectionViewCell.h"

@implementation PPCollectionViewCell

@synthesize photoImageView = _photoImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        self.selectedBackgroundView = bgView;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
