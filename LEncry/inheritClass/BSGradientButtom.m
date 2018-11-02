//
//  BSGradientButtom.m
//  BloodSouvenir
//
//  Created by ponted on 2018/10/31.
//  Copyright © 2018 xuezhiyuan. All rights reserved.
//

#import "BSGradientButtom.h"

@implementation BSGradientButtom

- (void)showGradientButtom:(NSString *)title edgetImageName:(NSString *)imageName 
{
    // add title label
    if (_buttomTitleLabel == nil) {
        _buttomTitleLabel = [[UILabel alloc]init];
    }
    _buttomTitleLabel.font = KFont(17);
    _buttomTitleLabel.text = title;
    _buttomTitleLabel.textColor = HEXCOLOR(0x222222);
    [self addSubview:_buttomTitleLabel];
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:_buttomTitleLabel.font}];
    
    [_buttomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(ceil(size.width)+1);
        make.height.mas_equalTo(ceil(size.height)+1);
    }];
    
    // add edget imageview 
    if (_buttomEdegtImageView == nil) {
        _buttomEdegtImageView = [[UIImageView alloc]init];
    }
    if (imageName.length) {
        [_buttomEdegtImageView setImage:[UIImage imageNamed:ImagePath(imageName)]];
    }
    [self addSubview:_buttomEdegtImageView];
    
    [_buttomEdegtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self->_buttomTitleLabel.mas_right).with.offset(MAIN_SCREEN_WIDTH_SCALE*20);
        make.width.mas_equalTo(self->_buttomEdegtImageView.image.size.width);
        make.height.mas_equalTo(self->_buttomEdegtImageView.image.size.height);
    }];
    
    // add action controller
    UIControl *ctr = [[UIControl alloc]initWithFrame:self.bounds];
    [ctr addTarget:self action:@selector(clickButtomAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ctr];
    [ctr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);

    }];
    
}

- (void)setStatusChange:(BOOL)selected selected:(NSDictionary *)sParam  direct:(NSInteger)direct
{
    if (selected) {
        _buttomTitleLabel.textColor = HEXCOLOR(0xffffff);
        [self setGradientView:sParam direction:direct];
    }else
    {
        [[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
        _buttomTitleLabel.textColor = HEXCOLOR(0x222222);
    }
}

- (void)clickButtomAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickGradient:)]) {
        [_delegate clickGradient:self];
    }
}


@end
