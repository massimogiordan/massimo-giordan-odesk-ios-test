//
//  ViewController.m
//  BuggyProject
//  Copyright (c) 2014 oDesk Corporation. All rights reserved.
//

#import "ViewController.h"
#import "SomeClass.h"
#import "CoreDataHelpers.h"
#import "ModelsEntity.h"
#import "OwnerEntity.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstBug:(id)sender {
	[SomeClass printTextInMain:@"Bug 1"];
}

- (IBAction)secondBug:(id)sender {
	NSInteger x = 124;
	void (^printX)() = ^() {
		NSLog(@"%i", x);
	};
	x++;
	printX();
}

- (IBAction)thirdBug:(id)sender {
	[CoreDataHelpers fillUnsortedData];
	NSArray *models = [CoreDataHelpers arrayForFetchRequestWithName:@"AllModels"];
	NSLog(@"%@", models);
}

- (IBAction)fourthBug:(id)sender {
    NSArray *models = [CoreDataHelpers arrayForFetchRequestWithName:@"AllModels"];
    
    // If there is a model into db
	if (models.count > 0) {
        // Clear db
        [CoreDataHelpers cleanData];
	}
	
    // Fill the db
	[CoreDataHelpers fillUnsortedData];
    
	models = [CoreDataHelpers arrayForFetchRequestWithName:@"AllModels"];
	NSLog(@"%@", models);
}

- (IBAction)fifthBug:(id)sender {
	[CoreDataHelpers fillUnsortedData];
    NSArray *models = [CoreDataHelpers arrayForFetchRequestWithName:@"AllModels"];

    NSLog(@"*******SOLUTION 1*******");
    // Sort the models by owner name
    NSArray *sortedModels = [models sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ModelsEntity *e1 = (ModelsEntity*)obj1;
        ModelsEntity *e2 = (ModelsEntity*)obj2;
        
        return [e1.owner.ownerName compare:e2.owner.ownerName];
    }];
    // Invert print of owner name and model name
    for (ModelsEntity *model in sortedModels)
    {
        NSLog(@"%@ %@",model.owner.ownerName,model.modelName);
    }
    
    NSLog(@"*******SOLUTION 2*******");
    NSFetchRequest *request = [[CoreDataHelpers fetchRequestWithName:@"AllModels"] copy];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"owner.ownerName" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSManagedObjectContext *context = [CoreDataHelpers currentContext];
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:request error:&error];
    // Invert print of owner name and model name
    for (ModelsEntity *model in result)
    {
        NSLog(@"%@ %@",model.owner.ownerName,model.modelName);
    }
}

@end
