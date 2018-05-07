//
//  UIImage+Operation.m
//  CommonCategory
//
//  Created by 立元通信 on 2018/5/7.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "UIImage+Operation.h"

@implementation UIImage (Operation)

/*
 *sampleBuffer数据转化为image
 */
+ (UIImage *)convertSampleBufferToUIImageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    UIImage *image = nil;
    
    CVImageBufferRef imageBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer);
    if (nil == imageBuffer)
        return image;
    
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess){
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        
        if (nil != rgbColorSpace){
            
            void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
            
            if (nil != baseAddress) {
                
                size_t width = CVPixelBufferGetWidth(imageBuffer);
                size_t height = CVPixelBufferGetHeight(imageBuffer);
                size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
                size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
                
                CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                                          baseAddress,
                                                                          bufferSize, NULL);
                if (nil != provider){
                    CGImageRef cgImage = CGImageCreate(width,
                                                       height,
                                                       8,
                                                       32,
                                                       bytesPerRow,
                                                       rgbColorSpace,
                                                       kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little,
                                                       provider,
                                                       NULL,
                                                       true,
                                                       kCGRenderingIntentDefault);
                    
                    if (nil != cgImage) {
                        
                        image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationRight];
                        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
                        image = [UIImage imageWithData:imageData];
                        CGImageRelease(cgImage);
                    }
                    CGDataProviderRelease(provider);
                }
            }
            CGColorSpaceRelease(rgbColorSpace);
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    return image;
}

/*
 *旋转图片为正常的竖直方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

/*
 *裁剪指定范围内的image
 */
+ (UIImage*)getSubImage:(UIImage *)image withRect:(CGRect)rect
{
    CGFloat w = CGRectGetWidth(rect);
    CGFloat h = CGRectGetHeight(rect);
    if ((w > image.size.width || w <= 0 ) || (h > image.size.height || h <= 0)) {
        return [UIImage new];
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    //每次截取完成后 释放资源
    CGContextRelease(context);
    CGImageRelease(subImageRef);
    
    return smallImage;
}

/*
 *image拼接
 */
+ (UIImage *)firstComposeWithOldImage:(UIImage *)oldImage newImage:(UIImage *)newImage
{
    UIImage *composeImage = nil;
    CGSize sizeOfOld = oldImage.size;
    CGSize sizeOfNext = newImage.size;
    CGSize newSize = CGSizeMake(sizeOfOld.width + sizeOfNext.width, sizeOfOld.height);
    UIGraphicsBeginImageContext(newSize);
    [oldImage drawInRect:CGRectMake(0,
                                    0,
                                    sizeOfOld.width, sizeOfOld.height)
               blendMode:kCGBlendModeNormal
                   alpha:1.0f];
    [newImage drawInRect:CGRectMake(sizeOfOld.width,
                                    0,
                                    sizeOfNext.width,
                                    sizeOfNext.height) blendMode:kCGBlendModeNormal alpha:1.0f];
    composeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return composeImage;
}

@end
