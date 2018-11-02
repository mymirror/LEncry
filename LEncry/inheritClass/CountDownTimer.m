//
//  CountDownTimer.m
//  BloodLink
//
//  Created by ponted on 2017/12/7.
//  Copyright © 2017年 Shenzhen Blood Link Medical Technology Co., Ltd. All rights reserved.
//

#import "CountDownTimer.h"

#define TOTALNUMBER 60

@implementation CountDownTimer


- (void)setTimerCountDown:(UILabel *)timeLabel
{
    timeLabel.userInteractionEnabled = NO;
    __block NSInteger number = TOTALNUMBER;
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
            timeLabel.text = [NSString stringWithFormat:@"%ld%@",number,@"s"];
        });
        
        if (number == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeLabel.userInteractionEnabled = YES;
                timeLabel.text = [NSString stringWithFormat:@"OK"];
            });
            dispatch_source_cancel(self->timer);
            self->timer = nil;
        }
        
    });
    dispatch_resume(timer);
}


- (void)cancelTimer
{
    if (timer != nil)
    {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}
@end
