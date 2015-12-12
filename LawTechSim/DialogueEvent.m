//
//  DialogueEvent.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "DialogueEvent.h"

@interface DialogueEvent ()

@property (nonatomic, readwrite, copy) NSString *speakerName;
@property (nonatomic, readwrite, copy) NSString *content;

@end

@implementation DialogueEvent

static NSString *const kSpeakerNameKey = @"speaker";
static NSString *const kContentKey = @"content";

- (instancetype)initWithSpeaker:(NSString *)speakerName
                        content:(NSString *)content
{
    if (self = [super init])
    {
        _speakerName = speakerName;
        _content = speakerName;
    }
    
    return self;
}


- (instancetype)initWithAttributes:(NSDictionary *)attr
{
    NSString *speaker = attr[kSpeakerNameKey];
    NSString *content = attr[kContentKey];
    
    return [self initWithSpeaker:speaker
                         content:content];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@ [%@]",
            NSStringFromClass([self class]), self.speakerName, self.content];
}

#pragma mark - EventType

- (EventType)eventType
{
    return EventTypeDialogue;
}

@end
