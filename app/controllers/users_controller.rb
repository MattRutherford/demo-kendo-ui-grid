class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def paginated
    @users = User.paginate(page: params[:page], per_page: params[:pageSize])
    @total = @users.count #.total_pages
  end

  def paginated_sort
    @users = User.all
    if(params['sort'])
      # Prepare to build a list of one or more sort criteria
      order_args = []
      params['sort'].each_pair do |k, v|
        # Add each cloumn and sort direction to the argument list
        order_args.push("#{v[:field]} #{v[:dir]}")
      end
      # Join the array to return a string in the required format as a single argument
      # eg: @users.order("name asc, age asc, email asc")
      @users = @users.order(order_args.join(', '))
    end
    @users = @users.paginate(page: params[:page], per_page: params[:pageSize])
    @total = @users.count #.total_pages
    render :paginated
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :age, :email)
    end
end
