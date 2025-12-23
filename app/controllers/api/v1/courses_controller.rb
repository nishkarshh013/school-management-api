class Api::V1::CoursesController < ApplicationController
  def index
    courses = policy_scope(Course)
    render json: courses
  end

  def show
    course = Course.find(params[:id])
    authorize course
    render json: course
  end

  def create
    course = Course.new(course_params)
    authorize course
    course.save!
    render json: course, status: :created
  end

  def update
    course = Course.find(params[:id])
    authorize course
    course.update!(course_params)
    render json: course
  end

  private

  def course_params
    params.require(:course).permit(:name, :school_id)
  end
end
