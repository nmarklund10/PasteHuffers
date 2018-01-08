function catchGenericError (error) {
    console.log(error);
    window.alert("An error occured on the server.");
}

function sendPostRequest(url, data, success, error=catchGenericError)
{
    var options = {
        "data":data,
        headers:{'X-CSRF-Token':document.querySelector('meta[name="csrf-token"]').content},
        handleAs:"json"
    };
    request.post(url,options).then(success,error);
}
function sendGetRequestForJSON(url,query,success,error=catchGenericError)
{
    sendGetRequest(url,query,success,true,error);
}
function sendGetRequestForHTML(url,query,success,error=catchGenericError)
{
    sendGetRequest(url,query,success,false,error);
}
function sendGetRequest(url, query, success, handleAsJson = false, error=catchGenericError)
{
    var options = {"query":query};
    if(handleAsJson)
    {
        options["handleAs"] = "json";
    }
    request.get(url,options).then(success,error);
}