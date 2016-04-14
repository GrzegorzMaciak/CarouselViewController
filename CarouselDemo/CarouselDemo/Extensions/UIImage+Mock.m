//
//  UIImage+Mock.m
//  CarouselDemo
//
//  Created by Grzegorz Maciak on 26.06.2015.
//  Copyright (c) 2015 Grzegorz Maciak. All rights reserved.
//

#import "UIImage+Mock.h"

@implementation UIImage (Mock)

+(UIImage*)mockImageWithTitle:(NSString*)title
                         size:(CGSize)size
                 cornerRadius:(NSInteger)radius
                  borderWidth:(NSInteger)borderWidth
                    textColor:(UIColor*)textColor
                  borderColor:(UIColor*)borderColor
              backgroundColor:(UIColor*)bgColor
{
    if (size.width < 1 || size.height < 1) return nil;
    //frame
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    //view
    UIView* v = [[UIView alloc] initWithFrame:r];
    if (bgColor) v.backgroundColor = bgColor;
    v.layer.borderColor = borderColor ? borderColor.CGColor : [UIColor blackColor].CGColor;
    v.layer.borderWidth = borderWidth;
    v.layer.cornerRadius = radius;
    
    //title
    UILabel* label = [[UILabel alloc] initWithFrame:r];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor clearColor];
    if (textColor) label.textColor = textColor;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.center = v.center;
    [v addSubview:label];
    
    //image
    r = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(r.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [v.layer renderInContext:context];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
