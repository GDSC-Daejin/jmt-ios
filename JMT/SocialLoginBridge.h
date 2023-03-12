//
//  Header.h
//  JMT
//
//  Created by 이지훈 on 2023/03/12.
//

#ifndef Header_h
#define Header_h

#import <React/RCTBridgeModule.h>

@interface SocialLoginBridge : NSObject <RCTBridgeModule>

- (void)loginWithGoogle:(RCTResponseSenderBlock)callback;

@end

#endif /* Header_h */
