//
//  EXTPagedCarouselFlowLayout.h
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 08.10.2015.
//  Copyright © 2015 Grzegorz Maciak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXTCarouselViewController.h"

@interface EXTPagedCarouselFlowLayout : UICollectionViewLayout {
    NSMutableDictionary* layoutInformation;
    CGSize computationContentSize;
    UIEdgeInsets contentVirtualInsets;
}

@property (nonatomic) BOOL disableLoopForOneItem; // default is YES
@property (nonatomic, readonly) CGSize itemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionHorizontal

@end
