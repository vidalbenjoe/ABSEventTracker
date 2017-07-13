Revision History, and Distribution	
1.	Overview	
2.	Specification	
3.	Current Version Release Notes	
4.	Next Version Release Notes	
5.	Integration	
5.1	Objective - C	
5.2	Swift	
6.	Usage	
6.1	Objective - C	
•	Initializing the event tracker library
•	Initializing the user
•	Tracking the event
6.2	Swift	
•	Initializing the event tracker library
•	Initializing the user
•	Tracking the event

1.	**Overview**

	The library offers a set of Interfaces for ABS-CBN’s Big Data recommendation engine. It is designed to have a small footprint on any digital property’s existing code base when integrated; it offers minimum method invocations for the two core functionalities, Writing Attributes and Reading Recommendations.  
	The focus of the design is to make an event tracking library that will be integrated into the different digital property where underlying functions and components are implemented and can be invoked within the library.
	The library is still in beta stage; recommendation reading and video attributes are not yet included.

This guide will show you how to integrate iOS event library into a native iOS ABS-CBN digital properties.


1.	**Specification**	


2.	**Current Version Release Notes**

Version 1.0

-------

5. **Integration**

5.1	**Objective - C**
Importing framework to Objective – C Project
1.	Select the project file from the project navigator on the left side of the project window.
2.	Select the target for where you want to add frameworks in the project settings editor.
3.	Select the “Build Phases” tab, and click the small triangle next to “Link Binary With Libraries” to view all of the frameworks in your application.
4.	To Add frameworks, click the “+” below the list of frameworks.
5.	The generated framework is not listed on the dialog. To add the generated framework, click “Add Other…” and look for the ABSEventTracker.framework

![Screen Shot 2017-07-12 at 10.23.34 AM.png](https://bitbucket.org/repo/XXXaLqG/images/1308007509-Screen%20Shot%202017-07-12%20at%2010.23.34%20AM.png)


![Screen Shot 2017-07-12 at 10.27.13 AM.png](https://bitbucket.org/repo/XXXaLqG/images/2536286677-Screen%20Shot%202017-07-12%20at%2010.27.13%20AM.png)


**Adding the “-ObjC” Linker Flag**
1	Select the project file from the project navigator on the far left side of the window.
2	Select the target for where you want to add the linker flag.
3	Select the “Build Settings” tab
4	Choose “All” to show all Build Settings.
5	Scroll down to the “Linking” section, and double-click to the right of where it says “Other Linking Flags”.
6	A box will appear, Click on the “+” button to add a new linker flag.
Type “-ObjC” (no quotes) and press enter.

![Screen Shot 2017-07-12 at 10.25.31 AM.png](https://bitbucket.org/repo/XXXaLqG/images/3087028643-Screen%20Shot%202017-07-12%20at%2010.25.31%20AM.png)


5.2	**Swift**
*Importing framework into Swift project*
1.	Copy the generated framework into the root folder of your project
2.	In the Project Navigator, select your project then select the target
3.	Select “General” tab.
4.	Open “Linked frameworks and libraries” expander.
5.	Click the “+” button then “Add Other..”
6.	Locate and Select the ABSEventTracker.framework

***********************************************************

Adding a Bridging Header
1.	In the Project Navigator, Select File>New>File..
2.	Select Objective-C file on the list the click next
3.	Name the Objective-C file as Empty and choose the file type to Empty file.
4.	A prompt dialog will show and click “Create Bridging Header”. Xcode will generate a <Project Name>-Bridging-Header.h file then delete the Empty.m file.
5.	Select the <Project-Name.-Bridging-Header.h file and add the following:
#import <ABSEventTracker/ABSEventTracker.h>
#import <ABSEventTracker/ABSEventTracker+Initializer.h>
#import <ABSEventTracker/EventAttributes.h>
#import <ABSEventTracker/UserAttributes.h>


Make sure to locate Objective – C bridging header into project’s build settings
![Screen Shot 2017-07-12 at 11.48.28 AM.png](https://bitbucket.org/repo/XXXaLqG/images/2040990117-Screen%20Shot%202017-07-12%20at%2011.48.28%20AM.png)![Screen Shot 2017-07-12 at 11.48.28 AM.png](https://bitbucket.org/repo/XXXaLqG/images/1538334599-Screen%20Shot%202017-07-12%20at%2011.48.28%20AM.png)

***********************************************************

6.	Integration
6.1	Objective – C
Initializing event tracker library
1.	Go to AppDelegate.m and import the ABSEventTracker 
#import <ABSEventTracker/ABSEventTracker.h>
2.	Initialize the ABSEventTracker inside the didFinishLaunchingWithOptions method by calling
[ABSEventTracker initializeTracker];

***********************************************************

Initializing the user
Implement this builder function after the user’s successful login
UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
        [builder setGigyaID:@"agw2-avs2-zdzs-25zv-zc"];
        [builder setFirstName:@"Juan"];
        [builder setMiddleName:@"Dela"];
        [builder setLastName:@"Cruz"];
   
    }];
    [ABSEventTracker initWithUser:user];

***********************************************************

**Tracking the Event**
The sample code below will gather all of the event attributes and send to the data lake.
EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Button"];
        [builder setSearchQuery:@"Search..."];
        [builder setReadArticles:@"Philstar"];
        [builder setArticleAuthor:@"Bob Ong"];
        [builder setArticlePostDate:@"June 15, 2017"];
        [builder setCommentContent:@"comment content"];
        [builder setFollowEntity:@"entity"];
        [builder setLikedContent:@"Liked"];
        [builder setMetaTags:@"TAGS"];
        [builder setPreviousScreen:@"previous screen"];
        [builder setScreenDestination:@"screenDestination"];
        [builder setActionTaken:SEARCH];
        [builder setArticleCharacterCount:4];
        [builder setLatitute:120.421412];
        [builder setLongitude:14.2323];
        [builder setDuration:230];
        [builder setRating:23];
    }];
    [ABSEventTracker initEventAttributes:attrib];


**6.2 Swift**
Initializing event tracker library
1.	Go to AppDelegate.swift and initialize the ABSEventTracker at the didFinishLaunchingWithOptions method by calling: 
ABSEventTracker.initializeProperty()

***********************************************************

**Initializing the user**
Implement user builder function after the user’s successful login.
let users = UserAttributes.make { (buider) in
            buider?.gigyaID = "2fca-b507-1246-7eab";
            buider?.firstName = "Juan";
            buider?.middleName = "Dela";
            buider?.lastName = "Cruz";
        }

        ABSEventTracker.initWithUser(users);

***********************************************************

**Tracking the Event**
The sample code below will gather all of the event attributes and send to the data lake.

let events = EventAttributes.make { (builder ) in
            builder?.clickedContent = "link";
            builder?.searchQuery = "query";
            builder?.readArticles = "test";
            builder?.articleAuthor = "testAuthor";
            builder?.articlePostDate = "12/04/2017";
            builder?.commentContent = "Hello";
            builder?.followEntity = "test entity";
            builder?.likedContent = "like ";
            builder?.metaTags = "tags";
            builder?.previousScreen = "scren";
            builder?.screenDestination = "dsww";
            builder?.actionTaken = ActionTaken.LOGIN;
            builder?.articleCharacterCount = 4;
            builder?.latitute = 14.2313;
            builder?.longitude = 121.03231;
            builder?.duration = 12311;
            builder?.rating = 8;
        }
        ABSEventTracker.initEventAttributes(events!)