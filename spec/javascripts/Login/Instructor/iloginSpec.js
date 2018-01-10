
describe("Instructor Login Test Suite", function()
{
    beforeEach(function (){
        // Mock form data
        spyOn(window.dom,'byId').and.callFake(function (id){
            if(id == "instrEmail")
            {
                return {value: "email@domain.com"};
            }
            if(id == "password_validate")
            {
                return {value: "instrPassword"};
            }
            return {value: id};
        });
    });
    // Good Login information test
    it("Good Login Information", function()
    {
        spyOn(window, 'sendPostRequest').and.callFake(function (url, data, success){
            success({success:true});
        });
        redirectSpy = spyOnProperty(window,'location',"set");
        sendLoginRequest();
        // Send Post Request should of have been called with 
        expect(window.sendPostRequest).toHaveBeenCalledWith("/ILogin/",{username:"Username", password:"Password"}, jasmine.any(Function));
        expect(redirectSpy).toHaveBeenCalledWith("/dash/");
    });
});