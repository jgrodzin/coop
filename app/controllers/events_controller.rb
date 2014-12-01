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

  def edit
    @event = Event.find(params[:id])
    @teams = Team.all
    @locations = Member.all.map(&:address)
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)

    if @event.valid?
      @event.save!
      redirect_to events_path, notice: "Event successfully updated!"
    else
      flash[:notice] = "Event could not be saved..."
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
