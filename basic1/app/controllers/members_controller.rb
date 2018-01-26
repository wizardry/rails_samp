class MembersController < ApplicationController
  before_action :login_required
  def index
    @members = Member.order("number")
      .paginate(page: params[:page], per_page: 5)
  end

  def search
    @members = Member.search(params[:q]).paginate(page: params[:page], per_page: 5)
    render "index"
  end

  def show
    @member = Member.find(params[:id])
    if params[:format].in?(["jpg","png","gif"])
      send_image
    else
      render "show"
    end
  end

  def new
    @member = Member.new(birthday: Date.new(1980, 1, 1))
    @member.build_image
  end

  def edit
    @member = Member.find(params[:id])
    @member.build_image unless @member.image
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member, notice: "登録完了しました"
    else
      render "new"
    end
  end

  def update
    puts(params[:id])
    @member = Member.find(params[:id])
    @member.assign_attributes(member_params)
    if @member.save
      redirect_to @member, notice: "更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to :members, notice: "削除が完了しました"
  end

  private
  def member_params
    attrs = [:number, :name, :full_name, :gender, :birthday, :email, :password, :password_confirmation]
    attrs << :administrator if current_member.administrator?
    attrs << {image_attributes: [:_destroy, :id, :uploaded_image]}
    params.require(:member).permit(attrs)
  end

  def send_image
    if @member.image.present?
      send_data @member.image.data,
      type: @member.image.content_type, disposition: "inline"
    else
      raise NotFound
    end
  end

end
