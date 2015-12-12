//
//  ChoiceEvent.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "ChoiceEvent.h"

@implementation Choice

static NSString *const kChoiceOptionKey = @"option";
static NSString *const kChoiceDestSceneKey = @"onSelection";

- (instancetype)initWithOption:(NSString *)option
              destinationScene:(NSString *)sceneId
{
    if (self = [super init])
    {
        _option = option;
        _destinationScene = sceneId;
    }
    
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attr
{
    NSString *option = attr[kChoiceOptionKey];
    NSString *destinationScene = attr[kChoiceDestSceneKey];
    
    if (!option || !destinationScene)
        NSLog(@"Error creating Choice with attr: %@", attr);

    return [self initWithOption:option
               destinationScene:destinationScene];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@ => %@",
            NSStringFromClass([self class]), self.option, self.destinationScene];
}

@end

//-------------------------------------------------

@interface ChoiceEvent ()
{
    /// Mutable inner variable for immutable public property choice
    NSMutableArray<Choice *> *_mutableChoices;
}

@end

@implementation ChoiceEvent


- (instancetype)init
{
    if (self = [super init])
    {
        _mutableChoices = [NSMutableArray array];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.choices];
}

#pragma mark - EventProtocol

- (EventType)eventType
{
    return EventTypeChoice;
}

#pragma mark - ChoiceEvent

- (void)addChoiceWithAttributes:(NSDictionary *)attr
{
    Choice *c = [[Choice alloc] initWithAttributes:attr];
    [_mutableChoices addObject: c];
}

#pragma mark - Properties

- (NSArray<Choice *> *)choices
{
    return [_mutableChoices copy];
}

@end
