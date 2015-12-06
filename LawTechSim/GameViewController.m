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

@property (nonatomic, strong) SKView *view;
@property (nonatomic, strong) GameScene *gameScene;
@property (nonatomic, strong) GameControlView *controlView;

@end

@implementation GameViewController
@dynamic view;


- (void)loadView
{
    self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.controlView];

    // TODO: Implement Start Screen?
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TEMP: Load GameScene for now
    // Setup and Present GameScene
    self.controlView.delegate = self.gameScene;
    [self.view presentScene:self.gameScene];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Layout control to bottom half of screen TEMP
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



@end
