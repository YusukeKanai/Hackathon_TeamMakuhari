class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  SEARCH_RADIUS_IN_KM = 0.100

  def coord
    @nodes = Node.includes(:links).near([coord_params[:lat], coord_params[:lng]], SEARCH_RADIUS_IN_KM, units: :km)
    render :index
  end

  def import
    Node.import(params[:file])
    redirect_to nodes_path, notice: "Import success!"
  end

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.includes(:links).all
  end

  # GET /nodes/map
  def map
    render :map
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.includes(:links).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:node_id, :latitude, :longitude)
    end

    def coord_params
      params.permit(:lat, :lng)
    end
end
