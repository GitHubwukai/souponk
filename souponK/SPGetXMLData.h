//
//  SPGetXMLData.h
//  souponK
//
//  Created by wukai on 13-6-16.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import "TBXML.h"

@interface SPGetXMLData : NSObject


+ (BOOL)isExistenceNetWork;
+ (NSMutableArray *)parserXML:(NSString *)dataApiString type:(ParserType)type;
@end
