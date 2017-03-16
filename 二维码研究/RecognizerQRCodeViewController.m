//
//  RecognizerQRCodeViewController.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/9.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "RecognizerQRCodeViewController.h"
#import <SCQRCodeFramework/SCQRCodeFramework.h>

@interface RecognizerQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation RecognizerQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupImageView];
}
- (void)setupImageView
{
    NSUInteger num = arc4random_uniform(3)+11;
    UIImage *img = [UIImage imageNamed:@(num).stringValue];
    self.qrcodeImageView.image = img;
}
- (IBAction)recognizerCode
{
    [self setupImageView];

    NSString *string = SCQRCodeManager.sharedManager.qrCodeRecognizer.recognizeQRCode(self.qrcodeImageView.image);
    if (string.length == 0) {
        return;
    }
    // 弹框提示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
