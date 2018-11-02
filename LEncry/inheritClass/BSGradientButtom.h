//
//  BSGradientButtom.h
//  BloodSouvenir
//
//  Created by ponted on 2018/10/31.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSGradientButtom;
@protocol showGradientBtnDelegate <NSObject>
//delegate click action
- (void)clickGradient:(BSGradientButtom *)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BSGradientButtom : UIView

@property (nonatomic,assign) BOOL selected;

@property (nonatomic, strong) UILabel       *buttomTitleLabel;
@property (nonatomic, strong) UIImageView   *buttomEdegtImageView;

@property (nonatomic, weak) id <showGradientBtnDelegate> delegate;


/**
 show gradient buttom

 @param title           buttom title
 @param imageName       show select image
 */
- (void)showGradientButtom:(NSString *)title edgetImageName:(NSString *)imageName;


/**
 change buttom select status

 @param selected        the buttom selected status
 @param sParam          selected gradient
 @param direct          gradient direction
 */
- (void)setStatusChange:(BOOL)selected  selected:(NSDictionary *)sParam  direct:(NSInteger)direct;

@end

NS_ASSUME_NONNULL_END
