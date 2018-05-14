class Admin::ReddcoinAddressesController < Admin::BaseController
  before_action :set_address, except: [:index, :new, :create]

  def index
    @addresses = ReddcoinAddress.order('created_at DESC').select(:id, :address, :created_at)
  end

  def new
    @address = ReddcoinAddress.new
  end

  def create
    @address = ReddcoinAddress.new(address_params)
    if @address.save
      return redirect_to(admin_reddcoin_addresses_path, notice: 'Address created')
    end
    render :new
  end

  def destroy
    @address.destroy
    redirect_to(admin_reddcoin_addresses_path, notice: 'Address removed')
  end

  private
  def address_params
    params.require(:reddcoin_address).permit(:address)
  end

  def set_address
    @address = ReddcoinAddress.find(params[:id])
  end
end
