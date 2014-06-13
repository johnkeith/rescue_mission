class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end

  def new 
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to '/questions'
    else
      flash.now[:notice] = "Your question was invalid. Try again!"
      render :new
    end
  end

  def question_params
    params.require(:question).permit(:title, :description)
  end

end
