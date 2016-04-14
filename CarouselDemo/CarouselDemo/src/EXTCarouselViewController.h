//
//  EXTCarouselViewController.h
//
//  Created by Grzegorz Maciak on 24.06.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license:

// Copyright (c) 2015 Grzegorz Maciak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString* const EXTCollectionViewElementKindCarouselBoundaryView;
FOUNDATION_EXPORT NSString* const EXTCollectionViewCellIdCarousel;
FOUNDATION_EXPORT NSInteger const EXTCarouselTopLeftBoundaryViewIndex;

@interface EXTCarouselViewController : UICollectionViewController

+ (Class)carouselCellClass;

@property(nonatomic,readwrite,retain) NSArray* items;

@end


#pragma mark - Reusable view

/** Protocol which must be implemented in each carousel cell */
@protocol EXTCarouselReusableViewLoading <NSObject>

- (void)reloadData:(id)cellData;

@end

#pragma mark - Cell

@interface EXTCarouselViewCell : UICollectionViewCell <EXTCarouselReusableViewLoading>

@end

#if ! __has_feature(objc_arc)
    #define EXTCAutorelease(__v) ([__v autorelease]);
    #define EXTCReturnAutoreleased EXTCAutorelease

    #define EXTCRetain(__v) ([__v retain]);
    #define EXTCReturnRetained EXTCRetain

    #define EXTCRelease(__v) ([__v release]);

    #define EXTCDispatchQueueRelease(__v) (dispatch_release(__v));
#else
    // -fobjc-arc
    #define EXTCAutorelease(__v)
    #define EXTCReturnAutoreleased(__v) (__v)

    #define EXTCRetain(__v)
    #define EXTCReturnRetained(__v) (__v)

    #define EXTCRelease(__v)

// If OS_OBJECT_USE_OBJC=1, then the dispatch objects will be treated like ObjC objects
// and will participate in ARC.
// See the section on "Dispatch Queues and Automatic Reference Counting" in "Grand Central Dispatch (GCD) Reference" for details.
    #if OS_OBJECT_USE_OBJC
        #define EXTCDispatchQueueRelease(__v)
    #else
        #define EXTCDispatchQueueRelease(__v) (dispatch_release(__v));
    #endif
#endif
