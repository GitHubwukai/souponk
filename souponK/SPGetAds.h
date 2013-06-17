//
//  SPGetAds.h
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//
//解析广告图片的信息 返回为xml文件 通过次类中的方法解析 并将解析结果保存到数组中
#import <Foundation/Foundation.h>

@interface SPGetAds : NSObject <NSXMLParserDelegate>
//保存解析结果
@property (nonatomic, retain)NSMutableArray *xmlDataArray;

@end
