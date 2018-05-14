class Admin::PivxAddressesController < Admin::BaseController
  before_action :set_address, except: [:index, :new, :create]

  def index
    @addresses = PivxAddress.order('created_at DESC').select(:id, :address, :created_at)
  end

  def new
    @address = PivxAddress.new
  end

  def create
    @address = PivxAddress.new(address_params)
    if @address.save
      return redirect_to(admin_pivx_addresses_path, notice: 'Address created')
    end
    render :new
  end

  def destroy
    @address.destroy
    redirect_to(admin_pivx_addresses_path, notice: 'Address removed')
  end

  private
  def address_params
    params.require(:pivx_address).permit(:address)
  end

  def set_address
    @address = PivxAddress.find(params[:id])
  end
end
