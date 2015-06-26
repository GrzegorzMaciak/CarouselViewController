//
//  CarouselViewCell.m
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 26.06.2015.
//  Copyright (c) 2015 __ORGANIZATION_NAME__. All rights reserved.
//

#import "CarouselDemoViewCell.h"

@implementation CarouselDemoViewCell
- (void)reloadData:(id)cellData {
    for (UIView* view in [self.contentView.subviews copy]) {
        [view removeFromSuperview];
    }
    UIImageView* imageView = [[UIImageView alloc] initWithImage:cellData];
    imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    imageView.frame = self.contentView.bounds;
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth = 1.0f;
}
@end
