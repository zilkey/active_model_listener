# ActiveModelListener

Simple, global ActiveRecord event observers, using a middleware architecture, that can easily be turned on and off.  Designed for audit trails, activity feeds and other application-level event handlers.

## Installation

The gem is hosted at gemcutter.  You can either add gemcutter as a source, or you can make gemcutter your default source (recommended):

    gem install gemcutter
    gem tumble

Then, install it like any other gem:

    gem install active_model_listener

## Usage

First, require Active Model Listener above your rails initializer:

    # environment.rb
    require 'active_model_listener'
    Rails::Initializer.run do |config|
      # ...
    end

Add the listeners to the ActiveModelListener in an initializer:

    # config/initializers/active_model_listener.rb
    ActiveModelListener.listeners << ActivityFeedListener

Then, create a listener class that defines methods for after_create, after_update and after_destroy:

    class ActivityFeedListener
      class << self
        def after_create(record)
          description = "#{record.class.name} was created"
          publish_activity_feed_items record, description
        end

        def after_update(record)
          description = "#{record.class.name} was updated"
          publish_activity_feed_items record, description
        end

        def after_destroy(record)
          description = "#{record.class.name} was deleted"
          publish_activity_feed_items record, description
        end

        def publish_activity_feed_items(record, description)
          record.activity_feed_item_subscribers.each do |subscriber|
            ActivityFeedItem.create :user => subscriber, :description => description
          end
        end

        private :publish_activity_feed_items
      end
    end

Inside the after_create, after_destroy and after_update methods all calls will be called _without_ listeners, to prevent recursion.  If you need listeners to be turned on during those blocks, you'll have to set them yourself within the blocks.

## Turning off listeners in specs

When unit testing if your listeners are all firing your unit tests become integration tests.  To avoid this, you can easily turn off listeners for all specs all the time:

    Spec::Runner.configure do |config|
      config.before(:each) do
        ActiveModelListener.listeners.clear
      end
    end

Then, when you want them back on again, you can either turn them back on for a spec:

    describe "Integrating with listeners" do
      before do
        ActiveModelListener.listeners << FooListener
      end
    end

## Specifying a subset of listeners to use

When doing data imports, migrations or certain actions that need to only use certain listeners, you can easily specify which ones you'd like to use:

    ActiveModelListener.with_listeners AuditListener, ActivityListener do
      Article.create! :title => "foo"
    end

After the block runs, the original listeners are restored.

If you want to run some code with no listeners, you can do so with:

    ActiveModelListener.without_listeners do
      Article.create! :title => "foo"
    end

##  Um.  Don't observers already do this?

ActiveRecord Observers are:

 * Hard to apply to large numbers of models (you have to explicitly declare every one)
 * Hard to turn off in tests
 * Hard to selectively enable / disable

ActiveModelListener applies to all ActiveRecord models anywhere in your app, all the time.  ActiveModelListener listeners are very easy to turn off during unit tests as well.

## Copyright

Copyright (c) 2009 Jeff Dean. See LICENSE for details.

