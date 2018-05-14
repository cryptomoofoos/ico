class Admin::BtcAddressesController < Admin::BaseController
  before_action :set_address, except: [:index, :new, :create]

  def index
    @addresses = BtcAddress.order('created_at DESC').select(:id, :address, :created_at)
  end

  def new
    @address = BtcAddress.new
  end

  def create
    @address = BtcAddress.new(address_params)
    if @address.save
      return redirect_to(admin_btc_addresses_path, notice: 'Address created')
    end
    render :new
  end

  def destroy
    @address.destroy
    redirect_to(admin_btc_addresses_path, notice: 'Address removed')
  end

  private
  def address_params
    params.require(:btc_address).permit(:address)
  end

  def set_address
    @address = BtcAddress.find(params[:id])
  end
end
