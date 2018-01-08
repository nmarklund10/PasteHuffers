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
    var grid = new window.DataGrid({
        id: "assignmentGridFor-"+cuid,
        store: store,
        structre: layout
    });
    attchingDiv.appendChild(grid.domNode);
    grid.startup();
}