//
//  EXTPagedHorizontalCarouselFlowLayout.h
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 14.09.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXTCarouselViewController.h"

@interface PagedHorizontalVerticalCarouselFlowLayoutProofOfConcept : UICollectionViewLayout {
    NSMutableDictionary* layoutInformation;
    CGSize computationContentSize;
    UIEdgeInsets contentVirtualInsets;
}

@property (nonatomic) BOOL disableLoopForOneItem; // default is YES
@property (nonatomic, readonly) CGSize itemSize;

@end
