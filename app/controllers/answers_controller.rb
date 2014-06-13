class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    # @answer = Answer.new(answer_params)
    # @answer.question = @question

    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to "/questions/#{@question.id}"
    else
      # flash.now[:notice] = "Your answer is too short!"
      # @errors = @answer.errors

      render :'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:description)
  end
end
