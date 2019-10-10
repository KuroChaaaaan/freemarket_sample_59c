class ItemsController < ApplicationController
  require 'payjp'
  before_action :authenticate_user!, except: :index
  layout 'application.users', except: [:index,:show]
  def index
    @ladies_items = Item.where(category_id: 1).order("created_at DESC").limit(10)
    @mens_items = Item.where(category_id: 200).order("created_at DESC").limit(10)
    @item = Item.find(1)    
  end

  def new
    @item = Item.new
    @item.images.build
    @category_parent = Category.where(ancestry: nil)
  end

  def buy

    @card = Card.where(user_id: current_user.id).first
    if @card.present?
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(@card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(@card.card_id)
    else
      #登録された情報がない場合にカード登録画面に移動
      redirect_to controller: "card", action: "show"
    end
  end



  def create
    @item = Item.new(params_new)
    @item.images.build
    if @item.save
      redirect_to root_path
    else
      redirect_to new_item_path
    end
  end

  def edit
  end

  # 削除
  def destroy
    @item = Item.find(params[:id])
    # if @item.user_id == current_user.id
      @item.destroy
    # end
    redirect_to profile_users_path
  end

  def show
  end

  def pay
    @item = Item.find(2)
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    Payjp::Charge.create(
    amount: @item.price,
    customer: card.customer_id,
    currency: 'jpy',
  )
  redirect_to action: 'complete' #完了画面に移動
  end

  private
  
  def params_new
    params.require(:item).permit(
      :title, 
      :description, 
      :category_id, 
      :brand, 
      :condition, 
      :region, 
      :shipping_fee_burden, 
      :shipping_method, 
      :shipping_duration, 
      :price,
      images_attributes: [:id,:image]
    ).merge(user_id: current_user.id)
  end 
end
