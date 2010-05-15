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

describe ActiveModelListener do
  before do
    build_model :articles do
      string :title
    end

    build_model :editorials, :superclass => Article do
    end

    ActiveModelListener.listeners.clear
  end

  describe "with_listeners" do
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

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
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

    it "fires no listeners" do
      FooListener.should_not_receive(:after_create)
      BarListener.should_not_receive(:after_create)

      ActiveModelListener.without_listeners do
        Article.create! :title => "foo"
      end
    end
  end

  describe "callback methods" do
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

    it "should turn off other listeners" do
      FooListener.should_receive(:after_create).once
      Article.create! :title => "foo"
    end

    it "should not be run twice for inherited models" do
      FooListener.should_receive(:after_create).once
      Editorial.create! :title => "foo"
    end
  end

  describe "after create" do
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

    it "should fire all wired up events" do
      FooListener.should_receive(:after_create)
      BarListener.should_receive(:after_create)
      Article.create! :title => "foo"
    end
  end

  describe "after update" do
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

    it "should fire all wired up events" do
      article = Article.create
      FooListener.should_receive(:after_update).with(article)
      BarListener.should_receive(:after_update).with(article)
      article.save
    end
  end

  describe "after destroy" do
    before do
      ActiveModelListener.listeners << FooListener
      ActiveModelListener.listeners << BarListener
    end

    it "should fire all wired up events" do
      article = Article.create
      FooListener.should_receive(:after_destroy).with(article)
      BarListener.should_receive(:after_destroy).with(article)
      article.destroy
    end
  end

  describe "a listener with missing methods" do
    before do
      ActiveModelListener.listeners << SimpleListener
    end

    it "should not fire the missing methods" do
      article = Article.create
      proc do
        article.destroy
      end.should_not raise_error
    end
  end

  describe "a listener with missing methods" do
    before do
      ActiveModelListener.listeners << SimpleListener
    end

    it "should not fire the missing methods" do
      article = Article.create
      proc do
        article.destroy
      end.should_not raise_error
    end
  end

  ["FooListener", :foo_listener, "foo_listener"].each do |name|
    it "work when specifying with a format like #{name}" do
      ActiveModelListener.listeners << name
      FooListener.should_receive(:after_create)
      Article.create
    end
  end

end
