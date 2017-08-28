require 'test_helper'

describe StreakClient::Pipeline do

  before do
    @pipeline = StreakClient::Pipeline.create(
        name: "Test Pipeline",
        description: "Test pipeline for streak_client gem.",
        stageNames: "Test Stage")
  end

  after do
    @pipeline.boxes.each { |box| StreakClient::Box.delete(box.boxKey) }
    StreakClient::Pipeline.delete(@pipeline.pipelineKey)
  end

  it "can create one" do
    @pipeline.pipelineKey.wont_be_nil
  end

  it "can find one" do
    found = StreakClient::Pipeline.find(@pipeline.pipelineKey)
    found.name.must_equal "Test Pipeline"
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
    @pipeline.stages.last.name.must_equal "Stage 1"
  end

  it "can edit its properties" do
    @pipeline.name = "New Name"
    @pipeline.save!
    changed_pipeline = StreakClient::Pipeline.find(@pipeline.pipelineKey)
    changed_pipeline.name.must_equal "New Name"
  end

  it "can add and list fields" do
    @pipeline.add_field(name: "Test Field", type: "TEXT_INPUT")
    @pipeline.fields.last.name.must_equal "Test Field"
  end

end

