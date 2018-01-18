/* ********************************************************
*  Setup Code                                             *
***********************************************************/
/*dashBoardSetup is set as window.setup by dashboard.html
  it will query for the course creation form and all the courses and call addCourseToContainer and placeTabContainer
*/
function dashBoardSetup()
{
    // Create Tab Container and set up SYNC flags
    window.centerContainer = new window.TabContainer({style:"height:100%;", doLayout:false});
    window.newCourseFormAdded = false;
    window.startedCourses = false;
    window.alreadyPlaced = false;
   
    // Set up create new course form first
    sendGetRequestForHTML('/courses/creationForm',{},
        function(response)
        {
            window.centerContainer.addChild(new window.ContentPane({title:"Create a New Course", content:response}));
            window.newCourseFormAdded = true;
        });

    // GET the courses for the session, the add a new tab and SYNC flag for each, then place the tab container
    sendGetRequestForJSON("/courses/",{},
        function(courses){
            // Set Global objects
            window.courses = courses;
            window.tabs = {};
            // Set up SYNC flags
            for(var i in courses)
            {
                window.tabs[courses[i].id] = {course: courses[i]};
            }
            window.coursesCompleted = [];
            for (var i=0;i<courses.length; i++)
            {
                window.coursesCompleted.push(false);
                addCourseToCenterContainer(courses[i],i);
            }
            placeTabContainer();
        });
}
/*
When called, will attempt to place the TabContainer for the dashboard
If the flag signifying that the tabContainer has already been placed is true then nothing happens
If any of the SYNC flags are false then nothing happens.
When placing the tab container, we add an event listener that keeps track of the currently selected tab and course with:
     and window.selectedTab
*/
function placeTabContainer()
{
    // Check SYNC flags
    if(window.newCourseFormAdded)
    {
        if (window.courses.length != 0)
        {
            if(window.coursesCompleted.every(function(t){return t}) == false)
            {
                return;
            }
        }
        // Check Placement flag
        if(window.alreadyPlaced)
        {
            return;
        }
        // Plce the tab container
        window.centerContainer.placeAt("centerContainer");
        window.centerContainer.startup();
        window.centerContainer.resize();

        // Add in out selection listeners
        centerContainer.watch("selectedChildWidget", function(name, oval, nval){
            for (var i in window.courses)
            {
                // Set the currently selected tab/course
                if (window.courses[i].name == nval.title)
                {
                    window.selectedCourse = window.courses[i];
                    window.selectedTab = window.tabs[window.courses[i].id];
                    generateAssignmentsContainer(window.selectedTab.assignments,window.courses[i].id);
                    return;
                }
            }
            window.selectedCourse = null;
            window.selectedTab = null;
            window.centerContainer.resize();
        });
    }
}

/*
Adds a tab for a given course c to the tab container
if given a non-negative indexForLoadup will set the SYNC flag with that index
Still queries the backend for the course to ensure that course exists in the DB
*/
function addCourseToCenterContainer(c, indexForLoadup=-1)
{
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
            // Create the inner html for the tab
            var innerDivId = "grid-"+courseAssignMentDict.course.id;
            var innerContent ='<button data-dojo-type="dijit/form/Button" id="newAssignButton'+courseAssignMentDict.course.id+'" onclick="createNewAssignmentDialog();">Create new assignment</button><div id="'+innerDivId+'" ></div>';
            var contentPaneForTab = new window.ContentPane({title:courseAssignMentDict.course.name,
                                                            content:innerContent, 
                                                            id:"tab-"+courseAssignMentDict.course.id,
                                                            style:"width:auto; height:auto;"})
            window.centerContainer.addChild(contentPaneForTab);
            window.tabs[courseAssignMentDict.course.id].contentPane = contentPaneForTab;
            window.tabs[courseAssignMentDict.course.id].assignments = courseAssignMentDict.assignments;
            // Set the SYNC flag
            if(indexForLoadup > -1)
            {
                window.coursesCompleted[indexForLoadup] = true;
                placeTabContainer();
            }
    });    
}

