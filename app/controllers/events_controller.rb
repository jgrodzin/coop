class EventsController < ApplicationController
  def index
    @events = Event.all.order("date DESC")
  end
end
