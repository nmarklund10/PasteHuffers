require 'test_helper'

class ADashControllerTest < ActionController::TestCase
  # def sign_in_as
  #   old_controller = @controller
  #   @controller = ILoginController.new
  #   post :verifyCreds, :id_token => "eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhNGRlZDdmNWE5MjQyOWYyMzM1NjFhMzZmZjYxM2VkMzg3NjJjM2QifQ.eyJhenAiOiI2ODk1MDUzMzczNTQtcTFpYWptamg4a3Vrc3JraHRxa3FzZHNkNDllYmw0OWYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2ODk1MDUzMzczNTQtcTFpYWptamg4a3Vrc3JraHRxa3FzZHNkNDllYmw0OWYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyODM2NTU2ODM5OTkwNjIyNDYiLCJlbWFpbCI6InBhc3RlaHVmZmVydGVzdEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IlV6R084VGV5d1hVRWlxczM0bWpWQlEiLCJleHAiOjE1MTc5ODYwMTcsImlzcyI6ImFjY291bnRzLmdvb2dsZS5jb20iLCJqdGkiOiJmMjEwYTMwMTM2ZGRlYWMxYmJlMjU2NGM0NjExZTQxZDJlYTQ3N2Y1IiwiaWF0IjoxNTE3OTgyNDE3LCJuYW1lIjoiUGFzdGUgaHVmZmVydGVzdCIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vLWI3R3B3RmFGcTBnL0FBQUFBQUFBQUFJL0FBQUFBQUFBQUFBL0FDU0lMalhGaHJydVhQbE8tMHlpaGpzNWtlclRJYVJ0UkEvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6IlBhc3RlIiwiZmFtaWx5X25hbWUiOiJodWZmZXJ0ZXN0IiwibG9jYWxlIjoiZW4ifQ.ZoehpVPZ290n7eonOD5UereIk_iJOBsVqCZ7VQ3zfeI8DOGU3xqLF0JkmcLdszHSTsNuPcgfKddgsbNVGPkNnPWW7rIVYg61-jTIg22oa5lQu0SLPTkbjgjPOYTbB_knEyr2TfxuiEiWJ3a_qIDXGyD684U3JOrdjlkosOB8E_tqB-vvZ_HS4PluVF9Y5_ZHAYrSxfC2kewLCSrl7fa7gCED8gTpLd0_bnKBJDVpwQx2-RNYJLKnPePpvqatPx8bQcv-J08SZq0ZmwqPi8vwQw7SsoeZIFByfWDaWQos7JUOuVqv7qjuBmkiH16j6o-hC9JNN0mkWbbt0FUFne5YOA"
  #   @controller = old_controller
  # end
  # test "IUID 1 returns true" do
  #   sign_in_as
  #   get :index, id: 1, :IUID => 1
  # 	response = JSON.parse(@response.body)
  # 	puts response
  # 	assert_equal true, response["success"]
  # end
    
  test "no IUID returns false" do
    get :index, id: 1
    response = JSON.parse(@response.body)
    assert_equal false, response['success']
  end
end
