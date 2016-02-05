//
//  QSiTerm2TerminalMediator.m
//  QSiTerm2
//
//  Created by Andreas Johansson on 2012-03-20.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSiTerm3TerminalMediator.h"

@implementation QSiTerm3TerminalMediator


/*
 Executes a command in a terminal. Where the command is run is defined by the target argument.
 */
- (void) performCommandInTerminal:(NSString *)command target:(QSTerminalTarget)target {
    // iTerm2 does not run the command if there are trailing spaces in the command
    NSString *trimmedCommand = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    iTermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    iTermWindow *window;
    iTermSession *session;
    
    [app activate];
    
    // Get terminal session
    if (target == QSTerminalTargetWindow || app.windows.count <= 0) {
        window = [self createTerminalIn:app];
        session = window.currentSession;
    } else if (target == QSTerminalTargetCurrent) {
        window = app.currentWindow;
        session = window.currentSession;
    } else { // (target == QSTerminalTargetTab)
        window = app.currentWindow;
        session = [[app.currentWindow createTabWithDefaultProfileCommand:nil] autorelease].currentSession;
    }

    // execCommand does not work, this does, don't know why...
    [session writeContentsOfFile:nil text:trimmedCommand newline:true];
}


/*
 Executes a command in a new terminal window
 
 This method is required for this object to become a global terminal mediator in QS.
 */
- (void) performCommandInTerminal:(NSString *)command {
    [self performCommandInTerminalWindow:command];
}

/*
 Executes a command in a new terminal window
 */
- (void) performCommandInTerminalWindow:(NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetWindow];
}


/*
 Executes a command in a new tab in the current terminal
 */
- (void) performCommandInTerminalTab:(NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetTab];
}


/*
 Executes a command in the current terminal
 */
- (void) performCommandInCurrentTerminal: (NSString *)command {
    [self performCommandInTerminal:command target:QSTerminalTargetCurrent];
}


/*
 Creates a new terminal window
 */
- (iTermWindow *) createTerminalIn:(iTermApplication *)app {
    return [[app createWindowWithDefaultProfileCommand:nil] autorelease];
}

/*
 Open a named session in a new terminal window
 */
- (void) openSession:(NSString *)sessionName target:(QSTerminalTarget)target {
    iTermApplication *app = [SBApplication applicationWithBundleIdentifier:kQSiTerm2Bundle];
    
    if (target == QSTerminalTargetTab && [[app windows] count] > 0) {
        [app.currentWindow createTabWithDefaultProfileCommand:nil];
    } else {
        [app createWindowWithDefaultProfileCommand:nil];
    }
}


@end
