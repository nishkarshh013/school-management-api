class Api::V1::BatchesController < ApplicationController
  def index
    batches = policy_scope(Batch)
    render json: batches
  end

  def show
    batch = Batch.find(params[:id])
    authorize batch
    render json: batch
  end

  def create
    batch = Batch.new(batch_params)
    authorize batch
    batch.save!
    render json: batch, status: :created
  end

  def update
    batch = Batch.find(params[:id])
    authorize batch
    batch.update!(batch_params)
    render json: batch
  end

  def students
    batch = Batch.find(params[:id])
    authorize batch, :show?

    students = batch
      .enrollments
      .approved
      .includes(:student)
      .map do |enrollment|
        {
          id: enrollment.student.id,
          email: enrollment.student.email,
          progress: enrollment.progress
        }
      end

    render json: students
  end

  private

  def batch_params
    params.require(:batch).permit(:name, :course_id)
  end
end
