require 'minitest/spec'
require 'minitest/autorun'
require 'test_helper'

describe StreakClient::Pipeline do

  before(:each) do
    @pipeline = StreakClient::Pipeline.create(name: "Test", description: "T")
  end

  after(:each) do
    StreakClient::Pipeline.delete(@pipeline.pipelineKey)
  end

  it "can create one" do
    @pipeline.pipelineKey.wont_be_nil
  end

  it "can find one" do
    found = StreakClient::Pipeline.find(@pipeline.pipelineKey)
    found.name.must_equal "Test"
  end

  it "can find all" do
    all = StreakClient::Pipeline.all
    all.size.must_be :>, 0
  end

  it "can add and list boxes" do
    @pipeline.add_box(name: "Box")
    @pipeline.boxes.first.name.must_equal "Box"
  end

  it "can add and list stages" do
    @pipeline.add_stage(name: "Stage 1")
    @pipeline.stages.first.name.must_equal "Stage 1"
  end

  it "can edit its properties" do
    pipeline_key = @pipeline.pipelineKey
    @pipeline.name = "New Name"
    @pipeline.save!
    changed_pipeline = StreakClient::Pipeline.find(pipeline_key)
    changed_pipeline.name.must_equal "New Name"
  end

  it "can add and list fields" do
    @pipeline.add_field(name: "Person", type: "PEOPLE")
    @pipeline.fields.first.name.must_equal "Person"
  end
  
end

