//
//  AdInfoManager.h
//  AdsAndPurchase
//
//  Created by arthurxu on 2022/6/27.
//

#ifndef AdInfoManager_h
#define AdInfoManager_h

// 广告加载状态
typedef enum AdLoadStatus{
    AdLoadStatusFailed = -1,
    AdLoadStatusLoading = 0,
    AdLoadStatusLoaded = 1
}AdLoadStatus;

// 广告展示状态
typedef enum AdShowStatus{
    AdShowStatusNoShow = 0, // 未展示
    AdShowStatusShown = 1   // 已展示
}AdShowStatus;


@interface AdInfoManager : NSObject

// 通用方法
+(NSMutableDictionary* _Nullable)adInfo: (nonnull id)ad;
+(id _Nullable)ad:(nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;

+(void)setAdLoadStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId status:(AdLoadStatus)status;
+(AdLoadStatus)adLoadStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;

+(void)setAdLoadTime: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;
+(double)adLoadTime: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;

+(void)setAdShowStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId status:(AdShowStatus)status;
+(AdShowStatus)adShownStatus: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;

+(BOOL)adValidated: (nonnull NSMutableDictionary*)dict slotID: (nonnull NSString*)slotId;

@end

#endif /* AdInfoManager_h */
