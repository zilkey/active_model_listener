require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class GenericListener
  def self.after_create(object)
    object.class.create
  end
  def self.after_update(object)
  end
  def self.after_destroy(object)
  end
end

class SimpleListener
end

class FooListener < GenericListener
end

class BarListener < GenericListener
end

class BazListener < GenericListener
end

describe ActiveModelListener do
  before do
    build_model :articles do
      string :title
    end

    ActiveModelListener.listeners.clear
    ActiveModelListener.listeners << FooListener
    ActiveModelListener.listeners << BarListener
  end

  describe "with_listeners" do
    it "only fires those listeners that are present" do
      FooListener.should_receive(:after_create)
      BarListener.should_not_receive(:after_create)

      ActiveModelListener.with_listeners([FooListener]) do
        Article.create! :title => "foo"
      end
    end

    it "splats the args" do
      FooListener.should_receive(:after_create)
      BarListener.should_receive(:after_create)
      BarListener.should_not_receive(:after_create)

      ActiveModelListener.with_listeners(FooListener, BarListener) do
        Article.create! :title => "foo"
      end
    end
  end

  describe "without_listeners" do
    it "fires no listeners" do
      FooListener.should_not_receive(:after_create)
      BarListener.should_not_receive(:after_create)

      ActiveModelListener.without_listeners do
        Article.create! :title => "foo"
      end
    end
  end

  describe "callback methods" do
    it "should turn off other listeners" do
      FooListener.should_receive(:after_create).once
      Article.create! :title => "foo"
    end
  end

  describe "after create" do
    it "should fire off all wired up events" do
      FooListener.should_receive(:after_create)
      BarListener.should_receive(:after_create)
      Article.create! :title => "foo"
    end
  end

  describe "after update" do
    it "should fire off all wired up events" do
      article = Article.create
      FooListener.should_receive(:after_update).with(article)
      BarListener.should_receive(:after_update).with(article)
      article.save
    end
  end

  describe "after destroy" do
    it "should fire off all wired up events" do
      article = Article.create
      FooListener.should_receive(:after_destroy).with(article)
      BarListener.should_receive(:after_destroy).with(article)
      article.destroy
    end
  end

  describe "a listener with missing methods" do
    before do
      ActiveModelListener.listeners.clear
      ActiveModelListener.listeners << SimpleListener
    end
      
    it "should not fire off the missing methods" do
      article = Article.create
      proc do
        article.destroy
      end.should_not raise_error
    end
  end

end
