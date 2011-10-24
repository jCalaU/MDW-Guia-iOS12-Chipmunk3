//
//  ViewController.h
//  MDW-Guia-iOS12
//
//  Created by Javier Cala Uribe on 24/10/11.
//  Copyright (c) 2011 *. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "chipmunk.h"

@interface ViewController : UIViewController <UIAccelerometerDelegate>{
    
    UIImageView *barra;
    
    UIImageView *esfera;
    
    cpSpace *space;
    
    cpBody *barraBody;
    
    cpShape *barraShape;
    
}

- (void)configurarChipmunk;

- (void)delta:(NSTimer *)timer;

void updateShape(void *ptr, void* unused);

@end