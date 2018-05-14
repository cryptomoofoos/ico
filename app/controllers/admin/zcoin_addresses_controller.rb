class Admin::ZcoinAddressesController < Admin::BaseController
  before_action :set_address, except: [:index, :new, :create]

  def index
    @addresses = ZcoinAddress.order('created_at DESC').select(:id, :address, :created_at)
  end

  def new
    @address = ZcoinAddress.new
  end

  def create
    @address = ZcoinAddress.new(address_params)
    if @address.save
      return redirect_to(admin_zcoin_addresses_path, notice: 'Address created')
    end
    render :new
  end

  def destroy
    @address.destroy
    redirect_to(admin_zcoin_addresses_path, notice: 'Address removed')
  end

  private
  def address_params
    params.require(:zcoin_address).permit(:address)
  end

  def set_address
    @address = ZcoinAddress.find(params[:id])
  end
end
