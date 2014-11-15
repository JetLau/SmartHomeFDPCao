//
//  LJCommonCell.h
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LJCommonItem;

@interface LJCommonCell : UITableViewCell

//data
@property(strong,nonatomic)LJCommonItem *item;
//类方法，提供cell的初始化
+(instancetype) cellWithTableView:(UITableView *) tableView;

-(void) setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;
@end
