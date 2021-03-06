class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  include UsersHelper

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @events_previous = Event.previous
    @events_upcoming = Event.upcoming
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @events_previous = Event.previous
    @events_upcoming = Event.upcoming
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events
  # POST /events.json
  def create
    if current_user.nil?
      redirect_to sign_in_path
    else
      @event = current_user.events.build(event_params)

      @attendees = params[:attendees]
      @attendees&.each do |attendee|
        EventAttendance.create(user: User.find(attendee), event: @event)
      end

      respond_to do |format|
        if @event.save
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
        else
          format.html { render :new }
        end
      end

    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:date, :title, :location, :description)
  end
end
