//
//  BSNoCopyTextField.m
//  BloodSouvenir
//
//  Created by ponted on 2018/10/26.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//

#import "BSNoCopyTextField.h"

@implementation BSNoCopyTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialzation code
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
    //设置为不可用
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
