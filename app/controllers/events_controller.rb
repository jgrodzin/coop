class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming_events.order(:date)
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
    @past_events = Event.past_events.order("date DESC")
    @today_event = Event.today_event.first
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

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
