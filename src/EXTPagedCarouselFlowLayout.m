//
//  EXTPagedCarouselFlowLayout.m
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 08.10.2015.
//  Copyright © 2015 Grzegorz Maciak. All rights reserved.
//

#import "EXTPagedCarouselFlowLayout.h"

@implementation EXTPagedCarouselFlowLayout

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
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    
    _itemSize = self.collectionView.frame.size;
    
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    if (sectionsCount > 0) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
        computationContentSize = CGSizeMake(itemsCount*self.itemSize.width, self.itemSize.height);
        
        
        if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            computationContentSize = CGSizeMake(itemsCount*self.itemSize.width, self.itemSize.height);
            if (!_disableLoopForOneItem || computationContentSize.width > self.collectionView.bounds.size.width) {
                contentVirtualInsets = UIEdgeInsetsMake(0.0f, self.itemSize.width, 0.0f, self.itemSize.width);
            }else{
                contentVirtualInsets = UIEdgeInsetsZero;
            }
            
        }else{
            computationContentSize = CGSizeMake(self.itemSize.width, itemsCount*self.itemSize.height);
            if (!_disableLoopForOneItem || computationContentSize.height > self.collectionView.bounds.size.height) {
                contentVirtualInsets = UIEdgeInsetsMake(self.itemSize.height, 0.0f, self.itemSize.height, 0.0f);
            }else{
                contentVirtualInsets = UIEdgeInsetsZero;
            }
        }
        
        [self prepareItemsLayout];
        [self prepareBoudaryViewsLayout];
    }else{
        computationContentSize = CGSizeZero;
        contentVirtualInsets = UIEdgeInsetsZero;
    }
    self.collectionView.contentOffset = CGPointMake(contentVirtualInsets.left, contentVirtualInsets.top);
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
                if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                    layoutAttributes.frame = CGRectMake((i+1)*self.itemSize.width, 0.0f, self.itemSize.width, self.itemSize.height);
                }else{
                    layoutAttributes.frame = CGRectMake(0.0f, (i+1)*self.itemSize.height, self.itemSize.width, self.itemSize.height);
                }
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
        // if loop is disabled for one item collection there is no need to layout baudary views because they are not used
        if (itemsCount > (_disableLoopForOneItem ? 1 : 0)) {
            UICollectionViewLayoutAttributes* layoutAttributes = nil;
            
            NSMutableArray* boundaryElementsLayoutAttributes = layoutInformation[EXTCollectionViewElementKindCarouselBoundaryView] ?: [NSMutableArray arrayWithCapacity:2];
            [boundaryElementsLayoutAttributes removeAllObjects];
            
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withIndexPath:[NSIndexPath indexPathForItem: EXTCarouselTopLeftBoundaryViewIndex inSection:0]];
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                layoutAttributes.frame = CGRectMake(0.0f, 0.0f, self.itemSize.width, self.itemSize.height);
            }else{
                layoutAttributes.frame = CGRectMake(0.0f, 0.0f, self.itemSize.width, self.itemSize.height);
            }
            [boundaryElementsLayoutAttributes addObject:layoutAttributes];
            
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withIndexPath:[NSIndexPath indexPathForItem:itemsCount inSection:0]];
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                layoutAttributes.frame = CGRectMake((itemsCount+1)*self.itemSize.width, 0.0f, self.itemSize.width, self.itemSize.height);
            }else{
                layoutAttributes.frame = CGRectMake(0.0f, (itemsCount+1)*self.itemSize.height, self.itemSize.width, self.itemSize.height);
            }
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
            // 0.25f content size overflow added to content size width/height is needed to force the collection view to ask about suplementary view displayed on right inset (collection view will not ask about attributes for objects which frame has x or y greater than content size)
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                return CGSizeMake(computationContentSize.width + 2.0f*computationContentSize.width /*boundary views space*/, computationContentSize.height);
            }
            return CGSizeMake(computationContentSize.width, computationContentSize.height + 2.0f*computationContentSize.height /*boundary views space*/);
        }
    }
    return CGSizeZero;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint contentOffset = self.collectionView.contentOffset;
    if (_scrollDirection == UICollectionViewScrollDirectionHorizontal && (!_disableLoopForOneItem || computationContentSize.width > 3.0f*_itemSize.width)) {
        if (proposedContentOffset.x < _itemSize.width) {
            contentOffset.x = computationContentSize.width + contentOffset.x;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.x = computationContentSize.width - _itemSize.width;
        }
        else if (proposedContentOffset.x > computationContentSize.width - _itemSize.width + 1.0f) {
            contentOffset.x = contentOffset.x - computationContentSize.width + _itemSize.width;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.x = _itemSize.width;
        }
    }
    // Code analogical to above does not work for vertical scrolling on iOS 8 and 9. We need another approach
    else if (!_disableLoopForOneItem || computationContentSize.height > 3.0f*_itemSize.height) {
        if (proposedContentOffset.y < _itemSize.height) {
            contentOffset.y = computationContentSize.height + contentOffset.y;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.y = computationContentSize.height - _itemSize.height;
        }
        else if (proposedContentOffset.y > computationContentSize.height - _itemSize.height + 1.0f) {
            contentOffset.y = contentOffset.y - computationContentSize.height + _itemSize.height;
            [self.collectionView setContentOffset:contentOffset animated:NO];
            proposedContentOffset.y = _itemSize.height;
        }
    }else{
        
    }
    return proposedContentOffset;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.collectionView.contentOffset.y < 0) {
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, 0.0f);
        }
    }
}

@end
