//
//  SCAuthorizationStatusTools.h
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/24.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AuthorizeComeletion) (BOOL hasAuthorized);

@interface SCAuthorizationStatusTools : NSObject

/**
 相机授权状态
 @param compeletion 回调
 */
+ (void)authorizeStatusForCamera:(AuthorizeComeletion)compeletion;

/**
 相册授权状态
 @param compeletion 回调
 */
+ (void)authorizeStatusForPhotoLibrary:(AuthorizeComeletion)compeletion;

@end
