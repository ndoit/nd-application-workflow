class PrecsController < ApplicationController
  before_action :set_prec, only: [:show, :edit, :update, :destroy]

  # GET /precs
  # GET /precs.json
  def index
    @precs = Prec.all
  end

  # GET /precs/1
  # GET /precs/1.json
  def show
  end

  # GET /precs/new
  def new
    @prec = Prec.new
  end

  # GET /precs/1/edit
  def edit
  end

  # POST /precs
  # POST /precs.json
  def create
    @prec = Prec.new(prec_params)

    respond_to do |format|
      if @prec.save
        format.html { redirect_to @prec, notice: 'Prec was successfully created.' }
        format.json { render :show, status: :created, location: @prec }
      else
        format.html { render :new }
        format.json { render json: @prec.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /precs/1
  # PATCH/PUT /precs/1.json
  def update
    respond_to do |format|
      if @prec.update(prec_params)
        format.html { redirect_to @prec, notice: 'Prec was successfully updated.' }
        format.json { render :show, status: :ok, location: @prec }
      else
        format.html { render :edit }
        format.json { render json: @prec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /precs/1
  # DELETE /precs/1.json
  def destroy
    @prec.destroy
    respond_to do |format|
      format.html { redirect_to precs_url, notice: 'Prec was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prec
      @prec = Prec.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prec_params
      params.require(:prec).permit(:prec_desc)
    end
end
