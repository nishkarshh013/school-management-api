class Api::V1::EnrollmentsController < ApplicationController

  def create
    enrollment = Enrollment.new(enrollment_params.merge(student: current_user))
    authorize enrollment
    enrollment.save!
    render json: enrollment, status: :created
  end

  def approve
    enrollment = Enrollment.find(params[:id])
    authorize enrollment, :approve?
    enrollment.update!(status: :approved)
    render json: enrollment
  end

  def reject
    enrollment = Enrollment.find(params[:id])
    authorize enrollment, :reject?
    enrollment.update!(status: :rejected)
    render json: enrollment
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:batch_id)
  end
end
