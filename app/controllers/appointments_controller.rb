class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospital, only: [:new, :create]
  before_action :set_appointment, only: :show

  def index
    @appointments = current_user.appointments.includes(:hospital)
                                .order(appointment_time: :asc)
  end

  def new
    @appointment = Appointment.new
    @selected_date = params[:date] ? Date.parse(params[:date]) : Date.current

    @slots = generate_slots(@hospital, @selected_date)
    @booked_slots = booked_slots_for(@hospital, @selected_date)
  end

  def create
    @hospital = Hospital.find(params[:hospital_id])
    @selected_date = params[:appointment][:appointment_date].to_date

    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    @appointment.hospital = @hospital
    @appointment.appointment_time = Time.zone.parse(
      "#{@selected_date} #{params[:appointment][:slot_time]}"
    )

    if @appointment.save
      redirect_to @appointment, notice: "Appointment booked successfully!"
    else
      # Rebuild everything required for the new form
      @slots = generate_slots(@hospital, @selected_date)
      @booked_slots = booked_slots_for(@hospital, @selected_date)

      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_hospital
    @hospital = Hospital.find(params[:hospital_id])
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    date = params[:appointment][:appointment_date].to_date
    time = params[:appointment][:slot_time]

    {
      hospital_id: @hospital.id,
      appointment_time: DateTime.parse("#{date} #{time}"),
      status: "confirmed",
      notes: params[:appointment][:notes]
    }
  end

  # Returns booked times for a specific date
  def booked_slots_for(hospital, date)
    Appointment.where(
      hospital_id: hospital.id,
      appointment_time: date.beginning_of_day..date.end_of_day
    ).pluck(:appointment_time).map { |t| t.strftime("%H:%M") }
  end

  # Generates slots for the selected date
  def generate_slots(hospital, date)
    start_time = hospital.opening_time
    end_time   = hospital.closing_time
    count      = hospital.slots

    return [] if start_time.blank? || end_time.blank? || count.blank?

    total_minutes = ((end_time - start_time) / 60).to_i
    slot_length   = total_minutes / count

    slots = []
    current_time = start_time

    count.times do
      slots << current_time.strftime("%H:%M")
      current_time += slot_length.minutes
    end

    slots
  end
end
