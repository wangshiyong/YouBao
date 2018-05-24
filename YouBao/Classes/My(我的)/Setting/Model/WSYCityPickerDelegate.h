//
//  WSYCityPickerDelegate.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSYCityModel;
@class WSYCityPickerViewController;

@protocol WSYCityPickerDelegate <NSObject>

- (void) cityPickerController:(WSYCityPickerViewController *)cityPickerViewController
                didSelectCity:(WSYCityModel *)city;

//- (void) cityPickerControllerDidCancel:(WSYCityPickerViewController *)cityPickerViewController;

@end

@protocol WSYCityGroupCellDelegate <NSObject>

- (void) cityGroupCellDidSelectCity:(WSYCityModel *)city;

@end
