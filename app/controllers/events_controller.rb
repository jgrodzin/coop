class EventsController < ApplicationController
  before_action :authorize_admin!, except: [:index, :show]

  def index
    @events = Event.all.includes(:team)
    @upcoming_events = @events.upcoming_events.order(:date)
    @past_events = @events.past_events.order("date DESC")
    @today_event = @events.today_event.first
  end

  def show
    @event = Event.find(params[:id])
    @products = @event.products.order(:name).includes(:vendor).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to events_path, notice: "Event successfully created"
    else
      flash.now[:alert] = "Could not save event"
      @errors = @event.errors.full_messages
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    @products = @event.products.includes(:vendor)
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

  # def shopping_cart_history
  #   @carts = Event.find(params[:id]).shopping_carts
  # end

  private

  def event_params
    params.require(:event).permit(:date, :team_id, :location)
  end
end
