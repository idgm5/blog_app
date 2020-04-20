# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash.notice = "Tag '#{@tag.name}' Deleted!"
    redirect_to action: :index
  end

  def show
    @tag = Tag.find(params[:id])
  end
end
