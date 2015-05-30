//
//  GameScene.m
//  ZoopShooter
//
//  Created by Tom Hartnett on 5/29/15.
//  Copyright (c) 2015 Tom Hartnett. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property BOOL contentCreated;
@property CGFloat angle;
@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    
    if (!self.contentCreated) {
        
        [self createSceneContents];
        
        self.angle = 0;
        
        UISwipeGestureRecognizer *recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        recognizer1.direction = UISwipeGestureRecognizerDirectionUp;
        [[self view] addGestureRecognizer:recognizer1];
        
        UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        recognizer2.direction = UISwipeGestureRecognizerDirectionDown;
        [[self view] addGestureRecognizer:recognizer2];
        
        UISwipeGestureRecognizer *recognizer3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        recognizer3.direction = UISwipeGestureRecognizerDirectionLeft;
        [[self view] addGestureRecognizer:recognizer3];
        
        UISwipeGestureRecognizer *recognizer4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        recognizer4.direction = UISwipeGestureRecognizerDirectionRight;
        [[self view] addGestureRecognizer:recognizer4];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [[self view] addGestureRecognizer:tapRecognizer];
        
        self.contentCreated = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@, %lu", NSStringFromSelector(_cmd), (unsigned long)touches.count);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    // Down     = 8
    // Up       = 4
    // Left     = 2
    // Right    = 1
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"%lu, %@ StateEnded", (unsigned long)sender.direction, NSStringFromSelector(_cmd));
    } else {
        
        NSLog(@"%lu %@", (unsigned long)sender.direction, NSStringFromSelector(_cmd));
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)createSceneContents {
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKShapeNode *cannon = [self newCannon];
    cannon.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(cannon.frame));
    [self addChild:cannon];
}

- (SKShapeNode *)newCannon {
    
    SKShapeNode *wheel = [SKShapeNode shapeNodeWithCircleOfRadius:50];
    wheel.fillColor = [UIColor grayColor];
    wheel.strokeColor = [UIColor grayColor];
    wheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
//    wheel.physicsBody.dynamic = NO;
    wheel.physicsBody.affectedByGravity = NO;
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(0, 40);
    [wheel addChild:light1];
    
    return wheel;
}

- (SKSpriteNode *)newLight {
    
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:1.0],
                                           [SKAction fadeInWithDuration:1.0]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

@end
