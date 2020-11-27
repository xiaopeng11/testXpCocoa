//
//  SWQRCodeManager.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCodeManager.h"
#import <Photos/PHPhotoLibrary.h>

@implementation SWQRCodeManager

/** 校验是否有相机权限 */
+ (void)sw_checkCameraAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (videoAuthStatus) {
        // 已授权
        case AVAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
        // 未询问用户是否授权
        case AVAuthorizationStatusNotDetermined:
        {
            // 提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                permissionGranted(granted);
            }];
        }
            break;
        // 用户拒绝授权或权限受限
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请在”设置-隐私-相机”选项中，允许访问你的相机" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"去授权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [alert addAction:cancel];
            [[self dc_getCurrentVC] presentViewController:alert animated:YES completion:nil];

            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
}

/** 校验是否有相册权限 */
+ (void)sw_checkAlbumAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted {
    
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        // 已授权
        case PHAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
        // 未询问用户是否授权
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                permissionGranted(status == PHAuthorizationStatusAuthorized);
            }];
        }
            break;
        // 用户拒绝授权或权限受限
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"APP不能获取您的照片权限，无法继续哦!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"去授权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [alert addAction:cancel];
            [[self dc_getCurrentVC] presentViewController:alert animated:YES completion:nil];
            
            
            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
    
}

/** 根据扫描器类型配置支持编码格式 */
+ (NSArray *)sw_metadataObjectTypesWithType:(SWScannerType)scannerType {
    switch (scannerType) {
        case SWScannerTypeQRCode:
        {
            return @[AVMetadataObjectTypeQRCode];
        }
            break;
        case SWScannerTypeBarCode:
        {
            return @[AVMetadataObjectTypeEAN13Code,
                     AVMetadataObjectTypeEAN8Code,
                     AVMetadataObjectTypeUPCECode,
                     AVMetadataObjectTypeCode39Code,
                     AVMetadataObjectTypeCode39Mod43Code,
                     AVMetadataObjectTypeCode93Code,
                     AVMetadataObjectTypeCode128Code,
                     AVMetadataObjectTypePDF417Code];
        }
            break;
        case SWScannerTypeBoth:
        {
            return @[AVMetadataObjectTypeQRCode,
                     AVMetadataObjectTypeEAN13Code,
                     AVMetadataObjectTypeEAN8Code,
                     AVMetadataObjectTypeUPCECode,
                     AVMetadataObjectTypeCode39Code,
                     AVMetadataObjectTypeCode39Mod43Code,
                     AVMetadataObjectTypeCode93Code,
                     AVMetadataObjectTypeCode128Code,
                     AVMetadataObjectTypePDF417Code];
        }
            break;
        default:
            break;
    }
}

/** 根据扫描器类型配置导航栏标题 */
+ (NSString *)sw_navigationItemTitleWithType:(SWScannerType)scannerType {
    switch (scannerType) {
        case SWScannerTypeQRCode:
        {
            return @"二维码";
        }
            break;
        case SWScannerTypeBarCode:
        {
            return @"条码";
        }
            break;
        case SWScannerTypeBoth:
        {
            return @"二维码/条码";
        }
            break;
        default:
            break;
    }
}

/** 手电筒开关 */
+ (void)sw_FlashlightOn:(BOOL)on {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCapturePhotoSettings *setting = [[AVCapturePhotoSettings alloc] init];
    if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
        [captureDevice lockForConfiguration:nil];
        if (on) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            setting.flashMode = AVCaptureFlashModeOn;
        } else {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            setting.flashMode = AVCaptureFlashModeOff;
        }
        [captureDevice unlockForConfiguration];
    }
}

#pragma mark - 获取当前控制器
+ (UIViewController *)dc_getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
