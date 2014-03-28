class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all(:conditions => {:active => true})
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end


  def inactive
    @jobs = Job.all(:conditions => {:active => false})
  end

  # restart an inactive job
  def restart
    @job = Job.find(params[:job])
    if !(rufus_id = JobScheduler.schedule(@job)).nil?
      @job.update(active: true)
      @job.update(rufus_id: rufus_id)
      redirect_to "/inactive"
    else
      redirect_to "/inactive"
    end
  end


  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        if !(rufus_id = JobScheduler.schedule(@job)).nil? 
          @job.update(rufus_id: rufus_id)
          @job.update(active: true)
          format.html { redirect_to @job, notice: 'Job was successfully scheduled.' }
          format.json { render action: 'show', status: :created, location: @job }
        else
          @job.destroy
          format.html { render action: 'new' }
          format.json { render json: @job.errors, status: :unprocessable_entity }
        end
      else

        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    JobScheduler.unschedule(@job)
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  def history
    @history = JobHistory.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:title, :command, :cron_input)
    end
  end
