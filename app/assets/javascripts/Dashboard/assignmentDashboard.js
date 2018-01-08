// Takes in a list of assignments and will then generate the accordion container that holds the assignments
function generateAssignmentsContainer(assignments,cuid, attchingDiv)
{
    if(assignments.length == 0)
    {
        return "";
    }
    var data = {
        identifier: "id",
        items : assignments
    }
    var layout = [[
        { "name":"AUID",     "field":"id",            "width":"100px"},
        { "name":"Name",     "field":"name",          "width":"300px"},
        { "name":"Assigned", "field":"date_assigned", "width":"300px"},
        { "name":"Due",      "field":"date_due",      "width":"300px"}
    ]];
    var store = new window.ItemFileWriteStore({data:data});
    window.assignmentStores[cuid] = store;
    var grid = new window.DataGrid({
        id: "assignmentGridFor-"+cuid,
        store: store,
        structre: layout
    });
    attchingDiv.appendChild(grid.domNode);
    grid.startup();
    
}

function createNewAssignmentDialog()
{
    if(window.selectedCourse == null)
    {
        console.log("Selected Course is null");
        return;
    }
    if(typeof window.createInstructorFormDialog !== 'undefined')
    {
        createInstructorFormDialog.show();
        window.dom.byId("newAssignmentName").value = "";
    }
    window.createInstructorFormDialog = new window.DojoDialog({title:"Create New Assignment"});
    createInstructorFormDialog.show();
    sendGetRequestForHTML("/assignments/creationForm", {}, function(response){
        createInstructorFormDialog.set("content",response);
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
    if(assignmentName == "" || assignmentLanguage)
    {
        alert("Please supply a name and a language!");
    }
    sendPostRequest('/assignments/create',{"name": assignmentName, "language": assignmentLanguage, "CUID": window.selectedCourse.id},
        function(response)
        {
            // Will return a copy of the new assignment object
            if(response.success)
            {
                window.assignmentStores[window.selectedCourse.id].put(response.assignment);
                window.createInstructorFormDialog.destroy();
            }
            else
            {
                alert(response.reason);
            }
        });
}