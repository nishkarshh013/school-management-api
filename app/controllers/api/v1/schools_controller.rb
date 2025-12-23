class Api::V1::SchoolsController < ApplicationController

  before_action :authenticate_request

  def index
    authorize School
    schools = policy_scope(School)
    render json: schools
  end

  def show
    school = School.find(params[:id])
    authorize school
    render json: school
  end

  def create
    school = School.new(school_params)
    authorize school
    school.save!
    render json: school, status: :created
  end

  def update
    school = School.find(params[:id])
    authorize school
    school.update!(school_params)
    render json: school
  end

  private

  def school_params
    params.require(:school).permit(:name, :address)
  end
end
