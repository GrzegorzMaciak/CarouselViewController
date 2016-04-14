//
//  EXTCarouselViewController.m
//
//  Created by Grzegorz Maciak on 24.06.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import "EXTCarouselViewController.h"
#import "PagedHorizontalVerticalCarouselFlowLayoutProofOfConcept.h"

NSString* const EXTCollectionViewElementKindCarouselBoundaryView    = @"EXTCollectionViewElementKindCarouselBoundaryView";
NSString* const EXTCollectionViewCellIdCarousel                     = @"EXTCollectionViewCarouselCell";
NSInteger const EXTCarouselTopLeftBoundaryViewIndex                 = (-1);

@implementation EXTCarouselViewController

+ (Class)carouselCellClass{
    return [EXTCarouselViewCell class];
}

+ (Class)carouselBoundaryViewClass {
    return [self carouselCellClass];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[[self class] carouselCellClass] forCellWithReuseIdentifier:EXTCollectionViewCellIdCarousel];
    [self.collectionView registerClass:[[self class] carouselBoundaryViewClass] forSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withReuseIdentifier:EXTCollectionViewElementKindCarouselBoundaryView];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<EXTCarouselReusableViewLoading> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EXTCollectionViewCellIdCarousel forIndexPath:indexPath];
    [cell reloadData:self.items[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:EXTCollectionViewElementKindCarouselBoundaryView]) {
        UICollectionReusableView<EXTCarouselReusableViewLoading> *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        if (indexPath.item == EXTCarouselTopLeftBoundaryViewIndex) {
            [view reloadData:[self.items lastObject]];
        }else{
            [view reloadData:[self.items firstObject]];
        }
        return view;
    }
    return nil;
}

#pragma mark <UIScrollViewDelegate>

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [(EXTPagedCarouselFlowLayout*)self.collectionView.collectionViewLayout scrollViewDidEndDecelerating:scrollView];
//}

@end

#pragma mark - Cell

@implementation EXTCarouselViewCell

- (void)reloadData:(id)cellData {
    // override
}

@end
