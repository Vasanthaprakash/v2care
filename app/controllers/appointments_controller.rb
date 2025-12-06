class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.doctor?
      @appointments = current_user.doctor.appointments.order(:appointment_time)
    else
      @appointments = current_user.patient.appointments.order(:appointment_time)
    end
  end

  def new
    @appointment = Appointment.new
    @doctors = Doctor.all
  end

  def create
    @appointment = Appointment.new(appt_params)
    @appointment.patient = current_user.patient
    @appointment.status = "pending"

    if @appointment.save
      AppointmentMailer.new_appointment(@appointment).deliver_later
      redirect_to appointments_path, notice: "Appointment requested!"
    else
      render :new
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def appt_params
    params.require(:appointment).permit(:doctor_id, :appointment_time, :notes)
  end
end
