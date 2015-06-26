//
//  ViewController.m
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 25.06.2015.
//  Copyright (c) 2015 __ORGANIZATION_NAME__. All rights reserved.
//

#import "CarouselDemoViewController.h"
#import "CarouselDemoViewCell.h"
#import "UIImage+Mock.h"

@interface CarouselDemoViewController () {
    UIButton* pagesAmountChangeButton;
    UIButton* onePageModeButton;
}

@end

@implementation CarouselDemoViewController

+ (Class)carouselCellClass{
    return [CarouselDemoViewCell class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.items = @[[self imageForPage:1]];
    
    UIButton* button = nil;
    
    // Change pages amount button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Add Page (1/4)" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(onPagesAmount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    pagesAmountChangeButton = button;
    
    // Disable/Enable loop if one page only
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Disable loop for single page" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(onPageMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    onePageModeButton = button;
}

- (void)onPagesAmount:(UIButton*)sender {
    switch (sender.tag) {
        case 0:
            self.items = [self.items arrayByAddingObject:[self imageForPage:2]];
            [sender setTitle:@"Add Page (2/4)" forState:UIControlStateNormal];
            break;
        case 1:
            self.items = [self.items arrayByAddingObject:[self imageForPage:3]];
            [sender setTitle:@"Add Page (3/4)" forState:UIControlStateNormal];
            break;
        case 2:
            self.items = [self.items arrayByAddingObject:[self imageForPage:4]];
            [sender setTitle:@"Back To 1 Page (4/4)" forState:UIControlStateNormal];
            break;
        case 3:
            self.items = @[[self.items firstObject]];
            [sender setTitle:@"Add Page (1/4)" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    sender.tag = (sender.tag+1)%4;
    [self.collectionView reloadData];
}

- (void)onPageMode:(UIButton*)sender {
    if (sender.tag == 0) {
        [sender setTitle:@"Enable loop for single page" forState:UIControlStateNormal];
        sender.tag = 1;
        [(EXTCarouselFlowLayout*)self.collectionView.collectionViewLayout setDisableLoopForOneItem:YES];
    }else{
        [sender setTitle:@"Disable loop for single page" forState:UIControlStateNormal];
        sender.tag = 0;
        [(EXTCarouselFlowLayout*)self.collectionView.collectionViewLayout setDisableLoopForOneItem:NO];
    }
    [(EXTCarouselFlowLayout*)self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    pagesAmountChangeButton.frame = CGRectMake(10.0f, 20.0f, 150.0f, 20.0f);
    onePageModeButton.frame = CGRectMake(CGRectGetMaxX(pagesAmountChangeButton.frame) + 5.0f, 20.0f, 200.0f, 20.0f);
}

- (UIImage*)imageForPage:(NSInteger)index {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    size.height -= 30.0f;
    size.width -= 20.0f;
    NSString* title = [NSString stringWithFormat:@"Page %li",index];
    return [UIImage mockImageWithTitle:title size:size cornerRadius:10 borderWidth:2 textColor:[UIColor blackColor] borderColor:nil backgroundColor: index%2 ?[UIColor whiteColor] : [UIColor grayColor]];
}

@end
