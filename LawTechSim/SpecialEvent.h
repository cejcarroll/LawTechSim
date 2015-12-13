//
//  SpecialEvent.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/12/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventProtocol.h"

@interface SpecialEvent : NSObject <EventProtocol>

/// Identifier for special event
@property (nonatomic, readonly, copy) NSString *eventId;

/// SceneId of scene to jump to on event success. Nil denotes no jump
@property (nonatomic, readonly, copy) NSString *onSuccessSceneId;

/// SceneId of scene to jump to on event failure. Nil denotes no jump
@property (nonatomic, readonly, copy) NSString *onFailureSceneId;

- (instancetype)initWithEventId:(NSString *)eventId
                 onSuccessScene:(NSString *)onSuccessSceneId
                 onFailureScene:(NSString *)onFailureSceneId;

- (instancetype)initWithAttributes:(NSDictionary *)attr;

@end
