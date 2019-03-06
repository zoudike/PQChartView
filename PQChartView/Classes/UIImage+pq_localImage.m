//
//  UIImage+pq_localImage.m
//  Pods
//
//  Created by wenpq on 2019/3/6.
//

#import "UIImage+pq_localImage.h"

@implementation UIImage (pq_localImage)

+ (UIImage *)pq_localImageName:(NSString *)imageName {
    NSString *suffix = @"";
    if ([UIScreen mainScreen].scale == 2.0) {
        suffix = @"@2x";
    } else if ([UIScreen mainScreen].scale == 3.0) {
        suffix = @"@3x";
    }
    NSString *localImageName = [NSString stringWithFormat:@"%@%@",imageName,suffix];
    NSBundle *currentBundle = [NSBundle bundleForClass:NSClassFromString(@"PQChartView")];
    NSString *currentBundleName = currentBundle.infoDictionary[@"CFBundleName"];
    NSString *imagePath = [currentBundle pathForResource:localImageName ofType:@"png" inDirectory:[NSString stringWithFormat:@"%@.bundle",currentBundleName]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
