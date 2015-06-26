//
//  UIImage+Mock.h
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 26.06.2015.
//  Copyright (c) 2015 __ORGANIZATION_NAME__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mock)

+(UIImage*)mockImageWithTitle:(NSString*)title size:(CGSize)size cornerRadius:(NSInteger)radius borderWidth:(NSInteger)borderWidth textColor:(UIColor*)textColor borderColor:(UIColor*)borderColor backgroundColor:(UIColor*)bgColor;

@end
