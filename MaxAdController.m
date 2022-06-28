//
//  MaxAdController.m
//  AdsAndPurchase
//
//  Created by arthurxu on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import "MaxAdController.h"

#define kMaxAdkeyAd @"ad"
#define kMaxAdkeyLoadTime @"load_time"
#define kMaxAdkeyAdShown @"ad_shown"
#define kMaxAdkeyAdLoaded @"ad_loaded"

@interface MaxAdController()
{
    // 分层广告id数组
    NSArray *slotIdArray;
    
    // 分层广告ID下标
    NSInteger slotIdIndex;
}
@end

@implementation MaxAdController
//
//#pragma mark -通用方法
//
//// 设置广告加载时间，是否已经播放？ 方便计算广告时候超时
//-(NSMutableDictionary*)adInfo: (id)ad{
//
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:ad forKey: kMaxAdkeyAd];
//    [dict setValue:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970] forKey: kMaxAdkeyLoadTime];
//    [dict setValue:[NSNumber numberWithInt: AdShowStatusNoShow] forKey: kMaxAdkeyAdShown];
//    [dict setValue:[NSNumber numberWithInt: AdLoadStatusLoading] forKey: kMaxAdkeyAdLoaded];
//
//    return dict;
//}
//
//// 通过广告ID获取广告信息
//-(id)ad:(NSMutableDictionary*)dict slotID: (NSString*)slotId{
//    return [[dict objectForKey:slotId] objectForKey:kMaxAdkeyAd];
//}
//
//// 设置广告加载状态：status: 1:成功  0:加载中 -1:加载失败
//-(void)setAdLoadStatus:(NSMutableDictionary *)dict slotID:(NSString *)slotId status:(AdLoadStatus)status{
//    NSMutableDictionary *subDict = [dict objectForKey:slotId];
//    if (subDict){
//        [subDict setValue:[NSNumber numberWithInt:status] forKey: kMaxAdkeyAdLoaded];
//    }
//}
//
//-(AdLoadStatus)adLoadStatus:(NSMutableDictionary *)dict slotID:(NSString *)slotId{
//    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyAdLoaded]intValue];
//}
//
//-(void)setAdLoadTime:(NSMutableDictionary *)dict slotID:(NSString *)slotId{
//    NSMutableDictionary *subDict = [dict objectForKey:slotId];
//    if (subDict){
//        [subDict setValue:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970] forKey: kMaxAdkeyLoadTime];
//    }
//}
//
//// 广告加载时间
//-(double)adLoadTime: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
//    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyLoadTime]doubleValue];
//}
//
//// 设置广告展示状态
//-(void)setAdShowStatus: (NSMutableDictionary*)dict slotID: (NSString*)slotId status:(AdShowStatus)status{
//    NSMutableDictionary *subDict = [dict objectForKey:slotId];
//    if (subDict){
//        [subDict setValue:[NSNumber numberWithInt:status] forKey: kMaxAdkeyAdShown];
//    }
//}
//
//// 获取广告展示状态
//-(AdShowStatus)adShownStatus: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
//    return [[[dict objectForKey:slotId] objectForKey: kMaxAdkeyAdShown]intValue];
//}
//
//// 判断广告是否有效？
//-(BOOL)adValidated: (NSMutableDictionary*)dict slotID: (NSString*)slotId{
//    // 判断广告是否加载成功
//    if ([self ad: dict slotID: slotId]){
//
//        // 广告是否有效？
//        BOOL validate = NO;
//
//        // 判断广告是否已经展示?
//        if ([self adShownStatus: dict slotID:slotId] == AdShowStatusNoShow){
//            validate = YES;
//        }
//
//        // 如果广告没有展示过，判断缓存是否过期
//        if (validate){
//
//            // 广告加载时间
//            double loadTime = [self adLoadTime: dict slotID: slotId];
//
//            // 广告缓存超时，则需要重新加载广告
//            if ([NSDate date].timeIntervalSince1970 - loadTime > self.expiredTime){
//
//                validate = NO;
//            }
//        }
//
//        // 如果广告有效，则不用重新加载
//        if (validate){
//            return YES;
//        }
//    }
//
//    return NO;
//}

#pragma mark -广告

-(void)loadAdWithSlotId:(NSString *)slotId{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadAdWithSlotId:)]){
        [self.delegate loadAdWithSlotId:slotId];
    }
}

// 分层加载广告
-(void)loadAdWithSlotIds:(NSArray *)slotIds{
    slotIdIndex = 0;
    
    slotIdArray = [NSArray arrayWithArray: slotIds];
    
    [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
}

-(void)showAd{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAd)]){
        [self.delegate showAd];
    }
}

-(void)removeAdWithSlotId:(NSString *)slotId{
    if (adDicts){
        [adDicts removeObjectForKey:slotId];
    }
}


#pragma mark -MAAdDelegate Protocol

// 广告加载成功
- (void)didLoadAd:(MAAd *)ad{
    
    retryAttempt = 0;
    
    NSString *slotId = ad.adUnitIdentifier;
    
    // 设置广告加载时间
    [AdInfoManager setAdLoadTime:self->adDicts slotID:slotId];
    
    // 设置广告显示状态
    [AdInfoManager setAdShowStatus:self->adDicts slotID:slotId status:AdShowStatusNoShow];
        
    // 设置广告加载状态
    [AdInfoManager setAdLoadStatus:self->adDicts slotID:slotId status: AdLoadStatusLoaded];
}

- (void)didClickAd:(nonnull MAAd *)ad {}
- (void)didDisplayAd:(nonnull MAAd *)ad {
    // 设置广告已经展示
    [AdInfoManager setAdShowStatus:self->adDicts slotID:ad.adUnitIdentifier status:AdShowStatusShown];
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {}

// 加载失败
- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
    
    [AdInfoManager setAdLoadStatus:self->adDicts slotID:adUnitIdentifier status:AdLoadStatusFailed];
    
    // 分层广告
    if (slotIdArray){
        slotIdIndex++;
        if (slotIdIndex < slotIdArray.count){
            [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
        }else{
            // 从0开始 重新加载一遍
            slotIdIndex = 0;
            
            // 延时30秒以后在主线程执行广告加载
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self loadAdWithSlotId: adUnitIdentifier];
            });
        }
    }else{
        // 单个广告加载
        retryAttempt++;
        
        // 延时秒,最多延迟 2^6 = 64秒
        NSInteger delaySec = pow(2, MIN(6, retryAttempt));
        
        // 延时多少秒以后在主线程执行广告加载
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loadAdWithSlotId: adUnitIdentifier];
        });
    }
}

// 关闭广告，加载下一个广告
- (void)didHideAd:(nonnull MAAd *)ad {
    if (slotIdArray){
        slotIdIndex = 0;
        [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
    }else{
        [self loadAdWithSlotId: ad.adUnitIdentifier];
    }
}

@end
