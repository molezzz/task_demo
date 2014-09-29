class EventsController < ApplicationController
  include UserAuth

  before_action :set_event, only: [:show, :edit, :update, :destroy]


  # GET /events
  # GET /events.json
  def index
    user = current_user

    respond_to do |format|
      format.html do
        @team_members = user ? user.team_brothers.select(:key,:name,:team_id) : []
      end

      format.json do
        now = Time.zone.now
        today_range = now.beginning_of_day..now.end_of_day
        yesterday_range = (now - 1.day).beginning_of_day..(now - 1.day).end_of_day
        if params[:member]
          members = User.select(:id).where(key: params[:member])
        else
          #查看同一Team的人的动态
          members = user.team_brothers.select(:id)
        end
        #todo 检查是否有权查看另外用户的动态


        #进行两次查找，首先找是否有今天和昨天的，如果没有，则显示更早的
        chain = Event.where(source_id: members.collect{|m| m.id})
                     .includes(eventable: :project)
                     .order(created_at: :desc)

        @events = chain.where(created_at: yesterday_range.first..today_range.last)
        @events = chain if @events.empty?


        @events = @events.includes(:source)
                         .paginate(page: params[:page], per_page: 50)

        @cache_key = ['v1', user.cache_key, params[:page]]

        render :index
      end

    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:kind, :source_id, :target, :target_id, :data)
    end
end
