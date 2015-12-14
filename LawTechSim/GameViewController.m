//
//  GameViewController.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameControlView.h"

@interface GameViewController ()

/// View of GameScene
@property (nonatomic, strong) SKView *gameView;

/// SKScene of sprites
@property (nonatomic, strong) GameScene *gameScene;

/// View of control
@property (nonatomic, strong) GameControlView *controlView;

/// Manages story and game state
@property (nonatomic, strong) StoryStore *storyStore;

@end

@implementation GameViewController

static NSString *const kGameStoryFileName       = @"story";

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingNone;

    // GameView
    self.gameView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.gameView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.gameView];
    
    // TEMP: logs
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Controls
    [self.view addSubview:self.controlView];    

    // TODO: Implement Start Screen?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _storyStore = [[StoryStore alloc] initWithFileNamed:kGameStoryFileName
                                               loadSave:NO];
    _storyStore.delegate = self;
    
    
    /*   Setup GameScene   */
    self.controlView.delegate = self;
    [self.gameView presentScene:self.gameScene];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect gameFrame = self.view.bounds;
    gameFrame.size.height /= 2;
    [self.gameView setFrame:gameFrame];
    
    // ControlView to bottom half of screen TEMP
    CGRect ctrlFrame = self.view.bounds;
    ctrlFrame.size.height /= 2;
    ctrlFrame.origin.y += ctrlFrame.size.height;
    [self.controlView setFrame:ctrlFrame];
}

#pragma mark - Properties

- (GameScene *)gameScene
{
    if (!_gameScene)
    {
        _gameScene = [GameScene sceneWithSize: self.view.bounds.size];
        // TODO: Load last played state (?)
    }
    
    return _gameScene;
}

- (GameControlView *)controlView
{
    if (!_controlView)
    {
        _controlView = [[GameControlView alloc] init];
    }
    
    return _controlView;
}


#pragma mark - GameControlViewDelegate

//FIXME: Consider moving GameControlViewDelegate to GameViewController

- (void)gameControlDidChangeToState:(GameControlViewState)state
{
    /*   Interrumpt movement control if event sequence is active   */
    if ([self.storyStore hasActiveEventSequence])
        return;
    
    /*   If there is no active event sequence, redirect to game scene to control character   */
    [self.gameScene redirectGameInput:state];
}

- (void)gameControlDidPressAction
{
    // TODO: Execute event sequence when close to character
    
    /*   Stop character movement if event is triggered   */
//    [self.characterNode setState:CharacterNodeStateStill];
    
    // StoryStore Temporary Test code.
    if (![self.storyStore hasActiveEventSequence])
    {
        [self.storyStore activateEventSequenceForId:@"Sei"];
    }
    else if ([self.storyStore.currentEvent eventType] == EventTypeChoice)
    {
        [self.storyStore progressToNextEventWithOption:@"Yes"];
    }
    else if ([self.storyStore.currentEvent eventType] == EventTypeSpecial)
    {
        [self.storyStore progressToNextEventWithOption:StoryStoreSpecialEventSuccess];
    }
    else
    {
        [self.storyStore progressToNextEventWithOption:nil];
    }
}



#pragma mark - StoryStoreDelegate

//FIXME: Consider moving StoryStore / Delegate to GameViewController
- (void)storyStoreReadEvent:(id<EventProtocol>)event
{

}

- (void)storyStoreFinishedSequence
{
    //    [self.dialogBoxView setHidden:YES];
}




@end
