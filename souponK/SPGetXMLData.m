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
#import "SPHotData.h"
#import "SPPartition.h"

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
	if (type == xHotlist) {
		TBXMLElement *coupon = [TBXML childElementNamed:@"coupon" parentElement:root];
		while (coupon != nil) {
			SPHotData *data = [[SPHotData alloc] init];
			data.s_hotid = [TBXML valueOfAttributeNamed:@"id" forElement:coupon	];
			data.s_caption = [TBXML valueOfAttributeNamed:@"caption" forElement:coupon];
			data.s_description = [TBXML valueOfAttributeNamed:@"description" forElement:coupon];
			data.s_icon = [TBXML valueOfAttributeNamed:@"icon" forElement:coupon];
			data.s_popularity = [TBXML valueOfAttributeNamed:@"popularity" forElement:coupon];
			coupon = [TBXML nextSiblingNamed:@"coupon" searchFromElement:coupon];
			[dataArray addObject:data];
			[data release];
		}
	}
	
	if (type == xPartitionB || type == xPartitionC || type == xPartitionD) {
		NSString *string = @"";
		switch (type) {
			case xPartitionB:
				string = @"brand";
				break;
			case xPartitionC:
				string = @"category";
				break;
			case xPartitionD:
				string = @"district";
				break;
			default:
				break;
		}
		TBXMLElement *ads = [TBXML childElementNamed:string parentElement:root];
		while (ads != nil) {
			//写到这里先去实现数据类型
			SPPartition *data = [[SPPartition alloc] init];
			data.s_id = [TBXML valueOfAttributeNamed:@"id" forElement:ads];
			data.s_caption = [TBXML valueOfAttributeNamed:@"caption" forElement:ads];
			data.s_keyword = [TBXML valueOfAttributeNamed:@"keyword" forElement:ads];
			
			ads = [TBXML nextSiblingNamed:string searchFromElement:ads];
			[dataArray addObject:data];
			[data release];
		}
	}
	
	return dataArray;
}

@end
