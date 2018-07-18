//
//  MBProgress+HUD.m
//  Travel_Card
//
//  Created by 王世勇 on 2017/2/24.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (HUD)

//-(void)showHUD{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = WSY(@"Loading... ");
//}

-(void)showStrHUD:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = str;

//    [hud hideAnimated:YES afterDelay:2];
}

//- (void)showHUDWindow {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//    hud.labelText = WSY(@"Initializing...");
//}

- (void)showHUDWindow: (NSString *)str {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.f];
}

//- (void)hideHUDWindow {
//    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//}
//
//-(void)showHUDWithStr: (NSString *)str {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = str;
//}
//
//-(void)cleanHUD{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//    hud.labelText = WSY(@"Cleaning...");
//    [hud hide:YES afterDelay:2.f];
//}
//
//-(void)hideHUD{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//- (void)hideNaHUD {
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//}
//
-(void)showErrorHUD:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UIImage *image = [[UIImage imageNamed:@"N_error"] imageWithTintColor:[UIColor whiteColor]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2];
}

-(void)showErrorHUDView:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *image = [[UIImage imageNamed:@"N_error"] imageWithTintColor:[UIColor whiteColor]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2];
}

////-(void)showErrorHUDWindow:(NSString *)str{
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
////
////    // Set the custom view mode to show any view.
////    hud.mode = MBProgressHUDModeCustomView;
////    // Set an image view with a checkmark.
////    UIImage *image = [[UIImage imageNamed:@"error"] imageWithTintColor:[UIColor whiteColor]];
////    hud.customView = [[UIImageView alloc] initWithImage:image];
////
////    // Looks a bit nicer if we make it square.
////
////    // Optional label text.
////    hud.labelText = str;
////    [hud hide:YES afterDelay:1.f];
////}

-(void)showSuccessHUD:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UIImage *image = [[UIImage imageNamed:@"N_success"] imageWithTintColor:[UIColor whiteColor]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2];
}

-(void)showSuccessHUDWindow:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    UIImage *image = [[UIImage imageNamed:@"N_success"] imageWithTintColor:[UIColor whiteColor]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2];
}

//-(void)showInfoFromTitle:(NSString *)str{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//
//    // Set the custom view mode to show any view.
//    hud.mode = MBProgressHUDModeCustomView;
//    // Set an image view with a checkmark.
//    UIImage *image = [[UIImage imageNamed:@"N_info"] imageWithTintColor:[UIColor whiteColor]];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
//
//    // Looks a bit nicer if we make it square.
//
//    // Optional label text.
//    hud.labelText = str;
//    [hud hide:YES afterDelay:2.f];
//}
//
//-(void)showInfoFromTitleWindow:(NSString *)str{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
//
//    // Set the custom view mode to show any view.
//    hud.mode = MBProgressHUDModeCustomView;
//    // Set an image view with a checkmark.
//    UIImage *image = [[UIImage imageNamed:@"N_info"] imageWithTintColor:[UIColor whiteColor]];
//    hud.customView = [[UIImageView alloc] initWithImage:image];
//
//    // Looks a bit nicer if we make it square.
//
//    // Optional label text.
//    hud.detailsLabelText = str;
//    hud.detailsLabelFont = [UIFont systemFontOfSize:18];
//    [hud hide:YES afterDelay:2.f];
//}



@end
