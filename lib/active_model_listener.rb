require 'activerecord'
require 'active_model_listener/active_model_listener'

module WireUpModels

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    def inherited(child)
      super

      child.after_create do |record|
        ActiveModelListener.dispatch record, :create
      end

      child.after_update do |record|
        ActiveModelListener.dispatch record, :update
      end

      child.after_destroy do |record|
        ActiveModelListener.dispatch record, :destroy
      end
    end
  end

end

ActiveRecord::Base.send(:include, WireUpModels)