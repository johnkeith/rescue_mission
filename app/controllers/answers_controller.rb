class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    # @answer = Answer.new(answer_params)
    # @answer.question = @question
    # the below is a way of stating the above more quickly
    # build is just an alias for new
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to "/questions/#{@question.id}"
    else
      render :'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:description)
  end
end
