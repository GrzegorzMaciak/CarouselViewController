//
//  EXTCarouselViewController.m
//
//  Created by Grzegorz Maciak on 24.06.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import "EXTCarouselViewController.h"

#if !__has_feature(objc_arc)
#error EXTCarouselViewController must be built without ARC.
// You can turn off ARC for the file by adding -fno-objc-arc compiler flag to the build phase for EXTCarouselViewController.m.
#endif

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
        if (indexPath.item == EXTCarouselLeftBoundaryViewIndex) {
            [view reloadData:[self.items lastObject]];
        }else{
            [view reloadData:[self.items firstObject]];
        }
        return view;
    }
    return nil;
}

#pragma mark <UIScrollViewDelegate>

// Carousel loop
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [(EXTCarouselFlowLayout*)self.collectionView.collectionViewLayout scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

@end

#pragma mark - Layout

NSString* const EXTCollectionViewElementKindCarouselBoundaryView    = @"EXTCollectionViewElementKindCarouselBoundaryView";
NSString* const EXTCollectionViewCellIdCarousel                     = @"EXTCollectionViewCarouselCell";
NSInteger const EXTCarouselLeftBoundaryViewIndex                    = (-1);

@implementation EXTCarouselFlowLayout

- (void)dealloc{
    [layoutInformation release];
    [super dealloc];
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
            
            layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:EXTCollectionViewElementKindCarouselBoundaryView withIndexPath:[NSIndexPath indexPathForItem:EXTCarouselLeftBoundaryViewIndex inSection:0]];
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
        return layoutInformation[EXTCollectionViewElementKindCarouselBoundaryView][indexPath.item == EXTCarouselLeftBoundaryViewIndex ? 0 : 1];;
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

#pragma mark <UIScrollViewDelegate>

// Carousel loop
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

#pragma mark - Cell

@implementation EXTCarouselViewCell

- (void)reloadData:(id)cellData {
    // override
}

@end
