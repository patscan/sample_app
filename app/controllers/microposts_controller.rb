class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  
  def index
    user = User.find(params[:user_id])
    @microposts = user.microposts.paginate(:page => params[:page])
  end
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
   
    if @micropost.save
      route_to_user
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:info] = "Micropost deleted."
    redirect_back_or root_path
  end
  

  
  private
  
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
    
          
    def route_to_user
      reply_to_regex = /^\A[\@][\w]{1,15}\b/  #traps @123456789012345
      reply_to_user = /^\A[\@][\w]{1,15}\z\b/   #traps 123456789012345
      if self =~ reply_to_regex
        # reply_to_user = self[1..-1]
        # add the addressed_to user's id to the in_reply_to column of this object
        # update_attributes(params[:user])
        addressed_to = User.find_by_username(reply_to_user).id
        self.in_reply_to = addressed_to
      end
    end
end
