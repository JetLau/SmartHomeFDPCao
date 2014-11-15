//
//  LJCommonGroup.m
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "LJCommonGroup.h"

@interface LJCommonGroup ()
@property(strong, nonatomic)NSMutableArray *items;
@end

@implementation LJCommonGroup

+(instancetype)group
{
    return [[self alloc] init];
}

#pragma mark -懒加载
-(NSMutableArray *)items
{
    if(_items==nil)
    {
        _items=[[NSMutableArray alloc] init];
    }
    
    return _items;
}
@end
