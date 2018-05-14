class Admin::EthAddressesController < Admin::BaseController
  before_action :set_address, except: [:index, :new, :create]

  def index
    @addresses = EthAddress.order('created_at DESC').select(:id, :address, :created_at)
  end

  def new
    @address = EthAddress.new
  end

  def create
    @address = EthAddress.new(address_params)
    if @address.save
      return redirect_to(admin_eth_addresses_path, notice: 'Address created')
    end
    render :new
  end

  def destroy
    @address.destroy
    redirect_to(admin_eth_addresses_path, notice: 'Address removed')
  end

  private
  def address_params
    params.require(:eth_address).permit(:address)
  end

  def set_address
    @address = EthAddress.find(params[:id])
  end
end
