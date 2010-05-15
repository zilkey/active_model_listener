require 'active_record'
require 'active_model_listener/active_model_listener'

module WireUpModels

  def self.included(base)
    base.after_create do |record|
      ActiveModelListener.dispatch record, :create
    end

    base.after_update do |record|
      ActiveModelListener.dispatch record, :update
    end

    base.after_destroy do |record|
      ActiveModelListener.dispatch record, :destroy
    end
  end

end

ActiveRecord::Base.send(:include, WireUpModels)