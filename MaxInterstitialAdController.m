//
//  InterstitialAdController.m
//  AdsAndPurchase
//
//  Created by arthurxu on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import "MaxInterstitialAdController.h"

@interface MaxInterstitialAdController()<MaxAdControllerDelegate>

@end

@implementation MaxInterstitialAdController

#pragma mark -插屏广告
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.delegate = self;
}

-(void)loadAdWithSlotId:(NSString *)slotId{
    
    MAInterstitialAd *interstitialAd = [AdInfoManager ad: self->adDicts slotID:slotId];
    if (interstitialAd){
        AdLoadStatus status = [AdInfoManager adLoadStatus: self->adDicts slotID:slotId];
        
        // 广告正在加载中
        if (status == AdLoadStatusLoading){
            return;
        }
        
        // 广告加载失败
        if (status == AdLoadStatusFailed){
            // 重新加载
            [interstitialAd loadAd];
            return;
        }
        
        // 判断该广告是否有效？
        if ([AdInfoManager adValidated:self->adDicts slotID:slotId]){
            // 如果该广告有效，则不需要重新加载
            return;
        }
        
        // 广告已经失效，则重新加载
        [interstitialAd loadAd];
        return;
    }
        
    interstitialAd = [[MAInterstitialAd alloc]initWithAdUnitIdentifier:slotId];
    interstitialAd.delegate = self;
    [interstitialAd loadAd];
    
    // 将插屏广告对象加入到字典
    [self->adDicts setObject:[AdInfoManager adInfo: interstitialAd] forKey:slotId];
}

// 分层加载广告
//-(void)loadAdWithSlotIds:(NSArray *)slotIds{
//    slotIdIndex = 0;
//
//    slotIdArray = [NSArray arrayWithArray: slotIds];
//
//    [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
//}

-(void)showAd{
    
    for (NSString *slotId in self->adDicts.allKeys){
        if (![AdInfoManager adValidated:self->adDicts slotID: slotId]){
            continue;
        }
        
        if ([self showAdWithSlotId:slotId]){
            break;;
        }
    }
}

-(BOOL)showAdWithSlotId:(NSString *)slotId{
    MAInterstitialAd *interstitialAd = [AdInfoManager ad:self->adDicts slotID:slotId];
    if (interstitialAd && [interstitialAd isReady]){
        [interstitialAd showAd];
        return true;
    }
    
    return false;
}

//#pragma mark -MAAdDelegate Protocol
//
//// 广告加载成功
//- (void)didLoadAd:(MAAd *)ad{
//
//    retryAttempt = 0;
//
//    NSString *slotId = ad.adUnitIdentifier;
//
//    // 设置广告加载时间
//    [self setAdLoadTime:self->adDicts slotID:slotId];
//
//    // 设置广告显示状态
//    [self setAdShowStatus:self->adDicts slotID:slotId status:AdShowStatusNoShow];
//
//    // 设置广告加载状态
//    [self setAdLoadStatus:self->adDicts slotID:slotId status: AdLoadStatusLoaded];
//}
//
//- (void)didClickAd:(nonnull MAAd *)ad {}
//- (void)didDisplayAd:(nonnull MAAd *)ad {
//    // 设置广告已经展示
//    [self setAdShowStatus:self->adDicts slotID:ad.adUnitIdentifier status:AdShowStatusShown];
//}
//
//- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {}
//
//// 加载失败
//- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
//
//    [self setAdLoadStatus:self->adDicts slotID:adUnitIdentifier status:AdLoadStatusFailed];
//
//    // 分层广告
//    if (slotIdArray){
//        slotIdIndex++;
//        if (slotIdIndex < slotIdArray.count){
//            [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
//        }
//    }else{
//        // 单个广告加载
//        retryAttempt++;
//
//        // 延时秒,最多延迟 2^6 = 64秒
//        NSInteger delaySec = pow(2, MIN(6, retryAttempt));
//
//        // 延时多少秒以后在主线程执行广告加载
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self loadAdWithSlotId: adUnitIdentifier];
//        });
//    }
//}
//
//// 关闭广告，加载下一个广告
//- (void)didHideAd:(nonnull MAAd *)ad {
//    if (slotIdArray){
//        slotIdIndex = 0;
//        [self loadAdWithSlotId: slotIdArray[slotIdIndex]];
//    }else{
//        [self loadAdWithSlotId: ad.adUnitIdentifier];
//    }
//}

@end
