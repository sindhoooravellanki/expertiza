class MarkupStylesController < ApplicationController
require 'aquarium'

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
    @markup_styles = MarkupStyle.paginate(:page => params[:page],:per_page => 10)
  end

  def show
    @markup_style = MarkupStyle.find(params[:id])
  end

  def new
    @markup_style = MarkupStyle.new
  end

  def create
    @markup_style = MarkupStyle.new(params[:markup_style])
    begin
    @markup_style.save!
      flash[:notice] = 'MarkupStyle was successfully created.'
      redirect_to :action => 'list'
    rescue
      render :action => 'new'
    end
  end

  def edit
    @markup_style = MarkupStyle.find(params[:id])
  end

  def update
    @markup_style = MarkupStyle.find(params[:id])
    if @markup_style.update_attributes(params[:markup_style])
      redirect_to :action => 'show', :id => @markup_style
      flash[:notice] = 'MarkupStyle was successfully updated.'
    else
      render :action => 'edit'
    end
  end

  def destroy
    MarkupStyle.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

include Aquarium::DSL
  around :methods => [:index, :list, :show, :new, :create, :edit, :update, :destroy] do |join_point, object, *args|
    logger.info "[info] Entering: #{join_point.target_type.name}##{join_point.method_name}: object = #{object}, args = #{args}" 
    result = join_point.proceed
    logger.info "[info] Leaving: #{join_point.target_type.name}##{join_point.method_name}: object = #{object}, args = #{args}" 
    result  # block needs to return the result of the "proceed"!
  end

end
