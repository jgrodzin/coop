class EventsController < ApplicationController
  def index
    @events = Event.all.order("date DESC")
  end

  def new
    @event = Event.new
    @teams = Team.all
    @locations = Member.all.map(&:address)
  end

  def create
    @event = Event.create(event_params)

    if @event.save
      redirect_to events_path, notice: "Event successfully created"
    else
      flash.now[:alert] = "Could not save event...."
      @errors = @event.errors.full_messages
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:date, :team_id, :location)
  end
end
