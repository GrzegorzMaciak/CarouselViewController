//
//  EXTCarouselFlowLayout.h
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 14.09.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXTCarouselViewController.h"

/** Collection view layout for horizontal paged carousel.
 
 Approach used in the class does not work for vertical scrolling, we cannot use analogical code to support it on iOS 8 either 9.
 */

@interface EXTHorizontalCarouselFlowLayout : UICollectionViewLayout {
    NSMutableDictionary* layoutInformation;
    CGSize computationContentSize;
}

@property(nonatomic,readonly) CGSize itemSize;
@property(nonatomic,readwrite,assign) BOOL disableLoopForOneItem; // default is YES

@end
