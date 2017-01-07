class ParentRecordsController < ApplicationController
  include NdApplicationWorkflow::NdWorkflowsHelper
  before_action :set_parent_record, only: [:show, :edit, :update, :destroy]

  # GET /parent_records
  def index
    @parent_records = ParentRecord.all
  end

  # GET /parent_records/1
  def show
  end

  # GET /parent_records/new
  def new
    @parent_record = ParentRecord.new
    @parent_record.nd_workflow_approval_available = true
    if params.has_key? 'approval_flag'
      if params[:approval_flag] == 'false'
        @parent_record.nd_workflow_approval_available = false
      end
    end
    @parent_record.nd_workflow_include_email_detail_cb = true
    if params.has_key? 'email_detail_cb_flag'
      if params[:email_detail_cb_flag] == 'false'
        @parent_record.nd_workflow_include_email_detail_cb = false
      end
    end
  end

  # GET /parent_records/1/edit
  def edit
  end

  # POST /parent_records
  def create
    @parent_record = ParentRecord.new(parent_record_params)
    if @parent_record.save
      # Add an automatic approval_notes
      @parent_record.add_auto_approvals

      redirect_to @parent_record, notice: 'Parent record was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parent_records/1
  def update
    if @parent_record.update(parent_record_params)
      redirect_to @parent_record, notice: 'Parent record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parent_records/1
  def destroy
    @parent_record.destroy
    redirect_to parent_records_url, notice: 'Parent record was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent_record
      @parent_record = ParentRecord.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def parent_record_params
      params.require(:parent_record).permit(:parent_desc, :nd_workflow_approval_available, :nd_workflow_include_email_detail_cb, :nd_workflows_attributes => nd_workflows_attributes)
    end


end
