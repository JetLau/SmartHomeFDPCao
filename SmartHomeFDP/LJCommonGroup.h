//
//  LJCommonGroup.h
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCommonGroup : NSObject
/**
 用一个模型来描述每组信息：组头，组尾，这组的所有行属性
 */

@property(strong, nonatomic)NSString *groupheader;
@property(strong, nonatomic)NSString *groupfooter;

//这组的所有行模型
//@property(strong, nonatomic)NSArray *items;
//对外提供一个接口
-(NSMutableArray *)items;
/**
 ①instancetype可以返回和方法所在类相同类型的对象，id只能返回未知类型的对象；
 ②instancetype只能作为返回值，不能像id那样作为参数，比如下面的写法
 */
+(instancetype)group;
@end
