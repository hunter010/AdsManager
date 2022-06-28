//
//  MaxAdController.h
//  AdsAndPurchase
//
//  Created by arthurxu on 2022/6/24.
//

#ifndef MaxAdController_h
#define MaxAdController_h

#import <UIKit/UIKit.h>
#import <AppLovinSDK/AppLovinSDK.h>

#import "AdInfoManager.h"

// 广告加载回调方法：1-succeed：YES-成功 NO-失败 2-error: 信息错误  3-adIndex: 返回加载成功的广告索引下标（分层广告数组才有）
//typedef void (^AdLoadedHandler)(BOOL succeed, NSError * _Nullable error, int adIndex);

// 广告缓存默认过期时间
//static NSInteger const kAdCacheDefaultExpiredTime = 3600;
//
//// 广告加载状态
//typedef enum AdLoadStatus{
//    AdLoadStatusFailed = -1,
//    AdLoadStatusLoading = 0,
//    AdLoadStatusLoaded = 1
//}AdLoadStatus;
//
//// 广告展示状态
//typedef enum AdShowStatus{
//    AdShowStatusNoShow = 0, // 未展示
//    AdShowStatusShown = 1   // 已展示
//}AdShowStatus;

//
@protocol MaxAdControllerDelegate <NSObject>

@optional
- (void)loadAdWithSlotId: (nonnull NSString*)slotId;

- (void)showAd;

- (BOOL)showAdWithSlotId: (nonnull NSString*)slotId;

@end

@interface MaxAdController : UIViewController<MAAdDelegate>
{
    // 广告加载重试次数
    NSInteger retryAttempt;
    
    NSMutableDictionary *adDicts;
}

// 广告缓存过期时间（单位：秒）
@property (nonatomic, assign) NSUInteger expiredTime;

@property (nonatomic, strong) id<MaxAdControllerDelegate> _Nullable delegate;

//
//// 通用方法
//-(NSMutableDictionary* _Nullable)adInfo: (nonnull id)ad;
//-(id _Nullable)ad:(nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
//
//-(void)setAdLoadStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId status:(AdLoadStatus)status;
//-(AdLoadStatus)adLoadStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
//
//-(void)setAdLoadTime: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
//-(double)adLoadTime: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
//
//-(void)setAdShowStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId status:(AdShowStatus)status;
//-(AdShowStatus)adShownStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
//
//-(BOOL)adValidated: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;


// 插屏广告
- (void)loadAdWithSlotId: (nonnull NSString*)slotId;

- (void)loadAdWithSlotIds: (nonnull NSArray*)slotIds;

- (void)showAd;

- (void)removeAdWithSlotId: (nonnull NSString*)slotId;

@end

#endif /* MaxAdController_h */
