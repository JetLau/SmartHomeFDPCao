//
//  LJBadgeView.m
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "LJBadgeView.h"

@implementation LJBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置标题的字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        //设置背景图片
        UIImage *image = [UIImage imageNamed:@"main_badge"];
        //以长度的一半高度的一半为中性进行拉伸
        [self setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5] forState:(UIControlStateNormal)];
        //设置按钮的高度等于背景图片的高度
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentBackgroundImage.size.height);
    }
    return self;
}

-(void)setBadgeView:(NSString *)badgeView
{
    _badgeView = badgeView;
    [self setTitle:badgeView forState:UIControlStateNormal];
    
    CGSize titleSize = [badgeView sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat bw = self.currentBackgroundImage.size.width;
    if (titleSize.width < bw) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, bw, self.frame.size.height);
    }else
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, titleSize.width+10, self.frame.size.height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
