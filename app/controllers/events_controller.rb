class EventsController < ApplicationController
  before_action :authorize_admin!, except: [:index]

  def index
    @events = Event.all.includes(:team)
    @upcoming_events = @events.upcoming_events.order(:date)
    @past_events = @events.past_events.order("date DESC")
    @today_event = @events.today_event.first
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event
    else
      @errors = @event.errors.full_messages
      render json: { errors: @errors },  status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path, notice: "Event successfully updated!"
    else
      flash.now[:notice] = "Event could not be saved..."
      @errors = @event.errors.full_messages
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Event was deleted"
  end

  private

  def event_params
    params.require(:event).permit(:date, :team_id, :location)
  end
end
