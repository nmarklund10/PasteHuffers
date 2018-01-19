Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  #
  # Login Routes
  #
  #root 'a_dash#index'
  root 'i_login#index'
  post 'ILogin/' => 'i_login#verifyCreds'
  get 'logout/'  => 'i_login#destroy'

  #
  # Dash Board Routes
  #
  get 'courses/' => 'c_dash#getClasses'
  get 'assignments/' => 'assignments#getAssignments'
  get 'dash/' => 'i_dash#index'
  get 's_login/' => 's_login#index'
  get 'submissions/'=> 'submissions#getSubmissions'
  get 'i_login/' => 'i_login#index'
  
  # Student Login Routes
  get 'codeEdit/' => 'ce#index'
  post 'SLogin/' => 's_login#verifyCreds'


  #
  #Form Routes
  #
  get 'instructors/creationForm' => 'instructors#createInstructorForm'
  post 'instructors/create' => 'instructors#createNewInstructor'

  get 'courses/creationForm' => 'c_dash#createCourseForm'
  post 'courses/create' => 'c_dash#createNewCourse'
  post 'courses/delete' => 'c_dash#deleteCourse'

  get 'assignments/creationForm' => 'assignments#createAssignmentForm'
  post 'assignments/create' => 'assignments#createNewAssignment'
  post 'assignments/delete' => 'assignments#deleteAssignment'
  
  get 'submissions/' => 'submissions#getSubmissions'
  get 'a_dash/:id' => 'a_dash#index'
  get 'codeEdit/skelCode' => 'ce#getSkeletonCode'
  post 'codeEdit/test' => 'ce#testCode'
  
  post 'dash/upload' => 'i_dash#upload'
  post 'submissions/submit' => 'submissions#createSubmission'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
