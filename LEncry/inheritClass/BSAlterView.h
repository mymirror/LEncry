//
//  BSAlterView.h
//  BloodSouvenir
//
//  Created by ponted on 2018/10/29.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//
/*
* custom alterview with altercontroller
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^alterClickBlock)(void);

@interface BSAlterView : NSObject


/**
 custom alterview with UIAltercontroller

 @param viewController      presented viewcontroller
 @param alterTitle          alter title
 @param alterMsg            alter message
 @param actionArray         action title
 @param alterType           alter type detail see  UIAlertControllerStyle
 @param block               return action title 
 */
+(void)alertViewController:(UIViewController *)viewController alterTitle:(NSString *)alterTitle 
                   message:(NSString *)alterMsg alterAction:(NSArray <NSString *> *)actionArray 
                 alterType:(UIAlertControllerStyle)alterType block:(void(^)(NSString *actionString))block;


/**
 custom alterview

 @param inView              add into where eg viewcontroller
 @param imageName           show image name
 @param message             show tip msg
 @param block               block method 
 @Note: When using this method, the current class must be set to global otherwise the callback is invalid
 */
- (void)alterCustomInView:(id)inView showImage:(NSString *)imageName 
                  showMsg:(NSString *)message block:(alterClickBlock)block;

@end
