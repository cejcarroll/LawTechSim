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

@property (nonatomic, readonly, copy) NSString *eventId;

- (instancetype)initWithEventId:(NSString *)eventId;

- (instancetype)initWithAttributes:(NSDictionary *)attr;

@end
