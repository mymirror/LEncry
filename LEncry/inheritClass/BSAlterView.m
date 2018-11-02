//
//  BSAlterView.m
//  BloodSouvenir
//
//  Created by ponted on 2018/10/29.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//

#import "BSAlterView.h"

@interface BSAlterView()
{
    alterClickBlock clickBlock;
    UIView *ownView;
    dispatch_source_t timer;// count down timer
}

@end

@implementation BSAlterView


+(void)alertViewController:(UIViewController *)viewController alterTitle:(NSString *)alterTitle message:(NSString *)alterMsg
 alterAction:(NSArray<NSString *> *)actionArray alterType:(UIAlertControllerStyle)alterType block:(void(^)(NSString *actionString))block
{
    __weak typeof(viewController) presentVC = viewController;
    
    UIAlertController *alterCtr = [UIAlertController alertControllerWithTitle:alterTitle message:alterMsg preferredStyle:alterType];
    // add more action
    for (NSString *str in actionArray) {
            UIAlertAction *aciton = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (block) {
                        block(str);
                    }
            }];
            [alterCtr addAction:aciton];
    }
    
    //展示
    dispatch_async(dispatch_get_main_queue(), ^{
        [presentVC presentViewController:alterCtr animated:YES completion:nil];
    });
    
}

#pragma mark -- add custom alterview
- (void)alterCustomInView:(id)inView showImage:(NSString *)imageName showMsg:(NSString *)message block:(alterClickBlock)block
{
    if (block) {
        clickBlock = block;
    }
    if (ownView == nil) {
        ownView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    ownView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    if ([inView isKindOfClass:[UIView class]]) {
        [inView addSubview:ownView];
    }
    if ([inView isKindOfClass:[UIViewController class]]) {
        UIViewController *vv = (UIViewController *)inView;
        [vv.view addSubview:ownView];
    }
    
    UIView *subview = [[UIView alloc]init];
    subview.backgroundColor = [UIColor whiteColor];
    [ownView addSubview:subview];
    
    //add imageview
    UIImageView *showImageview = [[UIImageView alloc]init];
    [showImageview setImage:[UIImage imageNamed:ImagePath(imageName)]];
    [ownView addSubview:showImageview];
    
    [showImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MAIN_SCREEN_HEIGHT_SCALE*164);
        make.centerX.mas_equalTo(self->ownView.mas_centerX);
        make.width.mas_equalTo(showImageview.image.size.width);
        make.height.mas_equalTo(showImageview.image.size.height);
    }];
    
    // add tip msg
    UILabel *label = [[UILabel alloc]init];
    label.textColor = HEXCOLOR(0x333333);
    label.font = KFont(20);
    label.text = message;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [ownView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH_SCALE*94.5);
        make.top.mas_equalTo(showImageview.mas_bottom).with.offset(MAIN_SCREEN_HEIGHT_SCALE*20);
        make.right.mas_equalTo(-MAIN_SCREEN_WIDTH_SCALE*94.5);
    }];
    
    // add back action
    UILabel *backLabel = [[UILabel alloc]init];
    backLabel.textColor = HEXCOLOR(0xffffff);
    backLabel.font = KFont(17);
    backLabel.text = @"5s返回";
    backLabel.userInteractionEnabled = YES;
    backLabel.textAlignment = NSTextAlignmentCenter;
    [ownView addSubview:backLabel];
    
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).with.offset(MAIN_SCREEN_HEIGHT_SCALE*40);
        make.right.mas_equalTo(-MAIN_SCREEN_WIDTH_SCALE*88);
        make.height.mas_equalTo(MAIN_SCREEN_HEIGHT_SCALE*44);
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH_SCALE*88);
    }];
    
    UIControl *ctr = [[UIControl alloc]init];
    [ctr addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [ownView addSubview:ctr];
    
    [ctr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backLabel);
    }];
    
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(showImageview.mas_top).with.offset(-MAIN_SCREEN_HEIGHT_SCALE*5);
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH_SCALE*44);
        make.right.mas_equalTo(-MAIN_SCREEN_WIDTH_SCALE*44);
        make.bottom.mas_equalTo(backLabel.mas_bottom).with.offset(MAIN_SCREEN_HEIGHT_SCALE*30);
    }];
    
    [ownView layoutIfNeeded];
    
    [backLabel setGradientView:@{@"0.1":HEXCOLOR(0xF3AA80),@"0.4":HEXCOLOR(0xF09161),@"0.9":HEXCOLOR(0xEC6B36)} direction:GradientLayerDirectionHorizon];
    [backLabel setViewCornerRadias:UIRectCornerAllCorners radias:MAIN_SCREEN_HEIGHT_SCALE*22];
    [subview setViewCornerRadias:UIRectCornerAllCorners radias:10];
    
    [self setTimerCountDown:backLabel];
    
}
// block method
- (void)clickAction
{
    if (timer != nil)
    {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    [ownView removeFromSuperview];
    ownView = nil;
    clickBlock();
}


- (void)setTimerCountDown:(UILabel *)timeLabel
{
    __block NSInteger number = 6;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //倒叙数数
    if(timer == nil)
    {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        number --;
        dispatch_async(dispatch_get_main_queue(), ^{
            timeLabel.text = [NSString stringWithFormat:@"%lds返回",number];
        });
        
        if (number == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [weakSelf clickAction];
            });
            if(self->timer != nil)
            {
                dispatch_source_cancel(self->timer);
                self->timer = nil;
            }
        }
        
    });
    dispatch_resume(timer);
}

@end
