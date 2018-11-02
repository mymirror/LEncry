    //
    //  BSCodeInputView.m
    //  BloodSouvenir
    //
    //  Created by ponted on 2018/10/26.
    //  Copyright © 2018 xuezhiyuan. All rights reserved.
    //

#import "BSCodeInputView.h"
#import "BSClickView.h"
#import "BSNoCopyTextField.h"

@interface BSCodeInputView()<UITextFieldDelegate>
{
    NSMutableArray *lineArray;
    NSMutableArray *labelArray;
    BSNoCopyTextField *textView;
}

@end

@implementation BSCodeInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initDefaultSettings];
    }
    return self;
}
    
- (void)initDefaultSettings
{
    _codeSelectColor = [UIColor redColor];
    _unSelectColor = [UIColor clearColor];
    lineArray = [NSMutableArray array];
    labelArray = [NSMutableArray array];
    _maxCodelenth = (NSInteger)((CGRectGetWidth(self.frame)-10)/CGRectGetHeight(self.frame));//默认是codeInputView的width和height的比例
    _keyboardType = UIKeyboardTypeNumberPad;//默认是数字
}

    
- (void)initCreateCodeInput
{
    
    if (_maxCodelenth<2) 
    {
        //不符合设置codeInput条件
        return;
    }
    textView = [[BSNoCopyTextField alloc]initWithFrame:self.bounds];
    textView.delegate = self;
    textView.keyboardType = self.keyboardType;
    [self addSubview:textView];
    [textView addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //textviewz遮罩
    BSClickView *textBgView = [[BSClickView alloc]initWithFrame:self.bounds];
    textBgView.backgroundColor = self.backgroundColor;
    [self addSubview:textBgView];
    
    //设置显示框
    CGFloat padding = (CGRectGetWidth(self.frame)-_maxCodelenth*CGRectGetHeight(self.frame))/(_maxCodelenth-1);
    
    for (NSInteger i = 0; i<_maxCodelenth; i++) 
    {
        UILabel *label = [[UILabel alloc]init];
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        label.layer.borderWidth = 0.5; 
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(38);
        label.layer.cornerRadius = CGRectGetHeight(self.frame)/9;
        label.layer.masksToBounds = YES;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(CGRectGetHeight(self.frame));
            make.height.mas_equalTo(CGRectGetHeight(self.frame));
            make.left.mas_equalTo((CGRectGetHeight(self.frame)+padding)*i);
            make.top.mas_equalTo(0);
        }];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetHeight(self.frame)-2)/2.0, 5, 2, CGRectGetHeight(self.frame)-10)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor = [UIColor redColor].CGColor;
        [label.layer addSublayer:line];
        
        if (i == 0) {//初始化第一个view为选择状态
            label.layer.borderColor = _codeSelectColor.CGColor;
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            line.hidden = NO;
        }else{
            label.layer.borderColor = _unSelectColor.CGColor;
            line.hidden = YES;
        }
        
        [lineArray addObject:line];
        [labelArray addObject:label];
    }
    
    [textView becomeFirstResponder];
    
}

#pragma mark --  textField method
- (void)textFieldChanged:(UITextField *)textField
{
    NSString *codeStr = textField.text;
    //处理获取的内容 内容大于max，则结束编辑
    if (codeStr.length>_maxCodelenth)
    {
        codeStr = [codeStr substringToIndex:_maxCodelenth];
    }
    
    for (NSInteger i = 0; i<labelArray.count; i++) 
    {   
        UILabel *label = [labelArray objectAtIndex:i];
        if (i<codeStr.length) 
        {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [codeStr substringWithRange:NSMakeRange(i, 1)];
        }
        else
        {
             [self changeViewLayerIndex:i pointHidden:i==codeStr.length?NO:YES];
             if (!codeStr && codeStr.length==0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
        
    }
    if (codeStr.length>=self->_maxCodelenth)
    {
        [textField resignFirstResponder];
        if (self.codeBlock) {
            self.codeBlock(codeStr);
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSString *codeStr = textField.text;
    if (codeStr.length>self->_maxCodelenth) 
    {
        codeStr = [codeStr substringToIndex:_maxCodelenth];
        textField.text = codeStr;
    }
    return YES;
}

#pragma mark -- view的透明度动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 1.1;
    opacityAnimation.repeatCount = HUGE_VALF;
    return opacityAnimation;
}


- (void)changeViewLayerIndex:(NSInteger)index pointHidden:(BOOL)hidden{
    UILabel *label = labelArray[index];
    CAShapeLayer *line =lineArray[index];
    if (hidden) {
        label.layer.borderColor = _unSelectColor.CGColor;
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        label.layer.borderColor = _codeSelectColor.CGColor;
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    line.hidden = hidden;

}


#pragma mark -- clear codeInput Content
- (void)clearCodeString{
    // Restore the input box and cursor to the initial state
    for (NSInteger i = 0; i<labelArray.count; i++) {
        UILabel *label = [labelArray objectAtIndex:i];
        CAShapeLayer *line =lineArray[i];
        label.text = @"";  
        if (i == 0) {
            label.layer.borderColor = _codeSelectColor.CGColor;
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //set first cursor appear and animation
            line.hidden = NO;
        } else
        {
            label.layer.borderColor = _unSelectColor.CGColor;
            [line removeAnimationForKey:@"kOpacityAnimation"];
        }     
    }
    // set textView's content is nil and set the keyboard become first reponse
    textView.text = @"";
    [textView becomeFirstResponder];
}
    
@end
