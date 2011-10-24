//
//  ViewController.m
//  MDW-Guia-iOS12
//
//  Created by Javier Cala Uribe on 24/10/11.
//  Copyright (c) 2011 *. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)delta:(NSTimer *)timer {
    
    // Actualiza información del Space
    
    cpSpaceStep(space, 1.0f/60.0f);
    
    // Actualiza información de los Shapes definidos
    
    cpSpaceHashEach(space->activeShapes, &updateShape, nil);
    
}

void updateShape(void *ptr, void* unused) {
    
    cpShape *shape = (cpShape*)ptr;
    
    // Validación del Shape recibido
    
    if(shape == nil || shape->body == nil || shape->data == nil) {
        
        NSLog(@"Invalido shape revisar ...");
        
        return;
        
    }
    
    // Actualiza la posición del Shape
    
    if([(UIView *)shape->data isKindOfClass:[UIView class]]) {
        
        [(UIView *)shape->data setCenter:CGPointMake(shape->body->p.x, 480 - shape->body->p.y)];
        
    }
    
    else
        
        NSLog(@"Shape actualizado fuera de la función : updateShape ");
    
}

- (void)configurarChipmunk {
    
    // Inicia el motor de fisica 2D Chipmunk
    
    cpInitChipmunk();
    
    // Crea un nuevo Space
    
    space = cpSpaceNew();
    
    // Define la dirección y magnitud de la gravedad en el Space
    
    space->gravity = cpv(0, -100);
    
    // Implementa el NSTimer encargado de realizar las animaciones
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(delta:) userInfo:nil repeats:YES];
    
    // Crea un Body con masa 50 y momento INFINITY
    
    cpBody *esferaBody = cpBodyNew(50.0f, INFINITY);
    
    // Establece posición inicial
    
    esferaBody->p = cpv(160, 250);
    
    // Agrega el Body al Space
    
    cpSpaceAddBody(space, esferaBody);
    
    // Crea un Shape tipo Circle con radio 15 asociado al Body "esferaBody"
    
    cpShape *esferaShape = cpCircleShapeNew(esferaBody, 15.0f, cpvzero);
    
    esferaShape->e = 0.5f; // Elasticidad
    
    esferaShape->u = 0.8f; // Fricción
    
    esferaShape->data = esfera; // Asocia Shape con UIImageView
    
    esferaShape->collision_type = 1; // Las colisiones son agrupadas por tipo
    
    // Agrega el Shape al Space
    
    cpSpaceAddShape(space, esferaShape);
    
    // ==============================
    
    // Implementación Objeto Estático
    
    // ==============================
    
    // Crea un Body con masa y momento INFINITY
    
    barraBody = cpBodyNew(INFINITY, INFINITY);
    
    // Establece la posición inicial
    
    barraBody->p = cpv(160,120);
    
    // El Body de los objetos estáticos no debe agregarse al Space
    
    // si quieres saber que pasa, agregalo <img src="http://www.maestrosdelweb.com/wp-includes/images/smilies/icon_wink.gif" alt=";)" class="wp-smiley">
    
    // Crea un Shape tipo Segment asociado al Body barraBody
    
    barraShape = cpSegmentShapeNew(barraBody, cpv(-105, -3), cpv(105, -3), 10.0);
    
    barraShape->e = 0.7f; // Elasticidad
    
    barraShape->u = 0.4f; // Fricción
    
    barraShape->data = barra; // Asocia Shape con UIImageView
    
    barraShape->collision_type = 0; // Se agrupa en un tipo de colisión diferente a "esferaShape"
    
    // Agrega el Shape al Space
    cpSpaceAddShape(space, barraShape);
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{
    
    // Modifica el ángulo de la Barra con relación a la inclinación del dispositivo
    
    cpBodySetAngle(barraBody, M_PI * (acceleration.x * 0.6f) );
    
    // Notifica a Chipmunk el movimiento de un Objeto Estático
    
    cpSpaceRehashStatic(space);
    
    // Actualiza el Shape de la Barra (Objeto Estático)
    
    [(UIView *)barraShape->data setTransform:
     
     CGAffineTransformMakeRotation(-barraShape->body->a)];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    barra = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra.png"]];
    
    barra.center = CGPointMake(160, 350);
    
    esfera = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"esfera.png"]];
    
    esfera.center = CGPointMake(160, 230);
    
    [self.view addSubview:barra];
    
    [self.view addSubview:esfera];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self configurarChipmunk];
    
    // Inicia el acelerómetro
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
