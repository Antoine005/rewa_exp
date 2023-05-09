function [handOnSB,time] = checkForHandOnSpaceBar(winPtr,theRect,errorMsg)

%CHECKFORHANDONSPACEBAR insures that the subject's hand is on the space bar before continuing with the trial.  That is:
%
% 1) If the space bar is being pressed when this function is called, this function will just exit and return 1 ("true").
%
% 2) If the space bar is NOT being pressed when this function is called, it will just set in a loop
% waiting for the space bar to be pressed.  When the space bar is pressed while this function is waiting (perhaps in response 
% to one of your error messages telling them to press the space bar), it will immediately exit and return 0 ("false"). 
%
% CHECKFORHANDONSPACEBAR requires (winPtr, errorMsg) as inputs where:
%
% winPtr is a pointer to a window. (This is returned to you when you call: SCREEN('OpenWindow')).
% rect is the size of the window. (This is also returned to you when you call: SCREEN('OpenWindow')).
% errorMsg is a string and is the message you want to display if the space bar is not pressed (it will be roughly centered on the screen).
%
% CHECKFORHANDONSPACEBAR returns 1 if the space bar is pressed when this function is called.
%                        It returns 0 if the space bar only after the subject (hopefully) puts their hand back on the space bar
%                        after reading the appropriate error messages.  These error messages tell them to put their hand
%                        back on the space bar.
%
% $ version 1.0, March 23, 2002                                     $
% $ Touch screen project.                                           $
% $ Christopher Currie, Dept. of Neural Science, New York Unversity $
%

% spaceBar = KbName('space'); % keycode for space bar: seriously increases the time of this function if the hand is on the SB
% let the argument to KeyCode be 32, the code for the SB: KeyCode(32).

textcolor = [0 255 0];
bkgColor = [0 0 0];
xCtr = theRect(3)/2;
yCtr = theRect(4)/2;
%textFontSize = 24;
%textFont = 'Verdana';

% errorMsg = 'You did not wait until target display. Trial will be repeated later.';

%SCREEN(winPtr,'TextSize',textFontSize);
%SCREEN(winPtr,'TextFont',textFont);

[touched, secs, keyCode] = KbCheck; % check keyboard. kbCheck returns 1) First element: 1 if anykey is pressed, 0 otherwise
%                                 2) 2nd element: time of key presses
%                                 3) 3rd elemtn: which key is pressed


skiptrial = 0;
if isequal(errorMsg,'You did not wait until target display. Trial will be repeated later.')
    skiptrial = 1;
end

if (~touched)
    if isequal(skiptrial,1)
        SCREEN(winPtr,'FillRect',bkgColor,theRect);
        %             SCREEN(winPtr,'DrawText', errorMsg, textstart_x, textstart_y, textcolor);
        centerText(winPtr,errorMsg,xCtr,yCtr,textcolor)
        Screen(winPtr,'Flip');
        waitsecs(1.); 
        handOnSB = 0;
        time = secs;
    else
        SCREEN(winPtr,'FillRect',bkgColor,theRect);
        %             SCREEN(winPtr,'DrawText', errorMsg, textstart_x, textstart_y, textcolor); % display errorMsg
        centerText(winPtr,errorMsg,xCtr,yCtr,textcolor)
        Screen(winPtr,'Flip');
        while 1 % loop until the subject presses the SB
            touch = 0;
            while ~touch % no key, including space bar, is being pressed at this time
                [touch, secs, keyCode] = KbCheck; % check keyboard
            end
            if keyCode(32) % hand is back on SB
                SCREEN(winPtr,'FillRect',bkgColor,theRect); % clear the message
                Screen(winPtr,'Flip');
                handOnSB = 1; % return this value to let the calling program know the space bar wasn't being pressed when this routine was called
                time = secs;
                break;
            end   
        end
    end
else 
    if keyCode(32) 
        handOnSB = 1;
        time = secs;
    else
        if isequal(skiptrial,1)    
            SCREEN(winPtr,'FillRect',bkgColor,theRect);
            Screen(winPtr,'Flip');
            %                 SCREEN(winPtr,'DrawText', errorMsg, textstart_x, textstart_y, textcolor); % display errorMsg
            centerText(winPtr,errorMsg,xCtr,yCtr,textcolor)            
            waitsecs(2); 
            handOnSB = 0;
            time = secs;
        else
            %                 SCREEN(winPtr,'DrawText', errorMsg, textstart_x, textstart_y, textcolor); % display errorMsg
            centerText(winPtr,errorMsg,xCtr,yCtr,textcolor)
            Screen(winPtr,'Flip');
            while 1
                touch = 0;
                while ~touch
                    [touch, secs, keyCode] = KbCheck;
                end
                if keyCode(32)
                    handOnSB = 1;
                    time = secs;
                    break;
                end
            end
        end    
    end 
end

return; % returning to the invoking function or to the keyboard. Keyboard, when placed in M-file, stops
% execution of the file and gives control to the user's keyboard. What does return to keyboard mean?
