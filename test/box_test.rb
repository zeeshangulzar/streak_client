require 'test_helper'

describe StreakClient::Box do

  before(:each) do
    @pipeline = StreakClient::Pipeline.create(name: "Test Boxes", description: "T", stageNames: "Test Stage")
    @box = StreakClient::Box.create(@pipeline.pipelineKey, { name: "Test Box" })
  end

  after(:each) do
    @pipeline.boxes.each { |box| StreakClient::Box.delete(box.boxKey) }
    StreakClient::Pipeline.delete(@pipeline.pipelineKey)
  end

  it "can create one" do
    @box.boxKey.wont_be_nil
  end

  it "can find one" do
    found = StreakClient::Box.find(@box.boxKey)
    found.name.must_equal "Test Box"
  end

  it "can delete one" do
    StreakClient::Box.delete(@box.boxKey)

    assert_raises(RestClient::NotFound) do
      StreakClient::Box.find(@box.boxKey)
    end
  end

  it "can find all" do
    all = StreakClient::Box.all
    all.size.must_be :>, 0
    all.first.name.must_equal "Test Box"
  end

  it "can edit one" do
    box_key = @box.boxKey
    @box.name = "New Name"
    @box.save!
    changed_box = StreakClient::Box.find(box_key)
    changed_box.name.must_equal "New Name"
  end

  it "can add a comment" do
    response = @box.add_comment("Comment")
    response["message"].must_equal "Comment"
  end

  it "can set field value" do
    response = @pipeline.add_field(name: "Test field", type: "TEXT_INPUT")
    key = response.key
    response = @box.set_field(key,"test@example.org")
    response["value"].must_equal "test@example.org"
  end

  it "can add a thread" do
    # TODO
  end

  it 'can add and list tasks' do
    @box.list_tasks.must_be_empty

    @box.add_task('Test Task',(Time.now + 24*60*60).to_f.to_i * 1000)
    @box.list_tasks.first['text'].must_equal 'Test Task'
  end

  it 'can delete task' do
    response = @box.add_task('Test Task',(Time.now + 24*60*60).to_f.to_i * 1000)
    @box.delete_task(response['key'])

    @box.list_tasks.must_be_empty
  end

end

