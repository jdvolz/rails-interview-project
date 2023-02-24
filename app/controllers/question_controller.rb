class QuestionController < ApplicationController
  before_action :require_header, only: [:index]
  
  def index
    question_and_answers = Question.includes(:user, :answers => :user).where(private: false)
    if params[:keyword].present?
      question_and_answers = question_and_answers.where("questions.title like '%' || ? || '%'", params[:keyword])
    end

    json_hash = question_and_answers.map do |qaa|
      {
        id: qaa.id,
        title: qaa.title,
        user_id: qaa.user_id,
        user_name: qaa.user.name,
        answers: qaa.answers.map do |a|
          {
            id: a.id,
            body: a.body,
            user_id: a.user_id,
            user_name: a.user.name,
          }
        end
      }
    end

    render json: json_hash.to_json
  end

  def home
    @questions_count = Question.count
    @answers_count = Answer.count
    @tenants = Tenant.all
    @tenants_count = @tenants.count
  end

  def require_header
    api_key = request.headers["api_key"] # existence implies that it is valid in this case
    tenant = Tenant.where(api_key: api_key).first

    unless tenant
      render json: {message: 'Not authorized'}, status: 401
    else
      tenant.api_request_count += 1
      tenant.save
    end
  end
end
