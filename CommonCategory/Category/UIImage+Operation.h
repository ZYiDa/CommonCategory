//
//  UIImage+Operation.h
//  CommonCategory
//
//  Created by 立元通信 on 2018/5/7.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (Operation)

/*
 *sampleBuffer数据转化为image
 */
+ (UIImage *)convertSampleBufferToUIImageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*
 *旋转图片为正常的竖直方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/*
 *裁剪指定范围内的image
 */
+ (UIImage*)getSubImage:(UIImage *)image withRect:(CGRect)rect;

/*
 *image拼接
 */
+ (UIImage *)firstComposeWithOldImage:(UIImage *)oldImage newImage:(UIImage *)newImage;
@end
