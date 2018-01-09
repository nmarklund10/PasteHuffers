// Takes in a list of assignments and will then generate the dgrid that holds the assignments
function generateAssignmentsContainer(assignments,cuid)
{
    if(typeof window.tabs[cuid].grid === 'undefined')
    {
        console.log("Creating Grid for "+cuid);
        var data = {
            identifier: "id",
            items : assignments
        }
        var columns = [
            { "label":"AUID",     "field":"id", "width":"200px"},
            { "label":"Name",     "field":"name", "width":"200px"},
            { "label":"Language", "field":"language", "width":"200px"}
        ];
        var grid = new window.Grid({
            columns:columns
        },"grid-" + cuid );
        window.tabs[cuid].grid = grid;
    }
    window.tabs[cuid].grid.refresh();
    window.tabs[cuid].grid.renderArray(assignments);
}

function createNewAssignmentDialog()
{
    if(window.selectedCourse == null)
    {
        console.log("Selected Course is null");
        return;
    }
    if(typeof window.createAssignmentFormDialog !== 'undefined')
    {
        window.createAssignmentFormDialog.show();
        window.dom.byId("newAssignmentName").value = "";
        return;
    }
    window.createAssignmentFormDialog = new window.DojoDialog({title:"Create New Assignment"});
    createAssignmentFormDialog.show();
    sendGetRequestForHTML("/assignments/creationForm", {}, function(response){
        createAssignmentFormDialog.set("content",response);
      });
}

function createNewAssignment()
{
    if(window.selectedCourse == null)
    {
        console.log("Selected course is null!");
        return;
    }
    var assignmentName = window.dom.byId("newAssignmentName").value;
    var assignmentLanguage = dijit.byId("newAssignmentLanguage").attr("value");
    if(assignmentName == "" || assignmentLanguage == "")
    {
        alert("Please supply a name and a language!");
        return;
    }
    sendPostRequest('/assignments/create',{"name": assignmentName, "language": assignmentLanguage, "CUID": window.selectedCourse.id},
        function(response)
        {
            // Will return a copy of the new assignment object
            if(response.success)
            {
                window.selectedTab.assignments.push(response.assignment);
                generateAssignmentsContainer(window.selectedTab.assignments,window.selectedTab.course.id);
                window.createInstructorFormDialog.destroy();
            }
            else
            {
                alert(response.reason);
            }
        });
}