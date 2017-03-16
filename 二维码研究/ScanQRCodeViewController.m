//
//  ScanQRCodeViewController.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/9.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <SCQRCodeFramework/SCQRCodeFramework.h>

@interface ScanQRCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) SCQRCodeScanner *scanner;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    SCQRCodeScanner *scanner = [[SCQRCodeScanner alloc] initWithPreviewFrame:self.view.bounds];
    [self.view insertSubview:scanner.preview atIndex:0];
    // 设置扫描识别区域
    scanner.preview.rectOfPierce = CGRectMake((self.view.bounds.size.width-250)*0.5, (self.view.bounds.size.height-250)*0.3, 250, 250);
    _scanner = scanner;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPhotoLibrary)];
}

- (IBAction)openFlightAction
{
    _scanner.deviceTorchOn = !_scanner.isDeviceTorchOn;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
    } else {
        NSLog(@"保存成功");
    }
}

- (IBAction)switchBigAreaAction {
    
    [_scanner switchToRectOfPierce:CGRectMake(100, 150, 250 ,350)];
}

- (IBAction)switchSmallAreaAction {
    [_scanner switchToRectOfPierce:CGRectMake((self.view.bounds.size.width-250)*0.5, (self.view.bounds.size.height-250)*0.3, 250, 250)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 5.开始扫描
    [_scanner startScanCompeletion:^(NSString * _Nullable qrcodeString) {
        NSLog(@"扫描结果：%@",qrcodeString);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 6.停止扫描
    [_scanner stoptScan];
}
- (void)gotoPhotoLibrary
{
    [SCAuthorizationStatusTools authorizeStatusForPhotoLibrary:^(BOOL hasAuthorized) {
        if (hasAuthorized) {
            // 创建对象
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //（选择类型）表示仅仅从相册中选取照片
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *qrcodeText = SCQRCodeManager.sharedManager.qrCodeRecognizer.recognizeQRCode(image);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"识别结果" message:qrcodeText delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil, nil];
        [alertView show];
    }];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
