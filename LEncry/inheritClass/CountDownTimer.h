//
//  CountDownTimer.h
//  BloodLink
//
//  Created by ponted on 2017/12/7.
//  Copyright © 2017年 Shenzhen Blood Link Medical Technology Co., Ltd. All rights reserved.
//

/*
 *@function 定时器倒计时
 *@备注:setTimerCountDown 以后 记得 cancelTimer 否则有可能存在内存泄漏
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CountDownTimer : NSObject
{
    dispatch_source_t timer;
}


/**
 开启定时器倒计时
 
 @param timeLabel 显示倒计时时间
 */
- (void)setTimerCountDown:(UILabel *)timeLabel;

/**
 取消结束倒计时
 */
- (void)cancelTimer;


@end

