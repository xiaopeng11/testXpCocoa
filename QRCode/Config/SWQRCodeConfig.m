//
//  SWQRCodeConfig.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCodeConfig.h"

@implementation SWQRCodeConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scannerCornerColor = [UIColor whiteColor];
        self.scannerBorderColor = [UIColor clearColor];
        self.indicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return self;
}

@end
