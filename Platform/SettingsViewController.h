//
//  SettingsViewController.h
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"

@interface SettingsViewController : ViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@end
