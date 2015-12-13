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

/// Constant denoting choice results in no scene jump
static NSString *const kChoiceNoJumpKey = @"no_jump";

- (instancetype)initWithOption:(NSString *)option
              destinationScene:(NSString *)sceneId
{
    if (self = [super init])
    {
        _option = option;
        
        if (![sceneId isEqualToString:kChoiceNoJumpKey])
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

#pragma mark - Public

- (void)addChoiceWithAttributes:(NSDictionary *)attr
{
    Choice *c = [[Choice alloc] initWithAttributes:attr];
    [_mutableChoices addObject: c];
}

- (NSString *)destinationSceneForChoiceOption:(NSString *)option
{
    NSString *sceneId = nil;
    
    for (Choice *c in _mutableChoices)
    {
        if ([c.option isEqualToString:option])
        {
            sceneId = c.destinationScene;
            break;
        }
    }
    
    return sceneId;
}

#pragma mark - Properties

- (NSArray<Choice *> *)choices
{
    return [_mutableChoices copy];
}

@end
