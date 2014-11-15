//
//  LJCommonItem.h
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCommonItem : NSObject
//描述每组中的每行
//图标
@property(strong,nonatomic)NSString *icon;
//标题
@property(strong,nonatomic)NSString *title;
//子标题
@property(strong,nonatomic)NSString *subtitle;
//右边显示提醒数字
@property(strong,nonatomic)NSString *badgeValue;
//点击这行cell，需要跳转到哪个控制器
@property(nonatomic,assign)Class destVcClass;
//设备类型
@property(strong,nonatomic)NSString *type;

/**
 封装点击这行cell想做的事情
 注意：block一定要使用copy
 */
@property(nonatomic,copy) void (^operation) ();
+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon type:(NSString *)type;
+(instancetype)itemWithTitle:(NSString *)title;
@end
