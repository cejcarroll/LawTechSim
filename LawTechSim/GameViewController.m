//
//  GameViewController.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

/// View of GameScene
@property (nonatomic, strong) SKView *gameView;

/// SKScene of sprites
@property (nonatomic, strong) GameScene *gameScene;

/// View of control
@property (nonatomic, strong) GameControlView *controlView;

/// Overlay view showing dialog boxes and choice boxes above gameView
@property (nonatomic, strong) GameOverlayView *overlayView;

/// Manages story and game state
@property (nonatomic, strong) StoryStore *storyStore;

@end

@implementation GameViewController

static NSString *const kGameStoryFileName = @"story";

#pragma mark - UIViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    // GameView
    [self.view addSubview:self.gameView];
    
    // TEMP: logs
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Controls
    [self.view addSubview:self.controlView];
    
    // Overlay
    [self.view addSubview:self.overlayView];
    
    // TODO: Implement Start Screen?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*   Initialize StoryStore   */
    self.storyStore = [[StoryStore alloc] initWithFileNamed:kGameStoryFileName
                                                   loadSave:NO];
    self.storyStore.delegate = self;
    
    
    /*   Setup GameScene   */
    [self.gameView presentScene:self.gameScene];
}

// FIXME: Create separate view class for GameViewController
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // GameView to top half of screen
    CGRect gameFrame = self.view.bounds;
    gameFrame.size.height /= 2;
    [self.gameView setFrame:gameFrame];
    
    // OvelayView (same as gameView's frame)
    [self.overlayView setFrame:gameFrame];
    
    // ControlView to bottom half of screen TEMP
    CGRect ctrlFrame = self.view.bounds;
    ctrlFrame.size.height /= 2;
    ctrlFrame.origin.y += ctrlFrame.size.height;
    [self.controlView setFrame:ctrlFrame];
}

#pragma mark - Properties

- (SKView *)gameView
{
    if (!_gameView)
    {
        _gameView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _gameView.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return _gameView;
}

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
        _controlView.delegate = self;
    }
    
    return _controlView;
}

- (GameOverlayView *)overlayView
{
    if (!_overlayView)
    {
        _overlayView = [[GameOverlayView alloc] initWithFrame:CGRectZero];
        _overlayView.delegate = self;
    }
    
    return _overlayView;
}


#pragma mark - GameControlViewDelegate

- (void)gameControlDidChangeToState:(GameControlViewState)state
{
    /*   Interrumpt movement control if event sequence is active. (i.e. Choice or Dialogue being shown)   */
    if ([self.storyStore hasActiveEventSequence])
    {
        [self.overlayView redirectGameInput:state];
    }
    else /*   If there is no active event sequence, redirect to game scene to control character   */
    {
        [self.gameScene redirectGameInput:state];
    }
    
}

- (void)gameControlDidPressAction
{
    // TODO: Execute event sequence when close to character
    
    /*   Stop character movement if event is triggered   */
    //    [self.characterNode setState:CharacterNodeStateStill];
    
    /*   Redirect to overlay for choice box   */
    if (self.overlayView.swallowsAction)
    {
        [self.overlayView redirectGameInput:GameControlViewStateActionPress];
        return;
    }
    
    
    /*   Progress story based on current active event   */
    if ([self.storyStore hasActiveEventSequence])
    {
        if ([self.storyStore.currentEvent eventType] == EventTypeSpecial)
        {
            // TODO: This selector should be sent on mini-game success / fail
            [self.storyStore progressToNextEventWithOption:StoryStoreSpecialEventSuccess];
        }
        else
        {
            [self.storyStore progressToNextEventWithOption:nil];
        }
    }
    else
    {
        /*   If no active event loaded, and there is an entity nearby, begin new interaction   */
        NSString *nearbyEntityId = [self.gameScene nearbyEntityForCharacter];
        
        if (nearbyEntityId)
        {
            [self.gameScene redirectGameInput:GameControlViewStateNoPress];
            [self.storyStore activateEventSequenceForId:nearbyEntityId];
        }

    }
}

#pragma mark - GameOverlayViewDelegate

- (void)gameOverlayDidSelectOption:(NSString *)option
{
    assert(self.storyStore.currentEvent.eventType == EventTypeChoice);
    [self.storyStore progressToNextEventWithOption:option];
}


#pragma mark - StoryStoreDelegate

- (void)storyStoreReadEvent:(id<EventProtocol>)event
{
    [self.overlayView displayEvent:event];
}

- (void)storyStoreFinishedSequence
{
    [self.overlayView hideAllOverlays];
}




@end
