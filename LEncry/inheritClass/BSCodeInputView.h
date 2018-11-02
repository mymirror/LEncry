//
//  BSCodeInputView.h
//  BloodSouvenir
//
//  Created by ponted on 2018/10/26.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^codeStringBlock)(NSString *codeString);

@interface BSCodeInputView : UIView

// code input max number
@property (nonatomic, assign)NSInteger maxCodelenth;

// code input keyboardtype can see UIKeyboardType for detail
@property (nonatomic, assign)UIKeyboardType keyboardType;

// code input complete block result is code String
@property (nonatomic, copy)codeStringBlock codeBlock;

// current input bordercolor and cursor color
@property (nonatomic,strong)UIColor *codeSelectColor;

// 未输入的框border color
@property (nonatomic,strong)UIColor *unSelectColor;


/**
 init new codeInput view
 set view's backgroundcolor is it's parentview backgroundcolor
 */
- (void)initCreateCodeInput;


/**
 clear odeInpute string content
 */
- (void)clearCodeString;

@end

