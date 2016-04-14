//
//  EXTCarouselFlowLayout.m
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 14.09.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import "EXTHorizontalCarouselFlowLayout.h"

@implementation EXTHorizontalCarouselFlowLayout

- (void)dealloc{
    EXTCRelease(layoutInformation)
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init{
    self = [super init];
    if (self) {
        layoutInformation = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return self;
}

- (void)prepareLayout {
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    _itemSize = self.collectionView.frame.size;
    
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
        computationContentSize = CGSizeMake(itemsCount*self.itemSize.width, self.itemSize.height);
        
        if (!_disableLoopForOneItem || computationContentSize.width > self.collectionView.bounds.size.width) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0.0f, self.itemSize.width, 0.0f, self.itemSize.width - 0.25f/*content size overflow*/);
        }else{
            self.collectionView.contentInset = UIEdgeInsetsZero;
        }
        
        [self prepareItemsLayout];
        [self prepareBoudaryViewsLayout];
    }else{
        computationContentSize = CGSizeZero;
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)prepareItemsLayout {
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
        if (itemsCount > 0) {
            NSMutableArray* cellsLayoutAttributes = layoutInformation[EXTCollectionViewCellIdCarousel] ?: [NSMutableArray arrayWithCapacity:itemsCount];
            [cellsLayoutAttributes removeAllObjects];
            
            UICollectionViewLayoutAttributes* layoutAttributes = nil;
            NSIndexPath* indexPath = nil;
            for (NSInteger i = 0; i < itemsCount; ++i) {
                indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                layoutAttributes.frame = CGRectMake((i)*self.itemSize.width, 0.0f, self.itemSize.width, self.itemSize.height);
                [cellsLayoutAttributes addObject:layoutAttributes];
            }
            [layoutInformation setObject:cellsLayoutAttributes forKey:EXTCollectionViewCellIdCarousel];
        }else{
            [layoutInformation removeObjectForKey:EXTCollectionViewCellIdCarousel];
        }
    }
}

- (void)prepareBoudaryViewsLayout {
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
        if (itemsCount > (_disableLoopForOneItem ? 1 : 0)) {
            UICollectionViewLayoutAttributes* layoutAttributes = nil;
            
            NSMutableArray* boundaryElementsLayoutAttributes = layoutInformation[EXTCollectionViewElementKindCarouselBoundaryView] ?: [NSMutableArray arrayWithCapacity:2];
            [boundaryElementsLayoutAttributes removeAllObjects];
            
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withIndexPath:[NSIndexPath indexPathForItem:EXTCarouselTopLeftBoundaryViewIndex inSection:0]];
            layoutAttributes.frame = CGRectMake(-self.itemSize.width, 0.0f, self.itemSize.width, self.itemSize.height);
            [boundaryElementsLayoutAttributes addObject:layoutAttributes];
            
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withIndexPath:[NSIndexPath indexPathForItem:itemsCount inSection:0]];
            layoutAttributes.frame = CGRectMake(itemsCount*self.itemSize.width, 0.0f, self.itemSize.width, self.itemSize.height);
            [boundaryElementsLayoutAttributes addObject:layoutAttributes];
            
            [layoutInformation setObject:boundaryElementsLayoutAttributes forKey:EXTCollectionViewElementKindCarouselBoundaryView];
        }else{
            [layoutInformation removeObjectForKey:EXTCollectionViewElementKindCarouselBoundaryView];
        }
    }
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributesForElementsInRect = [NSMutableArray array];
    for (NSString* key in layoutInformation) {
        NSArray* value = [layoutInformation objectForKey:key];
        for (UICollectionViewLayoutAttributes* attributes in value) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesForElementsInRect addObject:attributes];
            }
        }
    }
    return attributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return layoutInformation[EXTCollectionViewCellIdCarousel][indexPath.item];;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:EXTCollectionViewElementKindCarouselBoundaryView]) {
        return layoutInformation[EXTCollectionViewElementKindCarouselBoundaryView][indexPath.item == EXTCarouselTopLeftBoundaryViewIndex ? 0 : 1];;
    }
    return nil;
}

- (CGSize)collectionViewContentSize{
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
        if (itemsCount > 0) {
            // 0.25f content size overflow added to content size width is needed to force the collection view to ask about suplementary view displayed on right inset (collection view will not ask about attributes for objects which frame has x or y greater than content size)
            return CGSizeMake(computationContentSize.width + 0.25f/*content size overflow*/, computationContentSize.height);
        }
    }
    return CGSizeZero;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (!_disableLoopForOneItem || computationContentSize.width > self.collectionView.bounds.size.width) {
        CGPoint contentOffset = self.collectionView.contentOffset;
        if (proposedContentOffset.x < -1.0f) {
            contentOffset.x = computationContentSize.width + contentOffset.x;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.x = computationContentSize.width - self.collectionView.bounds.size.width;
        }
        else if (proposedContentOffset.x > computationContentSize.width - self.collectionView.bounds.size.width + 1.0f) {
            contentOffset.x = contentOffset.x - computationContentSize.width;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.x = 0.0f;
        }
    }
    return proposedContentOffset;
}

#pragma mark <UIScrollViewDelegate>

// Carousel loop ( an option, by default handled by -targetContentOffsetForProposedContentOffset:withScrollingVelocity: )
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!_disableLoopForOneItem || computationContentSize.width > scrollView.bounds.size.width) {
        CGPoint contentOffset = scrollView.contentOffset;
        if ((*targetContentOffset).x < -1.0f) {
            contentOffset.x = computationContentSize.width + contentOffset.x;
            [scrollView setContentOffset:contentOffset animated:NO];
            (*targetContentOffset).x = computationContentSize.width - scrollView.bounds.size.width;
        }
        else if ((*targetContentOffset).x > computationContentSize.width - scrollView.bounds.size.width + 1.0f) {
            contentOffset.x = contentOffset.x - computationContentSize.width;
            [scrollView setContentOffset:contentOffset animated:NO];
            (*targetContentOffset).x = 0.0f;
        }
    }
}

/* vsersion to past in ScrollView delegate class implementation */
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSInteger pagesCount = scrollView.contentSize.width/scrollView.bounds.size.width;
//    CGPoint contentOffset = scrollView.contentOffset;
//    if ((*targetContentOffset).x < -1.0f) {
//        contentOffset.x = (pagesCount * scrollView.bounds.size.width) + contentOffset.x;
//        [scrollView setContentOffset:contentOffset animated:NO];
//        (*targetContentOffset).x = (pagesCount - 1) * scrollView.bounds.size.width;
//    }
//    else if ((*targetContentOffset).x > scrollView.contentSize.width  - scrollView.bounds.size.width + 1.0f) {
//        contentOffset.x = contentOffset.x - (pagesCount * scrollView.bounds.size.width);
//        [scrollView setContentOffset:contentOffset animated:NO];
//        (*targetContentOffset).x = 0.0f;
//    }
//}

@end
