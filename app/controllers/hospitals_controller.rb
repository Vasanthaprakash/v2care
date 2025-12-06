class HospitalsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_doctor!
  before_action :set_hospital, only: [:edit, :update, :destroy, :show]

  def index
    @hospitals = current_user.hospitals
  end

  def new
    @hospital = Hospital.new
  end

  def show
  end

  def create
    @hospital = current_user.hospitals.build(hospital_params)

    if @hospital.save
      redirect_to hospitals_path, notice: "Hospital created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @hospital.update(hospital_params)
      redirect_to hospitals_path, notice: "Hospital updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hospital.destroy
    redirect_to hospitals_path, notice: "Hospital deleted successfully."
  end

  private

  def set_hospital
    @hospital = current_user.hospitals.find(params[:id])
  end

  def hospital_params
    params.require(:hospital).permit(
      :name, :address, :hospital_type, :specialization,
      :opening_time, :closing_time, :slots, :city
    )
  end

  def ensure_doctor!
    redirect_to root_path, alert: "Access denied" unless current_user.doctor?
  end
end
