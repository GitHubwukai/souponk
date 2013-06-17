//
//  SPGetXMLData.m
//  souponK
//
//  Created by wukai on 13-6-16.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "SPGetXMLData.h"
#import "SPAdsData.h"
#import "SPCityData.h"
#import "Reachability.h"

@implementation SPGetXMLData

+ (BOOL)isExistenceNetWork
{
	BOOL isExistenceNetWork;
	Reachability *reachability = [Reachability reachabilityWithHostName:@"http:www.baidu.com"];
	
	switch ([reachability currentReachabilityStatus]) {
		case NotReachable:
			isExistenceNetWork = FALSE;
			break;
		case ReachableViaWWAN:
			isExistenceNetWork = TRUE;
			break;
		case ReachableViaWiFi:
			isExistenceNetWork = TRUE;
			break;
	}
	return isExistenceNetWork;
}

+ (NSMutableArray *)parserXML:(NSString *)dataApiString type:(ParserType)type
{
	if (!dataApiString) {
		return nil;
	}
	
	NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	//创建保存数据
	TBXML *tbXml = [TBXML tbxmlWithXMLString:dataApiString];
	TBXMLElement *root = tbXml.rootXMLElement;
	
	//解析城市数据
	if (type == xGetcitys) {
		TBXMLElement *city = [TBXML childElementNamed:@"city" parentElement:root];
		while (city != nil) {
			SPCityData *data = [[SPCityData alloc] init];
			data.s_cityID = [TBXML valueOfAttributeNamed:@"id" forElement:city];
			data.s_cityCaption = [TBXML valueOfAttributeNamed:@"caption" forElement:city];
			
			city = [TBXML nextSiblingNamed:@"city" searchFromElement:city];
			[dataArray addObject:data];
			[data release];
		}
	}
	//解析广告图片名字
	if (type == xAds) {
		TBXMLElement *ads = [TBXML childElementNamed:@"ad" parentElement:root];
		while (ads != nil) {
			SPAdsData *data = [[SPAdsData alloc] init];
			data.s_adID = [TBXML valueOfAttributeNamed:@"id" forElement:ads];
			data.s_adName = [TBXML valueOfAttributeNamed:@"poster" forElement:ads];
			data.s_adURL = [TBXML valueOfAttributeNamed:@"url" forElement:ads];
			
			ads = [TBXML nextSiblingNamed:@"ad" searchFromElement:ads];
			[dataArray addObject:data];
			[data release];
		}
	}
	return dataArray;
}

@end
