class Api::V1::UsersController < ApiController
  before_action :authenticate_users!, only: [:update]

  api :GET, '/v1/users/', 'List of resources: User'
  formats %w(json)
  description 'Returns a list of registered users with URL\'s to #show for each instance'
  example %q({
   "users":[
      {
         "id":1,
         "user_name":"Thomas Ochman",
         "created_at":"2016-02-22T17:46:07.045Z",
         "profile":"http://localhost:3000/api/v1/users/1"
      },
      {
         "id":2,
         "user_name":"Anders Andersson",
         "created_at":"2016-02-22T17:46:24.915Z",
         "profile":"http://localhost:3000/api/v1/users/2"
      }
   ]
  })

  def index
    @users = User.all
  end

  api :GET, '/v1/users/:id', 'Show a :resource'
  formats %w(json)
  description 'Returns an instance of user'
  example %q({
   "user":{
      "id":1,
      "user_name":"Thomas Ochman",
      "created_at":"2016-02-22T17:46:07.045Z"
   }
  })

  def show
    @user = User.find(params[:id])
  end

  api :GET, '/v1/unify/:id', 'Show a list of matches for :resource'
  formats %w(json)
  description 'Returns an instance of user with an array of matched users'
  example %q({
   "user":{
      "id":1,
      "user_name":"Thomas Ochmane333",
      "skills":[
         "agile",
         "html",
         "management",
         "rspec",
         "test2",
         "test",
         "java"
      ],
      "created_at":"2016-02-22T17:46:07.045Z"
   },
   "matches":[
      {
         "user":{
            "id":2,
            "user_name":"Anders Andersson",
            "created_at":"2016-02-22T17:46:24.915Z",
            "skills":[
               "rspec",
               "html",
               "test",
               "management"
            ],
            "profile":"http://localhost:3000/api/v1/users/2"
         }
      },

      {
         "user":{
            "id":5,
            "user_name":"Kalle",
            "created_at":"2016-02-23T12:04:27.736Z",
            "skills":[
               "java",
               "html",
               "javascript"
            ],
            "profile":"http://localhost:3000/api/v1/users/5"
         }
      }
   ]
  })

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user == user
      if user.update_attributes(user_params)
        render json: user, status: :ok
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'Not authorized update User' }, status: :unauthorized
    end
  end

  def unify
    @user = User.find(params[:id])
    @unified_users = @user.unify
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :mentor)
  end
end
