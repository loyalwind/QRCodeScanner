//
//  GeneratorQRCodeViewController.m
//  二维码研究
//
//  Created by 彭维剑 on 2017/2/9.
//  Copyright © 2017年 pengweijian. All rights reserved.
//

#import "GeneratorQRCodeViewController.h"
#import <SCQRCodeFramework/SCQRCodeFramework.h>

@interface GeneratorQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *qrcodeField;

@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@property (strong, nonatomic) UIColor *qrcodeBgColor;

@property (strong, nonatomic) UIColor *qrcodeDotColor;

@end

@implementation GeneratorQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self whiteBgBlackDotAction];
}
- (IBAction)whiteBgBlackDotAction {
    _qrcodeBgColor = [UIColor whiteColor];
    _qrcodeDotColor = [UIColor blackColor];
}
- (IBAction)blueBgRedDotAction {
    _qrcodeBgColor = [UIColor blueColor];
    _qrcodeDotColor = [UIColor redColor];
}
- (IBAction)generatorQRCodeAction
{
    UIImage *image = SCQRCodeManager.sharedManager.qrCodeGenerator.configQRCode(_qrcodeBgColor,_qrcodeDotColor,CGSizeZero).next.createQRCode(self.qrcodeField.text);
    self.qrcodeImageView.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

@end
