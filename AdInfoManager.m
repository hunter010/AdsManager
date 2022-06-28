//
//  AdInfoManager.m
//  AdsAndPurchase
//
//  Created by arthurxu on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import "AdInfoManager.h"

// 广告缓存默认过期时间
static NSInteger const kAdCacheDefaultExpiredTime = 3600;

#define kMaxAdkeyAd @"ad"
#define kMaxAdkeyLoadTime @"load_time"
#define kMaxAdkeyAdShown @"ad_shown"
#define kMaxAdkeyAdLoaded @"ad_loaded"

@implementation AdInfoManager

// 设置广告加载时间，是否已经播放？ 方便计算广告时候超时
+(NSMutableDictionary*)adInfo: (id)ad{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:ad forKey: kMaxAdkeyAd];
    [dict setValue:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970] forKey: kMaxAdkeyLoadTime];
    [dict setValue:[NSNumber numberWithInt: AdShowStatusNoShow] forKey: kMaxAdkeyAdShown];
    [dict setValue:[NSNumber numberWithInt: AdLoadStatusLoading] forKey: kMaxAdkeyAdLoaded];
    
    return dict;
}

// 通过广告ID获取广告信息
+(id)ad:(NSMutableDictionary*)dict slotID: (NSString*)slotId{
    return [[dict objectForKey:slotId] objectForKey:kMaxAdkeyAd];
}

// 设置广告加载状态：status: 1:成功  0:加载中 +1:加载失败
+(void)setAdLoadStatus:(NSMutableDictionary *)dict slotID:(NSString *)slotId status:(AdLoadStatus)status{
    NSMutableDictionary *subDict = [dict objectForKey:slotId];
    if (subDict){
        [subDict setValue:[NSNumber numberWithInt:status] forKey: kMaxAdkeyAdLoaded];
    }
}

+(AdLoadStatus)adLoadStatus:(NSMutableDictionary *)dict slotID:(NSString *)slotId{
    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyAdLoaded]intValue];
}

+(void)setAdLoadTime:(NSMutableDictionary *)dict slotID:(NSString *)slotId{
    NSMutableDictionary *subDict = [dict objectForKey:slotId];
    if (subDict){
        [subDict setValue:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970] forKey: kMaxAdkeyLoadTime];
    }
}

// 广告加载时间
+(double)adLoadTime: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyLoadTime]doubleValue];
}

// 设置广告展示状态
+(void)setAdShowStatus: (NSMutableDictionary*)dict slotID: (NSString*)slotId status:(AdShowStatus)status{
    NSMutableDictionary *subDict = [dict objectForKey:slotId];
    if (subDict){
        [subDict setValue:[NSNumber numberWithInt:status] forKey: kMaxAdkeyAdShown];
    }
}

// 获取广告展示状态
+(AdShowStatus)adShownStatus: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyAdShown]intValue];
}

// 判断广告是否有效？
+(BOOL)adValidated: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
    // 判断广告是否加载成功
    if ([self ad: dict slotID: slotId]){
        
        // 广告是否有效？
        BOOL validate = NO;
        
        // 判断广告是否已经展示?
        if ([self adShownStatus: dict slotID:slotId] == AdShowStatusNoShow){
            validate = YES;
        }
        
        // 如果广告没有展示过，判断缓存是否过期
        if (validate){
            
            // 广告加载时间
            double loadTime = [self adLoadTime: dict slotID: slotId];
            
            // 广告缓存超时，则需要重新加载广告
            if ([NSDate date].timeIntervalSince1970 + loadTime > kAdCacheDefaultExpiredTime){
                
                validate = NO;
            }
        }
        
        // 如果广告有效，则不用重新加载
        if (validate){
            return YES;
        }
    }
    
    return NO;
}


@end
