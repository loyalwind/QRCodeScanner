//
//  SCAuthorizationStatusTools.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/24.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "SCAuthorizationStatusTools.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation SCAuthorizationStatusTools
+ (void)authorizeStatusForCamera:(AuthorizeComeletion)compeletion
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未检测到您的摄像头, 请在真机上测试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
        compeletion ? compeletion(NO) : nil;
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    // 用户同意了访问相机权限
                    NSLog(@"用户同意了访问相机权限");
                    compeletion ? compeletion(YES) : nil;
                } else {
                    // 用户拒绝了访问相机权限
                    NSLog(@"用户拒绝了访问相机权限");
                    compeletion ? compeletion(NO) : nil;
                }
            });
        }];
    } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
        
        compeletion ? compeletion(YES) : nil;
        
    } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请去-> [设置 - 隐私 - 相机 - 二维码研究] 打开访问开关" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
        
        compeletion ? compeletion(NO) : nil;
    } else if (status == AVAuthorizationStatusRestricted) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"因为系统原因, 无法访问相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
        
        compeletion ? compeletion(NO) : nil;
    }
}

+ (void)authorizeStatusForPhotoLibrary:(AuthorizeComeletion)compeletion
{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                    // 用户同意了访问相册权限
                    NSLog(@"用户同意了访问相册权限");
                    compeletion ? compeletion(YES) : nil;
                } else {
                    // 用户拒绝了访问相机权限
                    NSLog(@"用户拒绝了访问相册");
                    compeletion ? compeletion(NO) : nil;
                }
            });
        }];
        
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
        compeletion ? compeletion(YES) : nil;

    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请去-> [设置 - 隐私 - 照片 - 二维码研究] 打开访问开关" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
        [alertView show];

        compeletion ? compeletion(NO) : nil;
    } else if (status == PHAuthorizationStatusRestricted) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"因为系统原因, 无法访问相册" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
        [alertView show];

        compeletion ? compeletion(NO) : nil;
    }
}
@end
