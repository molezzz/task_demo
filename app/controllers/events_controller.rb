class EventsController < ApplicationController
  include UserAuth

  before_action :set_event, only: [:show, :edit, :update, :destroy]


  # GET /events
  # GET /events.json
  def index
    user = current_user

    # note 这里实现的是获取用户有权访问的项目
    #      也可以实现成按Team查看
    @projects = Hash[user.projects.select(:id, :key, :title).map { |pj| [pj.id, pj] }]

    respond_to do |format|
      format.html do
        @team_members = user.team_brothers.select(:key,:name,:team_id)
      end

      format.json do
        now = Time.zone.now
        today_range = now.beginning_of_day..now.end_of_day
        yesterday_range = (now - 1.day).beginning_of_day..(now - 1.day).end_of_day
        member = User.where(key: params[:member]).first if params[:member]
        #todo 检查是否有权查看另外用户的动态


        #进行两次查找，首先找是否有今天和昨天的，如果没有，则显示更早的
        chain = Event.select('events.*','todos.project_id')
                     .joins(:todo)
                     .where(todos: { project_id: @projects.keys})
                     .order(created_at: :desc)
        #按成员筛选
        chain = chain.where(source_id: member.id) if member

        events = chain.where(created_at: yesterday_range.first..today_range.last)
        events = chain if events.empty?

        #对事件进行分组
        events_with_group = {}
        events.includes(:source)
              .paginate(page: params[:page], per_page: 50).collect do |event|
                day , time = event.created_at.strftime('%Y-%m-%d|%H:%M').split('|')
                events_with_group[day] ||= {}
                events_with_group[day][time] ||= []
                events_with_group[day][time] << {
                  id: event.id,
                  kind: event.kind,
                  user: {
                    name: event.source.try(:name),
                    key: event.source.try(:key)
                  },
                  title: event.title,
                  content: event.content,
                  created_at: event.created_at,
                  project_id: event.project_id
                }
              end

        render json: events_with_group
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
